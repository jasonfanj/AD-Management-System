"""
审计相关路由
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from models import AuditLog, LoginLog, db
from datetime import datetime, timedelta
from sqlalchemy import and_, or_

audit_bp = Blueprint('audit', __name__)

@audit_bp.route('/logs', methods=['GET'])
@jwt_required()
def get_audit_logs():
    """获取审计日志"""
    try:
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 50))
        action = request.args.get('action')
        resource_type = request.args.get('resource_type')
        username = request.args.get('username')
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        query = AuditLog.query
        
        # 过滤条件
        if action:
            query = query.filter(AuditLog.action == action)
        if resource_type:
            query = query.filter(AuditLog.resource_type == resource_type)
        if username:
            query = query.filter(AuditLog.username == username)
        if start_date:
            start = datetime.fromisoformat(start_date.replace('Z', '+00:00'))
            query = query.filter(AuditLog.created_at >= start)
        if end_date:
            end = datetime.fromisoformat(end_date.replace('Z', '+00:00'))
            query = query.filter(AuditLog.created_at <= end)
        
        # 排序和分页
        query = query.order_by(AuditLog.created_at.desc())
        pagination = query.paginate(page=page, per_page=per_page, error_out=False)
        
        logs = [log.to_dict() for log in pagination.items]
        
        return jsonify({
            'logs': logs,
            'total': pagination.total,
            'page': page,
            'per_page': per_page,
            'pages': pagination.pages
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@audit_bp.route('/login-logs', methods=['GET'])
@jwt_required()
def get_login_logs():
    """获取登录日志"""
    try:
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 50))
        username = request.args.get('username')
        status = request.args.get('status')
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        query = LoginLog.query
        
        # 过滤条件
        if username:
            query = query.filter(LoginLog.username == username)
        if status:
            query = query.filter(LoginLog.status == status)
        if start_date:
            start = datetime.fromisoformat(start_date.replace('Z', '+00:00'))
            query = query.filter(LoginLog.created_at >= start)
        if end_date:
            end = datetime.fromisoformat(end_date.replace('Z', '+00:00'))
            query = query.filter(LoginLog.created_at <= end)
        
        # 排序和分页
        query = query.order_by(LoginLog.created_at.desc())
        pagination = query.paginate(page=page, per_page=per_page, error_out=False)
        
        logs = [log.to_dict() for log in pagination.items]
        
        return jsonify({
            'logs': logs,
            'total': pagination.total,
            'page': page,
            'per_page': per_page,
            'pages': pagination.pages
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@audit_bp.route('/statistics', methods=['GET'])
@jwt_required()
def get_statistics():
    """获取审计统计信息"""
    try:
        days = int(request.args.get('days', 30))
        end_date = datetime.utcnow()
        start_date = end_date - timedelta(days=days)
        
        # 操作统计
        action_stats = db.session.query(
            AuditLog.action,
            db.func.count(AuditLog.id).label('count')
        ).filter(
            AuditLog.created_at >= start_date
        ).group_by(AuditLog.action).all()
        
        # 登录统计
        login_stats = db.session.query(
            LoginLog.status,
            db.func.count(LoginLog.id).label('count')
        ).filter(
            LoginLog.created_at >= start_date
        ).group_by(LoginLog.status).all()
        
        # 每日操作趋势
        daily_operations = db.session.query(
            db.func.date(AuditLog.created_at).label('date'),
            db.func.count(AuditLog.id).label('count')
        ).filter(
            AuditLog.created_at >= start_date
        ).group_by(db.func.date(AuditLog.created_at)).all()
        
        return jsonify({
            'action_stats': {stat[0]: stat[1] for stat in action_stats},
            'login_stats': {stat[0]: stat[1] for stat in login_stats},
            'daily_operations': [{'date': str(stat[0]), 'count': stat[1]} for stat in daily_operations]
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@audit_bp.route('/export', methods=['GET'])
@jwt_required()
def export_logs():
    """导出审计日志"""
    try:
        # TODO: 实现CSV/Excel导出功能
        return jsonify({'error': '功能开发中'}), 501
    except Exception as e:
        return jsonify({'error': str(e)}), 500

