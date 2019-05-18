#设置控制台超时自动退出
sh -c "echo 'export TMOUT=600'" >> /etc/profile

#设置口令最大生存周期、最小生存周期、密码最小长度、以及密码过期提示
sed -i '/PASS_MAX_DAYS/s/99999/180/g' /etc/login.defs
sed -i '/PASS_MIN_DAYS/s/0/2/g' /etc/login.defs
sed -i '/PASS_MIN_LEN/s/5/7/g' /etc/login.defs
sed -i '/PASS_WARN_AGE/s/7/30/g' /etc/login.defs

#设置口令复杂度，大写字母个数、数字个数、小写字母个数、特殊字符个数、重复密码使用次数
sed -i '/password/s/authtok_type=/authtok_type= ucredit=-1 dcredit=-1 lcredit=-1 ocredit=-1 remember=5/g' /etc/pam.d/system-auth

#设置用户目录缺省访问权限
sed -i '/UMASK/s/077/027/g' /etc/login.defs

#设置ssh登录锁定机制，deny 失败次数、unlock_time 锁定时长
sed -i 2a\auth\ required\ pam_tally.so\ deny=5\ unlock_time=300\ no_lock_time  /etc/pam.d/sshd
sed -i 9a\account\ required\ pam_tally.so  /etc/pam.d/sshd

#设置远程登录锁定机制，deny 失败次数、unlock_time 锁定时长
sed -i 4a\auth\ required\ pam_tally.so\ deny=5\ unlock_time=300\ no_lock_time  /etc/pam.d/system-auth
sed -i 14a\account\ required\ pam_tally.so  /etc/pam.d/system-auth

echo "需要手工确认后配置,禁用远程root登录"
echo "修改/etc/ssh/sshd_config文件,配置PermitRootLogin no。重启服务，/etc/init.d/sshd restart"