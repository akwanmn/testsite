require 'spec_helper'

describe Mailbox do
  subject { Fabricate(:mailbox) }

  context 'communications' do
    context 'messages' do
      let(:comm) { subject.communications.first }
      it 'has messages' do
        comm.messages.length.should == 3
      end
    end

  end
end