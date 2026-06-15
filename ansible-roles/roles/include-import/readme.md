## Import vs include role

# Tags
example-1: # Tags
1.first we have placed the tags in deployment activities like code download and unzip (app-setup) so here when we call tags form import it is worked.it is only called tehe code hwich having tag.
2.same we applied for include but here it is not worked.so include won't respect teh tags at all.

- name: nodejs setup
  tags:
  - deployment
  ansible.builtin.include_role:  # it wont respect the tag
  #ansible.builtin.import_role: # respect teh tag
   name: common
   tasks_from: nodejs-setup.yaml

# wrong commands
3.now in under ansible-roles we have created the include-vs-import.yaml here we called the folder-> include-import under roles.and we have write our common tasks under common folder--> include-vs-import.yaml.now call the include-import.yaml under ansible-roles
 here both will give the same result.

4.now in common folder under tasks just write some worng cmd.
now if we use import playbook won't run beacsue import_roles parse the playbook before execution, it is static.
but include _role directly execute the playbook,it will not parse like import_role before execution.

# conditions
5.now under roles--> include-import create a folder vars.under this give a variable 
os: "RedHat
now in mainfile under ansible roles give a when condition.so playbook will execute.
now for include role under common -->tasks-->here set a var dynamically using set_fact
--> so first if we run import_role, the task will be skipped due to our dynamic var.
--> if we put include_role, it won't care anything it will run the tasks.
so conditions applied to import_role is applied to all the tasks, include_role will not care conditions applie to it.

# loop
you cannot use loops on import_role statements. you should use include_role instead.



