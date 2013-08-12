require 'spec_helper'

describe User do

  subject { Fabricate(:user) }
  context 'Fabricator' do
    it { should be_valid }
  end

  its(:first_name) { should_not be_nil }
  its(:last_name) { should_not be_nil }
  its(:address) { should_not be_nil }
  its(:address_zip) { should_not be_nil }
  its(:likes) { should_not be_nil }
  its(:birthday) { should_not be_nil }

  it { should respond_to(:make_free) }
  it { should respond_to(:make_charter) }
  it { should respond_to(:make_suspended) }
  it { should respond_to(:make_paid) }

  it '#full_name' do
    name = "#{subject.user_profile.first_name} #{subject.user_profile.last_name}"
    subject.full_name.should eql "#{name}"
  end

  context 'authentication' do
    let(:new_password) { }
    let(:django_password) { 'sha1$cde18$646d3172f4d5df48dc25f7fc09698e277e9c3567' }
    context 'django migration' do
      subject { Fabricate(:user, encrypted_password: django_password) }
      it { should be_valid_password('andy12') }
    end
    context 'new authentication' do
      it { should be_valid_password('andy12') }
    end
  end

  context 'mailbox' do
    it 'has one' do
      subject.mailbox.should_not be_nil
    end
  end

  context "user status" do
    context 'suspend' do
      before do
        subject.suspend!
      end
      it { should be_suspended }
    end
    context 'restore' do
      before do
        subject.suspend!
        subject.restore!
      end
      it { should be_free }
    end
  end

  context '#random_profile_image' do
    before do
      subject.stub(:photos).and_return([OpenStruct.new(photo_file: 1), OpenStruct.new(photo_file: 2)])
    end
    it { should have(2).photos }
    its(:random_profile_image) { should_not be_nil }
  end

  # context '#duplicate usernames' do
  #   let(:duplicate) { Fabricate.build(:user, nickname: subject.nickname)}
  #   it 'should not be allowed' do
  #     duplicate.valid?.should be_false
  #   end
  # end

end
