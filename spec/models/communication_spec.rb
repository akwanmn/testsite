require 'spec_helper'

describe Communication do
  subject { Fabricate(:communication) }
  its(:messages) { should_not be_empty }

  it '#length' do
    subject.messages.length.should == 3
  end

  its(:from_user_id) { should_not be_nil }
  its(:to_user_id) { should_not be_nil }
  its(:sent_at) { should_not be_nil }

  it '#testing' do
    #p subject.messages
  end
end