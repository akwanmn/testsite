require 'spec_helper'

describe Message do
  subject { Fabricate(:message) }
  its(:body)        { should_not be_blank }
  its(:subject)     { should_not be_blank }
  its(:created_at)  { should_not be_blank }
  its(:updated_at)  { should_not be_blank }
  its(:from_user)   { should_not be_blank }
  its(:to_user)     { should_not be_blank }
  its(:sent_at)     { should_not be_blank }

  it { should respond_to(:new_message) }
  it { should respond_to(:reply_message) }

  context 'sending' do
    before { subject.new_message }
    context 'communications' do
      it { should have(2).communications }
      it { should_not be_nil }
      it 'assigns mailbox to communications' do
        subject.communications.first.mailbox.user.should == subject.from_user
      end
    end
  end
end
