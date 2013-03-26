require 'spec_helper'

describe Communication do
  subject {
    Communication.new(
      subject: 'Testing',
      body: 'This is a test body.',
      from_user: Fabricate(:user),
      to_user: Fabricate(:user)
    )
  }
  before do
    subject.send_msg
  end
  context 'sending' do
    it 'to_user should have one message' do
      subject.to_user.mailbox.communications.count.should == 1
    end
    it 'from_user should have one message' do
      subject.from_user.mailbox.communications.count.should == 1
    end
    context 'messages' do
      let(:messages) { subject.from_user.mailbox.communications.first.messages }
      it 'has 1 message' do
        messages.count.should == 1
      end
      it 'has the right subject' do
        messages.first.subject.should == 'Testing'
      end
    end
  end

  its(:sent_at) { should_not be_nil }
end