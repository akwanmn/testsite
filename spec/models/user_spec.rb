require 'spec_helper'

describe User do
  context 'Fabricator' do 
    subject { Fabricate(:user) }
    it { should be_valid }
  end
end
