"""
域控通-Web 配置文件
"""
import os
from pathlib import Path

# 项目根目录
BASE_DIR = Path(__file__).parent

# 数据库配置
SQLALCHEMY_DATABASE_URI = os.getenv(
    'DATABASE_URL',
    f'sqlite:///{BASE_DIR}/data/ad_management.db'
)
SQLALCHEMY_TRACK_MODIFICATIONS = False

# AD域配置
AD_CONFIG = {
    'SERVER': os.getenv('AD_SERVER', 'ldap://your-domain-controller:389'),
    'BASE_DN': os.getenv('AD_BASE_DN', 'dc=example,dc=com'),
    'USER_DN': os.getenv('AD_USER_DN', 'cn=admin,dc=example,dc=com'),
    'PASSWORD': os.getenv('AD_PASSWORD', ''),
    'USE_SSL': os.getenv('AD_USE_SSL', 'False').lower() == 'true',
    'USE_TLS': os.getenv('AD_USE_TLS', 'True').lower() == 'true',
}

# JWT配置
JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'your-secret-key-change-in-production')
JWT_ACCESS_TOKEN_EXPIRES = 86400  # 24小时
JWT_ALGORITHM = 'HS256'

# Flask配置
SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key-change-in-production')
DEBUG = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'

# 服务器配置
HOST = os.getenv('HOST', '0.0.0.0')
PORT = int(os.getenv('PORT', 80))

# 文件上传配置
UPLOAD_FOLDER = BASE_DIR / 'uploads'
MAX_UPLOAD_SIZE = 10 * 1024 * 1024  # 10MB
ALLOWED_EXTENSIONS = {'csv', 'xlsx', 'xls'}

# 日志配置
LOG_FOLDER = BASE_DIR / 'logs'
LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')

# 邮件配置（可选）
MAIL_CONFIG = {
    'SMTP_SERVER': os.getenv('SMTP_SERVER', ''),
    'SMTP_PORT': int(os.getenv('SMTP_PORT', 587)),
    'SMTP_USER': os.getenv('SMTP_USER', ''),
    'SMTP_PASSWORD': os.getenv('SMTP_PASSWORD', ''),
    'FROM_EMAIL': os.getenv('FROM_EMAIL', ''),
}

# 密码策略
PASSWORD_POLICY = {
    'MIN_LENGTH': 8,
    'REQUIRE_UPPERCASE': True,
    'REQUIRE_LOWERCASE': True,
    'REQUIRE_NUMBERS': True,
    'REQUIRE_SPECIAL': True,
    'MAX_AGE_DAYS': 90,
}

# 审计配置
AUDIT_CONFIG = {
    'ENABLE_FILE_AUDIT': True,
    'ENABLE_LOGIN_AUDIT': True,
    'ENABLE_CHANGE_AUDIT': True,
    'RETENTION_DAYS': 365,
}

