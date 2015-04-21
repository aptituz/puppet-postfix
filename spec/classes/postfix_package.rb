require 'spec_helper'

describe 'postfix' do
  let (:facts) { {
    :osfamily   => 'Debian'
  }}
    
  context "basic tests" do
    it { should contain_class('postfix::package') }
    it { should contain_package('postfix') }
  end
end
