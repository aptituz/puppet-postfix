require 'spec_helper'

describe 'postfix::map' do
  let :pre_condition do
    'class { "postfix": manage_config => false }'
  end

  let(:title) {'transports'}

  context "basic tests" do
    it { should contain_file('/etc/postfix/transports').with({
        'owner' => 'root',
        'group' => 'root',
        'mode' => '0644'

    })}
    it { should contain_exec('postmap /etc/postfix/transports')}
  end
end
