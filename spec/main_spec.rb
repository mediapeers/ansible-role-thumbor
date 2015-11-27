require 'spec_helper'

describe 'Thumbor setup' do

  describe file('/etc/thumbor/thumbor.conf') do
    it { should be_file}
  end

  # TODO: more testing
end
