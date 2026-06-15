<!-- <!-- 
## ansible-vault

# in cmd line or ec2 run below cmds

# ansible-valut create vault.yaml 
# here set a password and file will open here we can share any passwords 
# ex: MYSQL_ROOT_PASSWORD: RoboShop@1 
# once it is done.we can view and edit 

# ansible-valut view vault.yaml 
# ansible-valut edit vault.yaml 

# cat vault.yaml copy the code here -->

<!-- here when we run below command it will load the all tasks in mydql and it cans ee the encryped password so it will through an error

<!-- ERROR! Attempting to decrypt but no vault secrets found
<!-- 
then run below cmd:
ansible-playbook -e component=mysql roboshop.yaml --ask-vault-pass -->

and give the pass -->
<!-- 
or we can directly we can give in ansible.cfg file -->

<!-- ask_vault_pass = True --> -->

<!-- now we can run 
ansible-playbook -e component=mysql roboshop.yaml
directly it will ask for password.
but every time if it will ask like this it is a disruption during execution so we can store the password in linux server.

now under .ansible folder if it is nt tere create it.
create a file --> .mysql_vault
echo "DevOps321" > .mysql_vault

now in ansible.cfg
vault_password_file = ~/.ansible/.mysql_vault -->
 -->
