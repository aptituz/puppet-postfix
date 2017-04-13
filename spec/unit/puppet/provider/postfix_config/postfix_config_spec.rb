require 'spec_helper'

describe Puppet::Type.type(:postfix_config).provider(:postconf) do
  let(:resource) { Puppet::Type.type(:postfix_config).new(
      {   :ensure                   => :present,
          :name                     => 'mydomain',
          :key                      => 'mydomain',
          :value                    => 'example.com',
          :provider                 => described_class.name
      }
  )}
  let(:provider) { resource.provider }

  let (:raw_postconf_output) do "multi_instance_directories = /etc/postfix-senke2 /etc/postfix-senke1
multi_instance_enable = yes
master_service_disable =
"
  end

  before(:each) do
    allow(Open3).to receive(:capture3).with('/usr/sbin/postconf -n').and_return(raw_postconf_output, '', '','')
  end

  describe 'self.prefetch' do
    it 'exists' do
      provider.class.instances
      provider.class.prefetch({})
    end
  end
  
  describe 'self.instances' do
    it 'returns an array of postconf settings' do
      settings = provider.class.instances.collect { |s| s.name }
      expect(settings).to match(['multi_instance_directories','multi_instance_enable', 'master_service_disable'])
    end
  end

end
