require 'spec_helper'

describe Communication do
  before do
    @message = Fabricate(:message)
    @message.new_message
  end
  subject { @message.communications }
  its(:count) { should == 2 }

  context 'sender' do
    subject { @message.communications.first }
    it { should have(1).messages }
    it { should respond_to(:mailbox) }
    context 'mailbox' do
      subject { @message.communications.first.mailbox }
      it { should_not be_nil }
      it { should == @message.from_user.mailbox }
    end
  end
  context 'receiver' do
    subject { @message.communications.last}
    it { should have(1).messages }
    it { should respond_to(:mailbox) }
    context 'mailbox' do
      subject { @message.communications.last.mailbox }
      it { should_not be_nil }
      it { should == @message.to_user.mailbox }
    end
  end
end