"""
数据库模型定义
"""
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

# 延迟导入 db 以避免循环导入
# 在 app.py 中，db 会在导入 models 之前初始化
try:
    from app import db
except ImportError:
    # 如果 app 还未初始化，创建一个占位符
    db = None

class User(db.Model if db else object):
    """系统用户表"""
    __tablename__ = 'users'
    
    if db:
        id = db.Column(db.Integer, primary_key=True)
        username = db.Column(db.String(80), unique=True, nullable=False)
        password_hash = db.Column(db.String(255), nullable=False)
        email = db.Column(db.String(120), unique=True, nullable=True)
        full_name = db.Column(db.String(100), nullable=True)
        role = db.Column(db.String(20), default='user')  # admin, user, auditor
        is_active = db.Column(db.Boolean, default=True)
        created_at = db.Column(db.DateTime, default=datetime.utcnow)
        last_login = db.Column(db.DateTime, nullable=True)
    
    def set_password(self, password):
        """设置密码"""
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """验证密码"""
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'full_name': self.full_name,
            'role': self.role,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'last_login': self.last_login.isoformat() if self.last_login else None,
        }

class ADAccount(db.Model if db else object):
    """AD账户信息表（缓存）"""
    __tablename__ = 'ad_accounts'
    
    if db:
        id = db.Column(db.Integer, primary_key=True)
        sam_account_name = db.Column(db.String(100), unique=True, nullable=False)
        display_name = db.Column(db.String(200), nullable=True)
        email = db.Column(db.String(200), nullable=True)
        department = db.Column(db.String(100), nullable=True)
        title = db.Column(db.String(100), nullable=True)
        manager = db.Column(db.String(200), nullable=True)
        ou_path = db.Column(db.String(500), nullable=True)
        is_enabled = db.Column(db.Boolean, default=True)
        last_logon = db.Column(db.DateTime, nullable=True)
        password_last_set = db.Column(db.DateTime, nullable=True)
        password_expires = db.Column(db.DateTime, nullable=True)
        created_at = db.Column(db.DateTime, default=datetime.utcnow)
        updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'sam_account_name': self.sam_account_name,
            'display_name': self.display_name,
            'email': self.email,
            'department': self.department,
            'title': self.title,
            'manager': self.manager,
            'ou_path': self.ou_path,
            'is_enabled': self.is_enabled,
            'last_logon': self.last_logon.isoformat() if self.last_logon else None,
            'password_last_set': self.password_last_set.isoformat() if self.password_last_set else None,
            'password_expires': self.password_expires.isoformat() if self.password_expires else None,
        }

class AuditLog(db.Model if db else object):
    """审计日志表"""
    __tablename__ = 'audit_logs'
    
    if db:
        id = db.Column(db.Integer, primary_key=True)
        user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
        username = db.Column(db.String(80), nullable=True)
        action = db.Column(db.String(50), nullable=False)  # create, update, delete, login, etc.
        resource_type = db.Column(db.String(50), nullable=True)  # user, group, ou, etc.
        resource_id = db.Column(db.String(100), nullable=True)
        resource_name = db.Column(db.String(200), nullable=True)
        details = db.Column(db.Text, nullable=True)  # JSON格式的详细信息
        ip_address = db.Column(db.String(50), nullable=True)
        user_agent = db.Column(db.String(500), nullable=True)
        status = db.Column(db.String(20), default='success')  # success, failed
        error_message = db.Column(db.Text, nullable=True)
        created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    
    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'username': self.username,
            'action': self.action,
            'resource_type': self.resource_type,
            'resource_id': self.resource_id,
            'resource_name': self.resource_name,
            'details': self.details,
            'ip_address': self.ip_address,
            'user_agent': self.user_agent,
            'status': self.status,
            'error_message': self.error_message,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }

class LoginLog(db.Model if db else object):
    """登录日志表"""
    __tablename__ = 'login_logs'
    
    if db:
        id = db.Column(db.Integer, primary_key=True)
        username = db.Column(db.String(80), nullable=False, index=True)
        ip_address = db.Column(db.String(50), nullable=True)
        user_agent = db.Column(db.String(500), nullable=True)
        status = db.Column(db.String(20), nullable=False)  # success, failed
        failure_reason = db.Column(db.String(200), nullable=True)
        created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    
    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'username': self.username,
            'ip_address': self.ip_address,
            'user_agent': self.user_agent,
            'status': self.status,
            'failure_reason': self.failure_reason,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }

class PasswordResetRequest(db.Model if db else object):
    """密码重置请求表"""
    __tablename__ = 'password_reset_requests'
    
    if db:
        id = db.Column(db.Integer, primary_key=True)
        sam_account_name = db.Column(db.String(100), nullable=False, index=True)
        email = db.Column(db.String(200), nullable=True)
        token = db.Column(db.String(100), unique=True, nullable=False)
        status = db.Column(db.String(20), default='pending')  # pending, completed, expired
        requested_at = db.Column(db.DateTime, default=datetime.utcnow)
        completed_at = db.Column(db.DateTime, nullable=True)
        expires_at = db.Column(db.DateTime, nullable=False)
    
    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'sam_account_name': self.sam_account_name,
            'email': self.email,
            'token': self.token,
            'status': self.status,
            'requested_at': self.requested_at.isoformat() if self.requested_at else None,
            'completed_at': self.completed_at.isoformat() if self.completed_at else None,
            'expires_at': self.expires_at.isoformat() if self.expires_at else None,
        }

class SystemConfig(db.Model if db else object):
    """系统配置表"""
    __tablename__ = 'system_configs'
    
    if db:
        id = db.Column(db.Integer, primary_key=True)
        config_key = db.Column(db.String(100), unique=True, nullable=False)
        config_value = db.Column(db.Text, nullable=True)
        description = db.Column(db.String(500), nullable=True)
        updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
        updated_by = db.Column(db.String(80), nullable=True)
    
    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'config_key': self.config_key,
            'config_value': self.config_value,
            'description': self.description,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'updated_by': self.updated_by,
        }
    
    @staticmethod
    def get_config(key, default=None):
        """获取配置值"""
        if not db:
            return default
        config = SystemConfig.query.filter_by(config_key=key).first()
        if config:
            return config.config_value
        return default
    
    @staticmethod
    def set_config(key, value, description=None, updated_by=None):
        """设置配置值"""
        if not db:
            return None
        config = SystemConfig.query.filter_by(config_key=key).first()
        if config:
            config.config_value = value
            if description:
                config.description = description
            if updated_by:
                config.updated_by = updated_by
            config.updated_at = datetime.utcnow()
        else:
            config = SystemConfig(
                config_key=key,
                config_value=value,
                description=description,
                updated_by=updated_by
            )
            db.session.add(config)
        db.session.commit()
        return config
    
    @staticmethod
    def get_ad_config():
        """获取AD配置（从数据库或配置文件）"""
        from config import AD_CONFIG
        
        if not db:
            return AD_CONFIG
        
        # 优先从数据库读取
        server = SystemConfig.get_config('ad_server', AD_CONFIG.get('SERVER', ''))
        base_dn = SystemConfig.get_config('ad_base_dn', AD_CONFIG.get('BASE_DN', ''))
        user_dn = SystemConfig.get_config('ad_user_dn', AD_CONFIG.get('USER_DN', ''))
        password = SystemConfig.get_config('ad_password', AD_CONFIG.get('PASSWORD', ''))
        use_ssl = SystemConfig.get_config('ad_use_ssl', str(AD_CONFIG.get('USE_SSL', False))).lower() == 'true'
        use_tls = SystemConfig.get_config('ad_use_tls', str(AD_CONFIG.get('USE_TLS', True))).lower() == 'true'
        
        return {
            'SERVER': server,
            'BASE_DN': base_dn,
            'USER_DN': user_dn,
            'PASSWORD': password,
            'USE_SSL': use_ssl,
            'USE_TLS': use_tls,
        }
