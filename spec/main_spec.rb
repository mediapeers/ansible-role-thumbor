require 'spec_helper'

describe 'Thumbor setup' do

  describe package('supervisor') do
    it { should be_installed }
  end

  describe package('python-pip') do
    it { should be_installed }
  end

  describe package('python-dev') do
    it { should be_installed }
  end

  describe package('libcurl4-openssl-dev') do
    it { should be_installed }
  end

  describe package('python-pgmagick') do
    it { should be_installed }
  end

  describe package('libjpeg-dev') do
    it { should be_installed }
  end

  describe package('libtiff5-dev') do
    it { should be_installed }
  end

  describe package('libpng12-dev') do
    it { should be_installed }
  end

  describe package('libjasper-dev') do
    it { should be_installed }
  end

  describe package('libwebp-dev') do
    it { should be_installed }
  end

  describe package('tc-aws') do
    it { should be_installed.by('pip') }
  end

  describe package('certifi') do
    it { should be_installed.by('pip').with_version('2015.4.28') }
  end

  describe user(ANSIBLE_VARS.fetch('thumbor_user', 'FAIL')) do
    it { should exist }
    it { should belong_to_group(ANSIBLE_VARS.fetch('thumbor_user', 'FAIL')) }
  end

  config_dir = ANSIBLE_VARS.fetch('thumbor_config_dir', '/')

  describe file("#{config_dir}/thumbor.conf") do
    it { should be_file }
    it { should be_owned_by('root') }
    it { should be_grouped_into(ANSIBLE_VARS.fetch('thumbor_user', 'FAIL')) }
    it { should be_mode(640) }
    its(:content) { should include("#{ANSIBLE_VARS.fetch('thumbor_bucket_prefix', 'FAIL')}.*s3.amazonaws.com") }
    its(:content) { should include("TC_AWS_REGION = '#{ANSIBLE_VARS.fetch('s3_aws_region', 'FAIL')}'") }
  end

  describe file("#{config_dir}/thumbor.key") do
    it { should be_file }
    it { should be_owned_by('root') }
    it { should be_grouped_into(ANSIBLE_VARS.fetch('thumbor_user', 'FAIL')) }
    it { should be_mode(640) }
    its(:content) { should eq "#{ANSIBLE_VARS.fetch('thumbor_signing_key', 'FAIL')}\n" }
  end

  describe file("#{ANSIBLE_VARS.fetch('thumbor_log_dir', 'FAIL')}") do
    it { should be_directory }
    it { should be_mode(755) }
  end

  describe file("#{ANSIBLE_VARS.fetch('supervisord_log_dir', 'FAIL')}") do
    it { should be_directory }
    it { should be_mode(755) }
  end

  describe file('/etc/supervisor/supervisord.conf') do
    it { should be_file }
    its(:content) { should include "numprocs=#{ANSIBLE_VARS.fetch('thumbor_processes', 'FAIL')}" }
    its(:content) { should include "user=#{ANSIBLE_VARS.fetch('thumbor_user', 'FAIL')}" }
  end

  describe service('supervisor') do
    it { should be_enabled }
#    it { should be_running }
  end

  describe port(8001) do
    it { should be_listening.on('127.0.0.1').with('tcp') }
  end

  describe port(80) do
    it { should be_listening.on('127.0.0.1').with('tcp') }
  end

  # Quick smoketest of Nginx setup (nginx role should be tested itself already):
  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
  end

  describe file('/etc/nginx/sites-available/default.conf') do
    it { should be_file }
    its(:content) { should include "proxy_pass http://thumbor;" }
  end

  describe file('/etc/nginx/sites-enabled/default.conf') do
    it { should be_symlink }
  end

end
