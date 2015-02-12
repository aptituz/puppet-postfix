require 'spec_helper'

describe 'postfix' do
        let (:facts) { {
                :osfamily       => 'Debian'
        }}
                
        context "basic tests" do
                it { should contain_class('postfix::service') }
                it { should contain_service('postfix') }
        end
end
