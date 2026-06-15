## Import vs incluse role

# import
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


3.now in under ansible-roles we have created the include-vs-import.yaml here we called the folder-> include-import under roles.and we have write our common tasks under common folder--> include-vs-import.yaml.now call the include-import.yaml under ansible-roles
 here both will give the same result.

4.now in common folder under tasks just write some worng cmd.
now if we use import playbook won't run beacsue import_roles parse the playbook before execution, it is static.
but include _role directly execute the playbook,it will not parse like import_role before execution.





