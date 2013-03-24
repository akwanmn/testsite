require 'spec_helper'

describe Message do
  subject { Fabricate(:message) }
  its(:body) { should_not be_blank }
  its(:subject) { should_not be_blank }
  its(:created_at) { should_not be_blank }
  its(:updated_at) { should_not be_blank }
end
