"""
系统管理路由
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import datetime
from models import User, SystemConfig, db
from ad_connector import ADConnector

system_bp = Blueprint('system', __name__)

def check_admin():
    """检查是否为管理员"""
    username = get_jwt_identity()
    user = User.query.filter_by(username=username).first()
    if not user or user.role != 'admin':
        return None
    return user

@system_bp.route('/test-ad-connection', methods=['POST'])
@jwt_required()
def test_ad_connection():
    """测试AD连接"""
    try:
        # 可以传入测试配置，或使用已保存的配置
        data = request.get_json() or {}
        
        if data:
            # 使用传入的配置进行测试
            test_config = {
                'SERVER': data.get('server', ''),
                'BASE_DN': data.get('base_dn', ''),
                'USER_DN': data.get('user_dn', ''),
                'PASSWORD': data.get('password', ''),
                'USE_SSL': data.get('use_ssl', False),
                'USE_TLS': data.get('use_tls', True),
            }
            # 临时设置配置
            ad = ADConnector()
            ad.config = test_config
        else:
            # 使用已保存的配置
            ad = ADConnector()
        
        if ad.connect():
            ad.disconnect()
            return jsonify({'message': 'AD连接成功'}), 200
        else:
            return jsonify({'error': 'AD连接失败，请检查配置'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@system_bp.route('/ad-config', methods=['GET'])
@jwt_required()
def get_ad_config():
    """获取AD配置"""
    try:
        user = check_admin()
        if not user:
            return jsonify({'error': '权限不足'}), 403
        
        config = SystemConfig.get_ad_config()
        
        # 获取最后更新时间
        server_config = SystemConfig.query.filter_by(config_key='ad_server').first()
        last_updated = server_config.updated_at.isoformat() if server_config and server_config.updated_at else None
        updated_by = server_config.updated_by if server_config else None
        
        # 密码不返回，只返回是否已配置
        return jsonify({
            'server': config['SERVER'],
            'base_dn': config['BASE_DN'],
            'user_dn': config['USER_DN'],
            'password': '***' if config['PASSWORD'] else '',  # 不返回真实密码
            'use_ssl': config['USE_SSL'],
            'use_tls': config['USE_TLS'],
            'is_configured': bool(config['SERVER'] and config['BASE_DN'] and config['USER_DN']),
            'last_updated': last_updated,
            'updated_by': updated_by
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@system_bp.route('/ad-config', methods=['POST'])
@jwt_required()
def save_ad_config():
    """保存AD配置"""
    try:
        user = check_admin()
        if not user:
            return jsonify({'error': '权限不足'}), 403
        
        data = request.get_json()
        if not data:
            return jsonify({'error': '配置数据不能为空'}), 400
        
        # 保存配置到数据库
        SystemConfig.set_config('ad_server', data.get('server', ''), 'AD服务器地址', user.username)
        SystemConfig.set_config('ad_base_dn', data.get('base_dn', ''), 'AD Base DN', user.username)
        SystemConfig.set_config('ad_user_dn', data.get('user_dn', ''), 'AD用户DN', user.username)
        SystemConfig.set_config('ad_password', data.get('password', ''), 'AD密码', user.username)
        SystemConfig.set_config('ad_use_ssl', str(data.get('use_ssl', False)), '是否使用SSL', user.username)
        SystemConfig.set_config('ad_use_tls', str(data.get('use_tls', True)), '是否使用TLS', user.username)
        
        return jsonify({'message': 'AD配置保存成功'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@system_bp.route('/config', methods=['GET'])
@jwt_required()
def get_config():
    """获取系统配置"""
    try:
        user = check_admin()
        if not user:
            return jsonify({'error': '权限不足'}), 403
        
        from config import PASSWORD_POLICY, AUDIT_CONFIG
        
        ad_config = SystemConfig.get_ad_config()
        
        return jsonify({
            'ad_config': {
                'server': ad_config['SERVER'],
                'base_dn': ad_config['BASE_DN'],
                'user_dn': ad_config['USER_DN'],
                'password': '***' if ad_config['PASSWORD'] else '',
                'use_ssl': ad_config['USE_SSL'],
                'use_tls': ad_config['USE_TLS'],
            },
            'password_policy': PASSWORD_POLICY,
            'audit_config': AUDIT_CONFIG
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@system_bp.route('/health', methods=['GET'])
def health_check():
    """健康检查"""
    return jsonify({
        'status': 'ok',
        'timestamp': datetime.utcnow().isoformat()
    }), 200

