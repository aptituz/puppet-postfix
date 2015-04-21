require 'spec_helper_acceptance'

describe 'postfix_instance' do
  describe "getting a list of instances via puppet ressource" do
    describe command('puppet resource postfix_instance') do
      its(:stdout) { should match /postfix_instance { '-':/ }
    end
  end
  
describe 'running puppet code' do
  describe 'should run with no errors' do
      pp = <<-EOS
        postfix_instance { 'postfix-out': }
      EOS

#FIXME: This code does not work, since it causes beaker not to install
#the module, before. WTF?
#		apply_manifest(pp, :catch_failures => true)
#    apply_manifest(pp, :catch_changes => true)
  end
end   

##      apply_manifest(pp, :catch_failures => true)
##      apply_manifest(pp, :catch_changes => true)
##    end      
##  end
  
end
  
