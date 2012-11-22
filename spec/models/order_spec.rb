require 'spec_helper'

describe Order do
  context 'Fabricators' do 
    subject { Fabricate(:order) }
    it { should be_valid }
  end
end
