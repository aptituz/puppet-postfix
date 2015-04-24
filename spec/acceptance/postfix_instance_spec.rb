require 'spec_helper_acceptance'
require 'pry'

describe 'postfix_instance' do
  before :all do
    # include postfix class for package installation
    apply_manifest('include postfix', :catch_failures => true)
    apply_manifest('include postfix', :catch_changes => true)
  end

  describe "get existing instances" do
    describe command('puppet resource postfix_instance') do
      its(:stdout) { should match /postfix_instance { '-':/ }
    end
  end

  describe 'running puppet code' do
    it 'should run with no errors' do
      pp = <<-EOS
        postfix_instance { 'postfix-out': ensure => present }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it 'should create instance' do
      shell('postmulti -l|grep postfix-out', :acceptable_exit_codes => 0)
    end
  end


  describe file('/etc/postfix-out') do
    it { should be_directory }
  end

  describe file('/etc/postfix-out/main.cf') do
    it { should be_file }
  end


  describe file('/etc/postfix-out/master.cf') do
    it { should be_file }
  end

  describe 'destroy instance' do
    it 'should run with no errors' do
      pp = <<-EOS
      postfix_instance { 'postfix-out': ensure => absent }
      EOS

      apply_manifest(pp, :catch_failures => true )
    end
  end
end

