[![Build Status](https://travis-ci.org/mediapeers/ansible-role-thumbor.svg?branch=master)](https://travis-ci.org/mediapeers/ansible-role-thumbor)

# Thumbor role
Ansible role that installs [Thumbor](https://github.com/thumbor/thumbor) and sets it up for production use.
It uses supervisord to spawn mulitple Thumbor server processes and puts Nginx infront of it to loadbalance
between them and provide a robust webserver for access from the outside.

Also this role expects to use an S3 bucket as result storage and an S3 namespace as allowed image source.

The normal [image storage](https://github.com/thumbor/thumbor/wiki/Image-storage) (source image caching) is done on the normal filesystem. Make sure to set a expiration time that matches your
scenario to not flood your harddisk. Use the thumbor_storage_expiration variable and point the thumbor_storage_path to a big enough volume.

This role is only designed to setup Thumbor up as an image scaling service. No uploading or other processing will be enabled.
Also unsafe URLs are disbaled, meaning you can only use the service with knowing the secret signing key. See `thumbor_signing_key` variable.

## Requirements
This roles is build for Ubuntu server 14.04 but also might work on other Debian based distros.
Also you need an AWS S3 bucket setup and the instance this runs on should assume an IAM role (or user credentials in .aws/) to make the
[AWS plugin](https://github.com/thumbor-community/aws) work (which uses [Boto](https://boto3.readthedocs.org/en/latest/guide/quickstart.html#configuration) to connect to S3).

## Role Variables
This is the list of role variables with their default values:

* `thumbor_signing_key: ABC123` - Overwrite this to make your thumbor secure! Key that's used to sign requests to Thumbor
* `thumbor_specific_version: 6.1.1` - optional parameter to restrict Thumbor version number more than tc_aws does
* `thumbor_aws_plugin_version: 6.0.4` - Version of the [tc_aws plugin](https://github.com/thumbor-community/aws) for thumbor
* `thumbor_user: ubuntu` - User that runs thumbor (through supervisord)
* `thumbor_config_dir: /etc/thumbor` - Dir that holds the thumbor config files
* `thumbor_log_dir: /var/log/thumbor`
* `thumbor_allowed_sources: ['my-s3-namespace-.*s3.amazonaws.com','some-domain.com']` - Allowed domains used as Thumbor picture input.
* `thumbor_client_side_cache_duration: 24` - client side cache duration in hours
* `thumbor_result_storage_bucket: 'my-namespace-thumbor-cache'` - The bucket name for the result storage
* `thumbor_result_storage_path: result_storage` - The path (bucket folder) where results are cached
* `thumbor_result_storage_expiration: 24` - Result storage cache expiration time in hours
* `thumbor_storage_expiration: 48` - Source image storage cache expiration time in hours
* `thumbor_storage_path: /var/tmp/thumbor/storage` - Location for images storage cache, make sure it's on a volume big enough
* `s3_aws_region: us-east-1` - AWS Region for S3 bucket (the aws plugin). If your instance assumes an IAM role you can set this and avoid an boto/aws config file completely
* `s3_create_bucket: true` - This will create the bucket on S3 unless set to false. Make sure you have a working AWS/Boto config to grant S3 permissions
* `supervisord_log_dir: /var/log/supervisor` - Log dir for the supervisord service
* `nginx_graylog_server: log.server` - Graylog server for Nginx logs
* `nginx_log_dir: /var/log/nginx` - Nginx log dir
* `nginx_status_page: /nginx_status` - Nginx status page you can use for monitoring

There is a config for the Nginx role in `vars/main.yml`. It's set to work with thumbor supervisor setup. But you can throw out stuff you don't
need if you want. Make sure you keep upstream servers in sync with the ones supervisor starts (thumbor/tornado servers).

## Dependencies
Depends on the [mediapeers.nginx](https://galaxy.ansible.com/mediapeers/nginx/) Ansible role. Add the Nginx role to your project
with the Ansible Galaxy command (`ansible-galaxy install mediapeers.nginx`) or add directly as Git submodule (repo [here](https://github.com/mediapeers/ansible-role-nginx)).
Make sure it's in `roles/mediapeers.nginx` to make this thumbor role work.

## Example Playbook
This is an example on how to integrate this role into your playbook:
```yaml
- hosts: servers
  vars:
    thumbor_signing_key: 123ABC123Supersecret
    thumbor_allowed_sources:
      - my-s3-namespace-.*s3.amazonaws.com
      - some-domain.com
    thumbor_result_storage_bucket: "my-result-storage-bucket"
    # and other vars you want to override
  roles:
    - mediapeers.thumbor
  tasks:
    # other tasks
```

## License
BSD, as is.

## Author Information
Stefan Horning <horning@mediapeers.com>
