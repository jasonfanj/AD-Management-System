// 域控通-Web 前端应用
const API_BASE = 'http://localhost:5000/api';

// 创建Vue实例
new Vue({
    el: '#app',
    data() {
        return {
            isAuthenticated: false,
            currentUser: {},
            token: localStorage.getItem('token') || '',
            loading: false,
            error: '',
            
            // 登录表单
            loginForm: {
                username: '',
                password: ''
            },
            loginRules: {
                username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
                password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
            },
            
            // 菜单
            activeMenu: 'users',
            
            // 用户管理
            users: [],
            userSearchKeyword: '',
            showCreateUserDialog: false,
            createUserForm: {
                sAMAccountName: '',
                displayName: '',
                mail: '',
                department: '',
                title: '',
                password: ''
            },
            
            // 自助服务
            resetPasswordForm: {
                username: '',
                newPassword: '',
                confirmPassword: ''
            },
            unlockForm: {
                username: ''
            },
            profileForm: {},
            profileLoading: false,
            
            // 审计日志
            auditLogs: [],
            auditDateRange: [],
            auditAction: '',
            
            // 统计
            userStats: {
                total: 0,
                enabled: 0,
                disabled: 0
            },
            auditStats: {
                today: 0
            },
            
            // 系统设置
            adConfigForm: {
                server: '',
                base_dn: '',
                user_dn: '',
                password: ''
            }
        }
    },
    mounted() {
        // 检查是否已登录
        if (this.token) {
            this.checkAuth();
        }
    },
    methods: {
        // 设置axios默认header
        setAuthHeader() {
            axios.defaults.headers.common['Authorization'] = `Bearer ${this.token}`;
        },
        
        // 检查认证状态
        async checkAuth() {
            if (!this.token) return;
            
            this.setAuthHeader();
            try {
                const res = await axios.get(`${API_BASE}/auth/me`);
                this.currentUser = res.data;
                this.isAuthenticated = true;
            } catch (error) {
                this.logout();
            }
        },
        
        // 登录
        async handleLogin() {
            this.$refs.loginForm.validate(async (valid) => {
                if (!valid) return;
                
                this.loading = true;
                this.error = '';
                
                try {
                    const res = await axios.post(`${API_BASE}/auth/login`, this.loginForm);
                    this.token = res.data.access_token;
                    this.currentUser = res.data.user;
                    this.isAuthenticated = true;
                    localStorage.setItem('token', this.token);
                    this.setAuthHeader();
                    
                    // 加载默认页面数据
                    if (this.activeMenu === 'users') {
                        this.loadUsers();
                    }
                } catch (error) {
                    this.error = error.response?.data?.error || '登录失败';
                } finally {
                    this.loading = false;
                }
            });
        },
        
        // 退出登录
        logout() {
            this.token = '';
            this.isAuthenticated = false;
            this.currentUser = {};
            localStorage.removeItem('token');
            delete axios.defaults.headers.common['Authorization'];
        },
        
        // 菜单选择
        handleMenuSelect(index) {
            this.activeMenu = index;
            
            // 加载对应页面数据
            if (index === 'users') {
                this.loadUsers();
            } else if (index === 'selfservice') {
                this.loadMyInfo();
            } else if (index === 'audit') {
                this.loadAuditLogs();
            } else if (index === 'reports') {
                this.loadStats();
            }
        },
        
        // 用户下拉菜单
        handleCommand(command) {
            if (command === 'logout') {
                this.logout();
            } else if (command === 'changePassword') {
                this.$prompt('请输入新密码', '修改密码', {
                    inputType: 'password'
                }).then(({ value }) => {
                    this.changePassword(value);
                });
            }
        },
        
        // 加载用户列表
        async loadUsers() {
            this.loading = true;
            try {
                const res = await axios.get(`${API_BASE}/ad/users`);
                this.users = res.data.users || [];
                this.updateUserStats();
            } catch (error) {
                this.$message.error(error.response?.data?.error || '加载用户失败');
            } finally {
                this.loading = false;
            }
        },
        
        // 搜索用户
        async searchUsers() {
            this.loading = true;
            try {
                const filter = this.userSearchKeyword 
                    ? `(&(objectClass=user)(|(sAMAccountName=*${this.userSearchKeyword}*)(displayName=*${this.userSearchKeyword}*)))`
                    : '(objectClass=user)';
                const res = await axios.get(`${API_BASE}/ad/users?filter=${encodeURIComponent(filter)}`);
                this.users = res.data.users || [];
            } catch (error) {
                this.$message.error(error.response?.data?.error || '搜索失败');
            } finally {
                this.loading = false;
            }
        },
        
        // 创建用户
        async createUser() {
            try {
                await axios.post(`${API_BASE}/ad/users`, this.createUserForm);
                this.$message.success('用户创建成功');
                this.showCreateUserDialog = false;
                this.createUserForm = {
                    sAMAccountName: '',
                    displayName: '',
                    mail: '',
                    department: '',
                    title: '',
                    password: ''
                };
                this.loadUsers();
            } catch (error) {
                this.$message.error(error.response?.data?.error || '创建失败');
            }
        },
        
        // 查看用户
        viewUser(user) {
            this.$alert(JSON.stringify(user, null, 2), '用户详情', {
                confirmButtonText: '确定'
            });
        },
        
        // 编辑用户
        editUser(user) {
            this.$prompt('请输入新值', `编辑用户: ${user.sAMAccountName}`, {
                inputValue: user.displayName
            }).then(({ value }) => {
                this.updateUser(user.sAMAccountName, { displayName: value });
            });
        },
        
        // 更新用户
        async updateUser(samAccountName, updates) {
            try {
                await axios.put(`${API_BASE}/ad/users/${samAccountName}`, updates);
                this.$message.success('更新成功');
                this.loadUsers();
            } catch (error) {
                this.$message.error(error.response?.data?.error || '更新失败');
            }
        },
        
        // 重置密码
        async resetPassword(user) {
            this.$prompt('请输入新密码', `重置密码: ${user.sAMAccountName}`, {
                inputType: 'password'
            }).then(async ({ value }) => {
                try {
                    await axios.post(`${API_BASE}/ad/users/${user.sAMAccountName}/reset-password`, {
                        new_password: value
                    });
                    this.$message.success('密码重置成功');
                } catch (error) {
                    this.$message.error(error.response?.data?.error || '重置失败');
                }
            });
        },
        
        // 删除用户
        async deleteUser(user) {
            this.$confirm(`确定要删除用户 ${user.sAMAccountName} 吗？`, '确认删除', {
                type: 'warning'
            }).then(async () => {
                try {
                    await axios.delete(`${API_BASE}/ad/users/${user.sAMAccountName}`);
                    this.$message.success('删除成功');
                    this.loadUsers();
                } catch (error) {
                    this.$message.error(error.response?.data?.error || '删除失败');
                }
            });
        },
        
        // 更新用户统计
        updateUserStats() {
            this.userStats.total = this.users.length;
            this.userStats.enabled = this.users.filter(u => u.is_enabled).length;
            this.userStats.disabled = this.users.filter(u => !u.is_enabled).length;
        },
        
        // 加载个人信息
        async loadMyInfo() {
            this.profileLoading = true;
            try {
                const res = await axios.get(`${API_BASE}/selfservice/my-info`);
                this.profileForm = res.data;
            } catch (error) {
                this.$message.error(error.response?.data?.error || '加载失败');
            } finally {
                this.profileLoading = false;
            }
        },
        
        // 更新个人信息
        async updateProfile() {
            try {
                await axios.post(`${API_BASE}/selfservice/update-profile`, this.profileForm);
                this.$message.success('更新成功');
            } catch (error) {
                this.$message.error(error.response?.data?.error || '更新失败');
            }
        },
        
        // 自助重置密码
        async handleSelfResetPassword() {
            if (this.resetPasswordForm.newPassword !== this.resetPasswordForm.confirmPassword) {
                this.$message.error('两次密码输入不一致');
                return;
            }
            
            try {
                await axios.post(`${API_BASE}/selfservice/reset-password`, {
                    token: '', // TODO: 实现token流程
                    new_password: this.resetPasswordForm.newPassword
                });
                this.$message.success('密码重置成功');
            } catch (error) {
                this.$message.error(error.response?.data?.error || '重置失败');
            }
        },
        
        // 解锁账户
        async handleUnlockAccount() {
            try {
                await axios.post(`${API_BASE}/selfservice/unlock-account`, {
                    sam_account_name: this.unlockForm.username || this.currentUser.username
                });
                this.$message.success('账户解锁成功');
            } catch (error) {
                this.$message.error(error.response?.data?.error || '解锁失败');
            }
        },
        
        // 修改密码
        async changePassword(newPassword) {
            try {
                await axios.post(`${API_BASE}/auth/change-password`, {
                    old_password: '',
                    new_password: newPassword
                });
                this.$message.success('密码修改成功');
            } catch (error) {
                this.$message.error(error.response?.data?.error || '修改失败');
            }
        },
        
        // 加载审计日志
        async loadAuditLogs() {
            this.loading = true;
            try {
                const params = {};
                if (this.auditAction) params.action = this.auditAction;
                if (this.auditDateRange && this.auditDateRange.length === 2) {
                    params.start_date = this.auditDateRange[0].toISOString();
                    params.end_date = this.auditDateRange[1].toISOString();
                }
                
                const res = await axios.get(`${API_BASE}/audit/logs`, { params });
                this.auditLogs = res.data.logs || [];
            } catch (error) {
                this.$message.error(error.response?.data?.error || '加载失败');
            } finally {
                this.loading = false;
            }
        },
        
        // 加载统计
        async loadStats() {
            try {
                // TODO: 实现统计API
                this.auditStats.today = 0;
            } catch (error) {
                console.error('加载统计失败', error);
            }
        },
        
        // 测试AD连接
        async testADConnection() {
            try {
                await axios.post(`${API_BASE}/system/test-ad-connection`);
                this.$message.success('AD连接成功');
            } catch (error) {
                this.$message.error(error.response?.data?.error || '连接失败');
            }
        }
    }
});

