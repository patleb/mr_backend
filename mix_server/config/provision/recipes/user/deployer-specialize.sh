DEPLOYER_PATH=/home/$__DEPLOYER_NAME__

echo "$__DEPLOYER_NAME__:$__DEPLOYER_PASSWORD__" | chpasswd

<%= Sh.build_authorized_keys(sun.deployer_name) %>
chmod 600 $DEPLOYER_PATH/.ssh/authorized_keys
echo -e "$__OWNER_PRIVATE_KEY__" > $DEPLOYER_PATH/.ssh/id_rsa
chmod 600 $DEPLOYER_PATH/.ssh/id_rsa
chown -R $__DEPLOYER_NAME__:$__DEPLOYER_NAME__ $DEPLOYER_PATH
