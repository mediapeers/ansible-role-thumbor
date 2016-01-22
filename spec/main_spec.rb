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

  describe package('libtiff-dev') do
    it { should be_installed }
  end

  describe package('libpng-dev') do
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
    it { should be_installed.by('pip').with_version('2015.04.28') }
  end

  describe file('/etc/thumbor/thumbor.conf') do
    it { should be_file}
  end

  # TODO: more testing
end
