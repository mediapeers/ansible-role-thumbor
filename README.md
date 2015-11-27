# Thumbor role
Ansible role that installs thumbor and sets it up for production use. It uses supervisord to spawn mulitple Thumbor servper processes and puts 
Nnginx infront of it to loadbalance between them and provide a robus webserver for access from outside.

## Requirements
Thsi roles is build for Ubuntu server 14.04 but also might work on other Debian based distros.

## Role Variables
* `thumbor_secret_key` - Thumbor secret key

## Dependencies
Depends on the Mediapeers Nginx role, which you can find here: https://github.com/mediapeers/ansible-role-nginx

## Example Playbook
This is an example on how to integrate this role into your playbook:
```yaml
- hosts: servers
  roles:
    - { role: mpx.thumbor, thumbor_secret_key: 123ABC123123 }
  tasks:
    # other tasks
```
## License
BSD, as is.

## Author Information
Stefan Horning <horning@mediapeers.com>
