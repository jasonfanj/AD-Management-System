"""
AD管理相关路由
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import User, AuditLog, db
from ad_connector import ADConnector
from datetime import datetime
import json

ad_bp = Blueprint('ad', __name__)

def log_audit(action, resource_type, resource_id=None, resource_name=None, details=None, status='success', error_message=None):
    """记录审计日志"""
    username = get_jwt_identity()
    user = User.query.filter_by(username=username).first()
    
    audit = AuditLog(
        user_id=user.id if user else None,
        username=username,
        action=action,
        resource_type=resource_type,
        resource_id=resource_id,
        resource_name=resource_name,
        details=json.dumps(details, ensure_ascii=False) if details else None,
        ip_address=request.remote_addr,
        user_agent=request.headers.get('User-Agent', ''),
        status=status,
        error_message=error_message
    )
    db.session.add(audit)
    db.session.commit()

@ad_bp.route('/users', methods=['GET'])
@jwt_required()
def list_users():
    """获取用户列表"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败，请检查配置'}), 500
        
        search_filter = request.args.get('filter', '(objectClass=user)')
        users = ad.search_users(search_filter=search_filter)
        ad.disconnect()
        
        return jsonify({'users': users, 'total': len(users)}), 200
    except Exception as e:
        log_audit('list_users', 'user', status='failed', error_message=str(e))
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/<sam_account_name>', methods=['GET'])
@jwt_required()
def get_user(sam_account_name):
    """获取用户详情"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        user = ad.get_user(sam_account_name)
        ad.disconnect()
        
        if not user:
            return jsonify({'error': '用户不存在'}), 404
        
        return jsonify(user), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users', methods=['POST'])
@jwt_required()
def create_user():
    """创建用户"""
    try:
        data = request.get_json()
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        ou_dn = data.get('ou_dn')
        success, message = ad.create_user(data, ou_dn)
        ad.disconnect()
        
        if success:
            log_audit('create', 'user', resource_id=data.get('sAMAccountName'), 
                     resource_name=data.get('displayName'), details=data)
            return jsonify({'message': message}), 201
        else:
            log_audit('create', 'user', resource_id=data.get('sAMAccountName'), 
                     status='failed', error_message=message)
            return jsonify({'error': message}), 400
    except Exception as e:
        log_audit('create', 'user', status='failed', error_message=str(e))
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/<sam_account_name>', methods=['PUT'])
@jwt_required()
def update_user(sam_account_name):
    """更新用户"""
    try:
        data = request.get_json()
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.update_user(sam_account_name, data)
        ad.disconnect()
        
        if success:
            log_audit('update', 'user', resource_id=sam_account_name, 
                     resource_name=sam_account_name, details=data)
            return jsonify({'message': message}), 200
        else:
            log_audit('update', 'user', resource_id=sam_account_name, 
                     status='failed', error_message=message)
            return jsonify({'error': message}), 400
    except Exception as e:
        log_audit('update', 'user', resource_id=sam_account_name, 
                 status='failed', error_message=str(e))
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/<sam_account_name>', methods=['DELETE'])
@jwt_required()
def delete_user(sam_account_name):
    """删除用户"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.delete_user(sam_account_name)
        ad.disconnect()
        
        if success:
            log_audit('delete', 'user', resource_id=sam_account_name, 
                     resource_name=sam_account_name)
            return jsonify({'message': message}), 200
        else:
            log_audit('delete', 'user', resource_id=sam_account_name, 
                     status='failed', error_message=message)
            return jsonify({'error': message}), 400
    except Exception as e:
        log_audit('delete', 'user', resource_id=sam_account_name, 
                 status='failed', error_message=str(e))
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/<sam_account_name>/reset-password', methods=['POST'])
@jwt_required()
def reset_password(sam_account_name):
    """重置密码"""
    try:
        data = request.get_json()
        new_password = data.get('new_password')
        
        if not new_password:
            return jsonify({'error': '新密码不能为空'}), 400
        
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.reset_password(sam_account_name, new_password)
        ad.disconnect()
        
        if success:
            log_audit('reset_password', 'user', resource_id=sam_account_name)
            return jsonify({'message': message}), 200
        else:
            log_audit('reset_password', 'user', resource_id=sam_account_name, 
                     status='failed', error_message=message)
            return jsonify({'error': message}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/<sam_account_name>/unlock', methods=['POST'])
@jwt_required()
def unlock_user(sam_account_name):
    """解锁用户"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.unlock_user(sam_account_name)
        ad.disconnect()
        
        if success:
            log_audit('unlock', 'user', resource_id=sam_account_name)
            return jsonify({'message': message}), 200
        else:
            log_audit('unlock', 'user', resource_id=sam_account_name, 
                     status='failed', error_message=message)
            return jsonify({'error': message}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/<sam_account_name>/enable', methods=['POST'])
@jwt_required()
def enable_user(sam_account_name):
    """启用用户"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.enable_user(sam_account_name)
        ad.disconnect()
        
        if success:
            log_audit('enable', 'user', resource_id=sam_account_name)
            return jsonify({'message': message}), 200
        else:
            return jsonify({'error': message}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/<sam_account_name>/disable', methods=['POST'])
@jwt_required()
def disable_user(sam_account_name):
    """禁用用户"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        success, message = ad.disable_user(sam_account_name)
        ad.disconnect()
        
        if success:
            log_audit('disable', 'user', resource_id=sam_account_name)
            return jsonify({'message': message}), 200
        else:
            return jsonify({'error': message}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/users/batch', methods=['POST'])
@jwt_required()
def batch_operations():
    """批量操作"""
    try:
        data = request.get_json()
        operation = data.get('operation')  # reset_password, unlock, enable, disable, delete
        sam_account_names = data.get('users', [])
        
        if not operation or not sam_account_names:
            return jsonify({'error': '操作类型和用户列表不能为空'}), 400
        
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        results = []
        for sam_account_name in sam_account_names:
            if operation == 'reset_password':
                success, message = ad.reset_password(sam_account_name, data.get('new_password', ''))
            elif operation == 'unlock':
                success, message = ad.unlock_user(sam_account_name)
            elif operation == 'enable':
                success, message = ad.enable_user(sam_account_name)
            elif operation == 'disable':
                success, message = ad.disable_user(sam_account_name)
            elif operation == 'delete':
                success, message = ad.delete_user(sam_account_name)
            else:
                success, message = False, '不支持的操作'
            
            results.append({
                'sam_account_name': sam_account_name,
                'success': success,
                'message': message
            })
        
        ad.disconnect()
        
        log_audit('batch_operation', 'user', details={'operation': operation, 'count': len(sam_account_names)})
        
        return jsonify({'results': results}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/ous', methods=['GET'])
@jwt_required()
def list_ous():
    """获取OU列表"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        ous = ad.search_ous()
        ad.disconnect()
        
        return jsonify({'ous': ous, 'total': len(ous)}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ad_bp.route('/groups', methods=['GET'])
@jwt_required()
def list_groups():
    """获取组列表"""
    try:
        ad = ADConnector()
        if not ad.connect():
            return jsonify({'error': 'AD连接失败'}), 500
        
        groups = ad.search_groups()
        ad.disconnect()
        
        return jsonify({'groups': groups, 'total': len(groups)}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

