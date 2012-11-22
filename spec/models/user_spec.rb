require 'spec_helper'

describe User do
  subject { Fabricate(:user) }
  context 'Fabricator' do 
    it { should be_valid }
  end
  its(:full_name) { should_not be_blank }

end
