require 'spec_helper_acceptance'

mydomain = "test.domain.local"

describe 'postfix_config' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      include postfix
      postfix_config { 'mydomain': ensure => present, key => 'mydomain', value => '#{mydomain}'}
      EOS
      
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    
    it 'should set value in main.cf' do
      shell("grep \'^mydomain = #{mydomain}$\' /etc/postfix/main.cf")
    end
  end
  
  describe 'setting postfix_config to absent' do
    it 'should work with no errors' do
      pp = <<-EOS
      postfix_config { 'mydomain': ensure => absent }
      EOS
      
      apply_manifest(pp, :catch_failures => true)
    end
  end
  
  describe 'configuring another instance' do
    it 'should work with no errors' do
      pp = <<-EOS
      postfix_instance { 'postfix-out': ensure => present}
      postfix_config { 'mydomain':
        ensure   => present,
        value    => "#{mydomain}",
        instance => 'postfix-out'
      }
      EOS
      
      apply_manifest(pp, :catch_failures => true)
    end
    
    it 'should set value in postfix-out/main.cf' do
      shell("grep \'^mydomain = #{mydomain}$\' /etc/postfix-out/main.cf")
    end
  end
end
