require 'spec_helper'

describe UserProfile do
  let(:user) { Fabricate(:user) }
  subject { user.user_profile }
  context 'Fabricator' do 
    it { should be_valid }
    its(:birthday) { should_not be_blank}
  end
end
