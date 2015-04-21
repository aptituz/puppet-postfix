require 'spec_helper_acceptance'

describe 'postfix' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
      include postfix
      EOS
      
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
  
  describe package('postfix') do
    it { should be_installed }
  end
  
  describe service('postfix') do
    it { should be_enabled }
  end
  
  describe port('25') do
    it { should be_listening }
  end
  
end
    