require 'spec_helper'

describe User do
  subject { Fabricate(:user) }
  context 'Fabricator' do 
    it { should be_valid }
  end

  it '#full_name' do 
    name = "#{subject.user_profile.first_name} #{subject.user_profile.last_name}"
    subject.full_name.should eql "#{name}"
  end

  context 'authentication' do
    let(:new_password) { }
    let(:django_password) { 'sha1$cde18$646d3172f4d5df48dc25f7fc09698e277e9c3567' }
    context 'django migration' do
      subject { Fabricate(:user, encrypted_password: django_password) }
      it { should be_valid_password('andy12') }
    end
    context 'new authentication' do
      it { should be_valid_password('andy12') }
    end
  end
end
