"""
认证相关路由
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from models import User, LoginLog, db
from datetime import datetime
from ad_connector import ADConnector

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['POST'])
def login():
    """用户登录"""
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    
    if not username or not password:
        return jsonify({'error': '用户名和密码不能为空'}), 400
    
    # 记录登录尝试
    ip_address = request.remote_addr
    user_agent = request.headers.get('User-Agent', '')
    
    # 查找用户
    user = User.query.filter_by(username=username).first()
    
    if not user or not user.check_password(password):
        # 记录失败登录
        login_log = LoginLog(
            username=username,
            ip_address=ip_address,
            user_agent=user_agent,
            status='failed',
            failure_reason='用户名或密码错误'
        )
        db.session.add(login_log)
        db.session.commit()
        
        return jsonify({'error': '用户名或密码错误'}), 401
    
    if not user.is_active:
        login_log = LoginLog(
            username=username,
            ip_address=ip_address,
            user_agent=user_agent,
            status='failed',
            failure_reason='账户已禁用'
        )
        db.session.add(login_log)
        db.session.commit()
        
        return jsonify({'error': '账户已禁用'}), 403
    
    # 更新最后登录时间
    user.last_login = datetime.utcnow()
    db.session.commit()
    
    # 记录成功登录
    login_log = LoginLog(
        username=username,
        ip_address=ip_address,
        user_agent=user_agent,
        status='success'
    )
    db.session.add(login_log)
    db.session.commit()
    
    # 生成JWT token
    access_token = create_access_token(identity=username)
    
    return jsonify({
        'access_token': access_token,
        'user': user.to_dict()
    }), 200

@auth_bp.route('/me', methods=['GET'])
@jwt_required()
def get_current_user():
    """获取当前用户信息"""
    username = get_jwt_identity()
    user = User.query.filter_by(username=username).first()
    
    if not user:
        return jsonify({'error': '用户不存在'}), 404
    
    return jsonify(user.to_dict()), 200

@auth_bp.route('/change-password', methods=['POST'])
@jwt_required()
def change_password():
    """修改密码"""
    username = get_jwt_identity()
    data = request.get_json()
    old_password = data.get('old_password')
    new_password = data.get('new_password')
    
    if not old_password or not new_password:
        return jsonify({'error': '旧密码和新密码不能为空'}), 400
    
    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'error': '用户不存在'}), 404
    
    if not user.check_password(old_password):
        return jsonify({'error': '旧密码错误'}), 400
    
    # 验证新密码强度
    if len(new_password) < 8:
        return jsonify({'error': '新密码长度至少8位'}), 400
    
    user.set_password(new_password)
    db.session.commit()
    
    return jsonify({'message': '密码修改成功'}), 200

