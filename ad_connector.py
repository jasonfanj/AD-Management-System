"""
AD域连接和操作模块
使用ldap3库连接Active Directory
"""
from ldap3 import Server, Connection, ALL, SUBTREE, MODIFY_REPLACE
from ldap3.core.exceptions import LDAPException, LDAPBindError
from datetime import datetime, timedelta
import json
from config import AD_CONFIG
from models import AuditLog, SystemConfig, db

class ADConnector:
    """AD域连接器"""
    
    def __init__(self):
        self.server = None
        self.conn = None
        # 优先从数据库读取配置，如果数据库没有则使用配置文件
        # 注意：需要在Flask应用上下文中调用
        try:
            self.config = SystemConfig.get_ad_config()
        except Exception as e:
            # 如果无法从数据库读取（如未初始化），使用配置文件
            print(f"警告: 无法从数据库读取AD配置，使用配置文件: {e}")
            self.config = AD_CONFIG
    
    def connect(self):
        """连接到AD域"""
        try:
            self.server = Server(
                self.config['SERVER'],
                get_info=ALL,
                use_ssl=self.config['USE_SSL']
            )
            
            self.conn = Connection(
                self.server,
                user=self.config['USER_DN'],
                password=self.config['PASSWORD'],
                auto_bind=True,
                raise_exceptions=True
            )
            
            if self.config['USE_TLS'] and not self.config['USE_SSL']:
                self.conn.start_tls()
            
            return True
        except LDAPBindError as e:
            print(f"AD连接失败: {e}")
            return False
        except Exception as e:
            print(f"AD连接错误: {e}")
            return False
    
    def disconnect(self):
        """断开AD连接"""
        if self.conn:
            self.conn.unbind()
            self.conn = None
    
    def _ensure_connected(self):
        """确保已连接"""
        if not self.conn or not self.conn.bound:
            return self.connect()
        return True
    
    def search_users(self, search_base=None, search_filter='(objectClass=user)', attributes=None):
        """搜索用户"""
        if not self._ensure_connected():
            return []
        
        if search_base is None:
            search_base = self.config['BASE_DN']
        
        if attributes is None:
            attributes = [
                'sAMAccountName', 'displayName', 'mail', 'department',
                'title', 'manager', 'distinguishedName', 'userAccountControl',
                'lastLogonTimestamp', 'pwdLastSet', 'accountExpires',
                'whenCreated', 'telephoneNumber', 'mobile', 'streetAddress'
            ]
        
        try:
            self.conn.search(
                search_base=search_base,
                search_filter=search_filter,
                search_scope=SUBTREE,
                attributes=attributes
            )
            
            users = []
            for entry in self.conn.entries:
                user_data = {}
                for attr in attributes:
                    value = getattr(entry, attr, None)
                    if value:
                        if isinstance(value, list) and len(value) > 0:
                            user_data[attr] = str(value[0])
                        else:
                            user_data[attr] = str(value)
                    else:
                        user_data[attr] = None
                
                # 处理特殊属性
                if 'userAccountControl' in user_data:
                    user_data['is_enabled'] = not (int(user_data['userAccountControl']) & 0x2)
                
                if 'lastLogonTimestamp' in user_data and user_data['lastLogonTimestamp']:
                    try:
                        timestamp = int(user_data['lastLogonTimestamp'])
                        user_data['last_logon'] = datetime.fromtimestamp(timestamp / 10000000 - 11644473600)
                    except:
                        user_data['last_logon'] = None
                
                users.append(user_data)
            
            return users
        except Exception as e:
            print(f"搜索用户失败: {e}")
            return []
    
    def get_user(self, sam_account_name):
        """获取单个用户信息"""
        search_filter = f'(&(objectClass=user)(sAMAccountName={sam_account_name}))'
        users = self.search_users(search_filter=search_filter)
        return users[0] if users else None
    
    def create_user(self, user_data, ou_dn=None):
        """创建AD用户"""
        if not self._ensure_connected():
            return False, "AD连接失败"
        
        try:
            sam_account_name = user_data.get('sAMAccountName')
            if not sam_account_name:
                return False, "用户名不能为空"
            
            # 构建用户DN
            if ou_dn:
                user_dn = f"CN={user_data.get('displayName', sam_account_name)},{ou_dn}"
            else:
                user_dn = f"CN={user_data.get('displayName', sam_account_name)},{self.config['BASE_DN']}"
            
            # 准备属性
            attributes = {
                'objectClass': ['top', 'person', 'organizationalPerson', 'user'],
                'sAMAccountName': sam_account_name,
                'userPrincipalName': f"{sam_account_name}@{self.config['BASE_DN'].replace('dc=', '').replace(',', '.')}",
            }
            
            if 'displayName' in user_data:
                attributes['displayName'] = user_data['displayName']
            if 'mail' in user_data:
                attributes['mail'] = user_data['mail']
            if 'department' in user_data:
                attributes['department'] = user_data['department']
            if 'title' in user_data:
                attributes['title'] = user_data['title']
            
            # 创建用户
            result = self.conn.add(user_dn, attributes=attributes)
            
            if result:
                # 设置初始密码
                if 'password' in user_data:
                    self.set_password(user_dn, user_data['password'])
                
                # 启用账户
                self.enable_user(user_dn)
                
                return True, "用户创建成功"
            else:
                return False, f"创建失败: {self.conn.result['description']}"
                
        except Exception as e:
            return False, f"创建用户错误: {str(e)}"
    
    def update_user(self, sam_account_name, updates):
        """更新用户信息"""
        if not self._ensure_connected():
            return False, "AD连接失败"
        
        try:
            user = self.get_user(sam_account_name)
            if not user:
                return False, "用户不存在"
            
            # 获取用户DN
            user_dn = user.get('distinguishedName')
            if not user_dn:
                return False, "无法获取用户DN"
            
            # 准备更新属性
            changes = {}
            for key, value in updates.items():
                if key != 'password' and value is not None:
                    changes[key] = [(MODIFY_REPLACE, [value])]
            
            if changes:
                result = self.conn.modify(user_dn, changes)
                if not result:
                    return False, f"更新失败: {self.conn.result['description']}"
            
            # 更新密码
            if 'password' in updates:
                success, msg = self.set_password(user_dn, updates['password'])
                if not success:
                    return False, msg
            
            return True, "更新成功"
            
        except Exception as e:
            return False, f"更新用户错误: {str(e)}"
    
    def delete_user(self, sam_account_name):
        """删除用户"""
        if not self._ensure_connected():
            return False, "AD连接失败"
        
        try:
            user = self.get_user(sam_account_name)
            if not user:
                return False, "用户不存在"
            
            user_dn = user.get('distinguishedName')
            if not user_dn:
                return False, "无法获取用户DN"
            
            result = self.conn.delete(user_dn)
            if result:
                return True, "删除成功"
            else:
                return False, f"删除失败: {self.conn.result['description']}"
                
        except Exception as e:
            return False, f"删除用户错误: {str(e)}"
    
    def set_password(self, user_dn, new_password):
        """设置用户密码"""
        if not self._ensure_connected():
            return False, "AD连接失败"
        
        try:
            # 使用UnicodePwd属性设置密码
            unicode_password = f'"{new_password}"'.encode('utf-16-le')
            changes = {'unicodePwd': [(MODIFY_REPLACE, [unicode_password])]}
            
            result = self.conn.modify(user_dn, changes)
            if result:
                # 设置密码永不过期（可选）
                # self.conn.modify(user_dn, {'pwdLastSet': [(MODIFY_REPLACE, ['-1'])]})
                return True, "密码设置成功"
            else:
                return False, f"密码设置失败: {self.conn.result['description']}"
                
        except Exception as e:
            return False, f"设置密码错误: {str(e)}"
    
    def reset_password(self, sam_account_name, new_password):
        """重置用户密码"""
        user = self.get_user(sam_account_name)
        if not user:
            return False, "用户不存在"
        
        user_dn = user.get('distinguishedName')
        if not user_dn:
            return False, "无法获取用户DN"
        
        return self.set_password(user_dn, new_password)
    
    def unlock_user(self, sam_account_name):
        """解锁用户账户"""
        if not self._ensure_connected():
            return False, "AD连接失败"
        
        try:
            user = self.get_user(sam_account_name)
            if not user:
                return False, "用户不存在"
            
            user_dn = user.get('distinguishedName')
            if not user_dn:
                return False, "无法获取用户DN"
            
            # 清除lockoutTime属性
            changes = {'lockoutTime': [(MODIFY_REPLACE, ['0'])]}
            result = self.conn.modify(user_dn, changes)
            
            if result:
                return True, "账户解锁成功"
            else:
                return False, f"解锁失败: {self.conn.result['description']}"
                
        except Exception as e:
            return False, f"解锁账户错误: {str(e)}"
    
    def enable_user(self, sam_account_name):
        """启用用户账户"""
        if not self._ensure_connected():
            return False, "AD连接失败"
        
        try:
            user = self.get_user(sam_account_name)
            if not user:
                return False, "用户不存在"
            
            user_dn = user.get('distinguishedName')
            if not user_dn:
                return False, "无法获取用户DN"
            
            # 获取当前userAccountControl值
            self.conn.search(user_dn, '(objectClass=*)', attributes=['userAccountControl'])
            if not self.conn.entries:
                return False, "用户不存在"
            
            current_uac = int(self.conn.entries[0].userAccountControl.value)
            # 清除ACCOUNTDISABLE标志 (0x2)
            new_uac = current_uac & ~0x2
            
            changes = {'userAccountControl': [(MODIFY_REPLACE, [str(new_uac)])]}
            result = self.conn.modify(user_dn, changes)
            
            return result, "启用成功" if result else f"启用失败: {self.conn.result['description']}"
            
        except Exception as e:
            return False, f"启用账户错误: {str(e)}"
    
    def disable_user(self, sam_account_name):
        """禁用用户账户"""
        if not self._ensure_connected():
            return False, "AD连接失败"
        
        try:
            user = self.get_user(sam_account_name)
            if not user:
                return False, "用户不存在"
            
            user_dn = user.get('distinguishedName')
            if not user_dn:
                return False, "无法获取用户DN"
            
            # 获取当前userAccountControl值
            self.conn.search(user_dn, '(objectClass=*)', attributes=['userAccountControl'])
            if not self.conn.entries:
                return False, "用户不存在"
            
            current_uac = int(self.conn.entries[0].userAccountControl.value)
            # 设置ACCOUNTDISABLE标志 (0x2)
            new_uac = current_uac | 0x2
            
            changes = {'userAccountControl': [(MODIFY_REPLACE, [str(new_uac)])]}
            result = self.conn.modify(user_dn, changes)
            
            return result, "禁用成功" if result else f"禁用失败: {self.conn.result['description']}"
            
        except Exception as e:
            return False, f"禁用账户错误: {str(e)}"
    
    def search_ous(self, search_base=None):
        """搜索组织单位"""
        if not self._ensure_connected():
            return []
        
        if search_base is None:
            search_base = self.config['BASE_DN']
        
        try:
            self.conn.search(
                search_base=search_base,
                search_filter='(objectClass=organizationalUnit)',
                search_scope=SUBTREE,
                attributes=['distinguishedName', 'name', 'description', 'whenCreated']
            )
            
            ous = []
            for entry in self.conn.entries:
                ous.append({
                    'distinguishedName': str(entry.distinguishedName),
                    'name': str(entry.name) if entry.name else '',
                    'description': str(entry.description) if entry.description else '',
                })
            
            return ous
        except Exception as e:
            print(f"搜索OU失败: {e}")
            return []
    
    def search_groups(self, search_base=None):
        """搜索组"""
        if not self._ensure_connected():
            return []
        
        if search_base is None:
            search_base = self.config['BASE_DN']
        
        try:
            self.conn.search(
                search_base=search_base,
                search_filter='(objectClass=group)',
                search_scope=SUBTREE,
                attributes=['distinguishedName', 'name', 'description', 'member', 'groupType']
            )
            
            groups = []
            for entry in self.conn.entries:
                groups.append({
                    'distinguishedName': str(entry.distinguishedName),
                    'name': str(entry.name) if entry.name else '',
                    'description': str(entry.description) if entry.description else '',
                    'member_count': len(entry.member) if entry.member else 0,
                })
            
            return groups
        except Exception as e:
            print(f"搜索组失败: {e}")
            return []

