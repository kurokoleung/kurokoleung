#���ÿ���̨��ʱ�Զ��˳�
sh -c "echo 'export TMOUT=600'" >> /etc/profile

#���ÿ�������������ڡ���С�������ڡ�������С���ȡ��Լ����������ʾ
sed -i '/PASS_MAX_DAYS/s/99999/180/g' /etc/login.defs
sed -i '/PASS_MIN_DAYS/s/0/2/g' /etc/login.defs
sed -i '/PASS_MIN_LEN/s/5/7/g' /etc/login.defs
sed -i '/PASS_WARN_AGE/s/7/30/g' /etc/login.defs

#���ÿ���Ӷȣ���д��ĸ���������ָ�����Сд��ĸ�����������ַ��������ظ�����ʹ�ô���
sed -i '/password/s/authtok_type=/authtok_type= ucredit=-1 dcredit=-1 lcredit=-1 ocredit=-1 remember=5/g' /etc/pam.d/system-auth

#�����û�Ŀ¼ȱʡ����Ȩ��
sed -i '/UMASK/s/077/027/g' /etc/login.defs

#����ssh��¼�������ƣ�deny ʧ�ܴ�����unlock_time ����ʱ��
sed -i 2a\auth\ required\ pam_tally.so\ deny=5\ unlock_time=300\ no_lock_time  /etc/pam.d/sshd
sed -i 9a\account\ required\ pam_tally.so  /etc/pam.d/sshd

#����Զ�̵�¼�������ƣ�deny ʧ�ܴ�����unlock_time ����ʱ��
sed -i 4a\auth\ required\ pam_tally.so\ deny=5\ unlock_time=300\ no_lock_time  /etc/pam.d/system-auth
sed -i 14a\account\ required\ pam_tally.so  /etc/pam.d/system-auth

echo "��Ҫ�ֹ�ȷ�Ϻ�����,����Զ��root��¼"
echo "�޸�/etc/ssh/sshd_config�ļ�,����PermitRootLogin no����������/etc/init.d/sshd restart"