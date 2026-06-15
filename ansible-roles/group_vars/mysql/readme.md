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

and remove 
#ask_vault_pass = True
 -->
but it is very hassle process that's why parameter store came into picture.we can store password there usin securestring type.

so now in mysql--> vault.yaml we will remove the 

<!-- $ANSIBLE_VAULT;1.1;AES256
63393132383835666633396463346437323462326663343961613039393962363963653737336539
3835346466386435633538303361333934393637623330370a386136303062653638306131366639
66383364303961376333356635396162353161373362613764656639323562396466633936666663
6234393463353033300a363839393234396361313836643337303963356364366635666638373964
37613863383665393331643330363835363830316333366236303164653532383436653564393161
6431323832333739623739363235353736383732316536353737 -->


and add parameter using lookup

