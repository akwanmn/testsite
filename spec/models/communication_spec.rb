require 'spec_helper'

describe Communication do
  before do
    @message = Fabricate(:message)
    @message.send_message
  end
  subject { @message.communications }
  its(:count) { should == 2 }

  context 'sender' do
    subject { @message.communications.first }
    it { should have(1).messages }
    it { should respond_to(:mailbox) }
    its(:created_at) { should_not be_nil }
    its(:box) { should == 'inbox' }
    context 'mailbox' do
      subject { @message.communications.first.mailbox }
      it { should_not be_nil }
      it { should == @message.from_user.mailbox }
    end

    context 'boxes' do
      context 'scopes' do
      end

      context 'archives' do
        before { subject.archive! }
        its(:box) { should == 'archives' }
      end
      context 'trash' do
        before { subject.delete! }
        its(:box) { should == 'trash'}
        it 'should not affect the receiver' do
          @message.communications.last.box.should == 'inbox'
        end
      end
    end
  end
  context 'receiver' do
    subject { @message.communications.last}
    it { should have(1).messages }
    it { should respond_to(:mailbox) }
    its(:created_at) { should_not be_nil }
    context 'mailbox' do
      subject { @message.communications.last.mailbox }
      it { should_not be_nil }
      it { should == @message.to_user.mailbox }
    end
  end
end