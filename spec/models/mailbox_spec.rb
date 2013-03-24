require 'spec_helper'

describe Mailbox do
  subject { Fabricate(:mailbox) }

  context 'communications' do
    it 'has one communication' do
      subject.communications.count == 1
    end

    context 'messages' do
      let(:comm) { subject.communications.first }
      it 'has messages' do
        comm.messages.length.should == 3
      end
    end

  end
end