"""
域控通-Web 主应用
运行简单：python app.py 启动后端，然后直接打开 frontend/index.html 即可使用
"""
from flask import Flask, send_from_directory
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_sqlalchemy import SQLAlchemy
import os
from pathlib import Path

# 导入配置
from config import (
    SQLALCHEMY_DATABASE_URI,
    SQLALCHEMY_TRACK_MODIFICATIONS,
    JWT_SECRET_KEY,
    JWT_ACCESS_TOKEN_EXPIRES,
    SECRET_KEY,
    UPLOAD_FOLDER,
    LOG_FOLDER
)

# 创建Flask应用
app = Flask(__name__, static_folder='frontend', static_url_path='')
app.config['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = SQLALCHEMY_TRACK_MODIFICATIONS
app.config['JWT_SECRET_KEY'] = JWT_SECRET_KEY
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = JWT_ACCESS_TOKEN_EXPIRES
app.config['SECRET_KEY'] = SECRET_KEY
app.config['UPLOAD_FOLDER'] = str(UPLOAD_FOLDER)
app.config['MAX_CONTENT_LENGTH'] = 10 * 1024 * 1024  # 10MB

# 初始化扩展
CORS(app)  # 允许跨域，方便直接打开HTML文件
db = SQLAlchemy(app)
jwt = JWTManager(app)

# 创建必要的目录
UPLOAD_FOLDER.mkdir(parents=True, exist_ok=True)
LOG_FOLDER.mkdir(parents=True, exist_ok=True)
Path('data').mkdir(parents=True, exist_ok=True)

# 注册蓝图
from routes import auth_bp, ad_bp, selfservice_bp, audit_bp, system_bp

app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(ad_bp, url_prefix='/api/ad')
app.register_blueprint(selfservice_bp, url_prefix='/api/selfservice')
app.register_blueprint(audit_bp, url_prefix='/api/audit')
app.register_blueprint(system_bp, url_prefix='/api/system')

# 提供静态文件服务（前端HTML）
@app.route('/')
def index():
    """提供前端HTML文件"""
    return send_from_directory('frontend', 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    """提供前端静态资源"""
    return send_from_directory('frontend', path)

# 错误处理
@app.errorhandler(404)
def not_found(error):
    return {'error': 'Not found'}, 404

@app.errorhandler(500)
def internal_error(error):
    return {'error': 'Internal server error'}, 500

# 初始化数据库
def init_db():
    """初始化数据库表"""
    with app.app_context():
        db.create_all()
        
        # 创建默认管理员账户
        from models import User
        admin = User.query.filter_by(username='admin').first()
        if not admin:
            admin = User(
                username='admin',
                password='admin123',  # 默认密码，首次登录后应修改
                email='admin@example.com',
                role='admin',
                is_active=True
            )
            admin.set_password('admin123')
            db.session.add(admin)
            db.session.commit()
            print('✓ 默认管理员账户已创建: admin / admin123')

if __name__ == '__main__':
    print('=' * 60)
    print('域控通-Web AD管理系统')
    print('=' * 60)
    print('初始化数据库...')
    init_db()
    print('后端服务启动中...')
    print(f'API地址: http://localhost/api')
    print(f'前端地址: 直接打开 frontend/index.html 文件')
    print(f'Web访问: http://localhost/')
    print('默认账户: admin / admin123')
    print('=' * 60)
    
    from config import HOST, PORT
    app.run(host=HOST, port=PORT, debug=True)

