require 'spec_helper'

describe UserProfile do
  context 'Fabricator' do 
    subject { Fabricate(:user_profile) }
    it { should be_valid }
  end
end
