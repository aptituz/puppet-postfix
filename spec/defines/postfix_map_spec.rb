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

  context 'with content parameter' do
    let (:params) { { :content => 'testcontent'} }
    it { is_expected.to contain_file('/etc/postfix/transports').with( :content => 'testcontent') }
  end

  context 'with source parameter' do
    let (:params) { { :source => 'puppet://foo/bar'} }
    it { is_expected.to contain_file('/etc/postfix/transports').with( :source => 'puppet://foo/bar') }
  end
end
