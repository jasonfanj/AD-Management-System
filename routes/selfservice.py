"""
用户自助服务路由
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import PasswordResetRequest, AuditLog, db
from ad_connector import ADConnector
from datetime import datetime, timedelta
import secrets
import json

selfservice_bp = Blueprint('selfservice', __name__)

@selfservice_bp.route('/reset-password-request', methods=['POST'])
def request_password_reset():
    """请求密码重置"""
    try:
        data = request.get_json()
        sam_account_name = data.get('sam_account_name')
        email = data.get('email')
        
        if not sam_account_name:
            return jsonify({'error': '用户名不能为空'}), 400
        
        # 验证用户是否存在
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        user = ad.get_user(sam_account_name)
        ad.disconnect()
        
        if not user:
            return jsonify({'error': '用户不存在'}), 404
        
        # 生成重置token
        token = secrets.token_urlsafe(32)
        expires_at = datetime.utcnow() + timedelta(hours=24)
        
        # 保存重置请求
        reset_request = PasswordResetRequest(
            sam_account_name=sam_account_name,
            email=email or user.get('mail'),
            token=token,
            expires_at=expires_at
        )
        db.session.add(reset_request)
        db.session.commit()
        
        # TODO: 发送邮件通知（如果配置了邮件服务）
        
        return jsonify({
            'message': '密码重置请求已创建',
            'token': token  # 生产环境应该通过邮件发送
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@selfservice_bp.route('/reset-password', methods=['POST'])
def reset_password():
    """重置密码（使用token）"""
    try:
        data = request.get_json()
        token = data.get('token')
        new_password = data.get('new_password')
        
        if not token or not new_password:
            return jsonify({'error': 'Token和新密码不能为空'}), 400
        
        # 验证token
        reset_request = PasswordResetRequest.query.filter_by(
            token=token,
            status='pending'
        ).first()
        
        if not reset_request:
            return jsonify({'error': '无效的token'}), 400
        
        if reset_request.expires_at < datetime.utcnow():
            reset_request.status = 'expired'
            db.session.commit()
            return jsonify({'error': 'Token已过期'}), 400
        
        # 重置密码
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.reset_password(reset_request.sam_account_name, new_password)
        ad.disconnect()
        
        if success:
            reset_request.status = 'completed'
            reset_request.completed_at = datetime.utcnow()
            db.session.commit()
            
            # 记录审计日志
            audit = AuditLog(
                username=reset_request.sam_account_name,
                action='self_reset_password',
                resource_type='user',
                resource_id=reset_request.sam_account_name,
                ip_address=request.remote_addr,
                user_agent=request.headers.get('User-Agent', ''),
                status='success'
            )
            db.session.add(audit)
            db.session.commit()
            
            return jsonify({'message': '密码重置成功'}), 200
        else:
            return jsonify({'error': message}), 400
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@selfservice_bp.route('/unlock-account', methods=['POST'])
@jwt_required()
def unlock_account():
    """自助解锁账户"""
    try:
        username = get_jwt_identity()
        data = request.get_json()
        sam_account_name = data.get('sam_account_name', username)
        
        # 验证权限（只能解锁自己的账户，除非是管理员）
        # TODO: 添加权限检查
        
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.unlock_user(sam_account_name)
        ad.disconnect()
        
        if success:
            # 记录审计日志
            audit = AuditLog(
                username=username,
                action='self_unlock',
                resource_type='user',
                resource_id=sam_account_name,
                ip_address=request.remote_addr,
                user_agent=request.headers.get('User-Agent', ''),
                status='success'
            )
            db.session.add(audit)
            db.session.commit()
            
            return jsonify({'message': '账户解锁成功'}), 200
        else:
            return jsonify({'error': message}), 400
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@selfservice_bp.route('/update-profile', methods=['POST'])
@jwt_required()
def update_profile():
    """更新个人信息"""
    try:
        username = get_jwt_identity()
        data = request.get_json()
        
        # 只允许更新特定字段
        allowed_fields = ['mail', 'telephoneNumber', 'mobile', 'streetAddress', 'department', 'title']
        updates = {k: v for k, v in data.items() if k in allowed_fields}
        
        if not updates:
            return jsonify({'error': '没有可更新的字段'}), 400
        
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.update_user(username, updates)
        ad.disconnect()
        
        if success:
            # 记录审计日志
            audit = AuditLog(
                username=username,
                action='update_profile',
                resource_type='user',
                resource_id=username,
                details=updates,
                ip_address=request.remote_addr,
                user_agent=request.headers.get('User-Agent', ''),
                status='success'
            )
            db.session.add(audit)
            db.session.commit()
            
            return jsonify({'message': '个人信息更新成功'}), 200
        else:
            return jsonify({'error': message}), 400
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@selfservice_bp.route('/my-info', methods=['GET'])
@jwt_required()
def get_my_info():
    """获取当前用户的AD信息"""
    try:
        username = get_jwt_identity()
        
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        user = ad.get_user(username)
        ad.disconnect()
        
        if not user:
            return jsonify({'error': '用户不存在'}), 404
        
        return jsonify(user), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

