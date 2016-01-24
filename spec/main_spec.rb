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

  config_dir = ANSIBLE_VARS.fetch('thumbor_config_dir', '/')

  describe file("#{config_dir}/thumbor.conf") do
    it { should be_file }
    its(:content) { should include("#{ANSIBLE_VARS.fetch('thumbor_bucket_prefix', 'FAIL')}.*s3.amazonaws.com") }
    its(:content) { should include("TC_AWS_REGION = '#{ANSIBLE_VARS.fetch('s3_aws_region', 'FAIL')}'") }
  end

  describe file("#{config_dir}/thumbor.key") do
    it { should be_file }
    its(:content) { should eq "#{ANSIBLE_VARS.fetch('thumbor_signing_key', 'FAIL')}" }
  end

  describe file("#{ANSIBLE_VARS.fetch('thumbor_log_dir', 'FAIL')}") do
    it { should be_directory }
  end

  describe file("#{ANSIBLE_VARS.fetch('supervisord_log_dir', 'FAIL')}") do
    it { should be_directory }
  end

  describe file('/etc/supervisor/supervisord.conf') do
    it { should be_file }
    its(:content) { should include "numprocs=#{ANSIBLE_VARS.fetch('thumbor_processes', 'FAIL')}" }
  end

  describe service('supervisor') do
    it { should be_started }
  end

  # Quick smoketest of Nginx setup (nginx role should be tested itself already):
  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
  end

  describe file('/etc/nginx/sites-available/default') do
    it { should be_file }
    its(:content) { should include "proxy_pass http://thumbor;" }
  end

  describe file('/etc/nginx/sites-enabled/default') do
    it { should be_symlink }
  end

end
