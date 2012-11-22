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

  it 'valid_password?'
end
