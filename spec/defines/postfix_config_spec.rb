require 'spec_helper'

describe 'postfix::config' do
        let :pre_condition do
            'class { "postfix": manage_config => false }'
        end

        let(:title) { '/etc/postfix/main.cf' }
    
                
        context "basic tests" do
             let(:params) { {:options => { 'mydomain' => 'testdomain' } } }
             it { should contain_file('/etc/postfix/main.cf') }
        end
end
