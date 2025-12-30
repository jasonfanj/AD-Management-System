"""
系统管理路由
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import datetime
from models import User, db
from ad_connector import ADConnector

system_bp = Blueprint('system', __name__)

@system_bp.route('/test-ad-connection', methods=['POST'])
@jwt_required()
def test_ad_connection():
    """测试AD连接"""
    try:
        ad = ADConnector()
        if ad.connect():
            ad.disconnect()
            return jsonify({'message': 'AD连接成功'}), 200
        else:
            return jsonify({'error': 'AD连接失败，请检查配置'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@system_bp.route('/config', methods=['GET'])
@jwt_required()
def get_config():
    """获取系统配置"""
    try:
        # 检查当前用户是否为管理员
        username = get_jwt_identity()
        user = User.query.filter_by(username=username).first()
        
        if not user or user.role != 'admin':
            return jsonify({'error': '权限不足'}), 403
        
        from config import AD_CONFIG, PASSWORD_POLICY, AUDIT_CONFIG
        
        return jsonify({
            'ad_config': {
                'server': AD_CONFIG['SERVER'],
                'base_dn': AD_CONFIG['BASE_DN'],
                'use_ssl': AD_CONFIG['USE_SSL'],
                'use_tls': AD_CONFIG['USE_TLS'],
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

