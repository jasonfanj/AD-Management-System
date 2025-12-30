# 路由模块
from routes.auth import auth_bp
from routes.ad import ad_bp
from routes.selfservice import selfservice_bp
from routes.audit import audit_bp
from routes.system import system_bp

__all__ = ['auth_bp', 'ad_bp', 'selfservice_bp', 'audit_bp', 'system_bp']

