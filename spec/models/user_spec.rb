require 'spec_helper'

describe User do
  context 'Fabricator' do 
    subject { Fabricate(:user) }
    it { should be_valid }
    its(:full_name) { should_not be_nil }
  end
end
