require 'spec_helper'

describe 'postfix' do
  let (:facts) { {
 		:osfamily   => 'Debian'
  }}

  it { should compile.with_all_deps }
    
  context "basic tests" do
    it { should contain_class('postfix') }
    it { should contain_class('postfix::package') }
    it { should contain_class('postfix::service') }
    it { should contain_package('postfix') }
    it { should contain_service('postfix') }
  end

  context "with manage_config => true" do
    let (:params) {{ :manage_config => 'true' }}

    it { should contain_file('/etc/postfix/main.cf') }
    it { should contain_file('/etc/postfix/master.cf') }

    context "with postfix_options set" do
      let (:params) {{ 
      :manage_config   => 'true',
      :postfix_options => { 'myhostname' => 'foobar' }}}

      it { should contain_file('/etc/postfix/main.cf').with_content(/\nmyhostname = foobar\n/) }
    end
  end
end
