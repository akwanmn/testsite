require 'spec_helper'

describe UserProfile do
  let(:user) { Fabricate(:user) }
  subject { user.user_profile }
  context 'Fabricator' do
    it { should be_valid }
  end

  its(:age) { should eql 30 }
  its(:calculate_profile_percentage) { should eql 72 }
  its(:latitude) { should_not be_nil }
  its(:longitude) { should_not be_nil }
  its(:address_zip) { should_not be_nil }

  context 'age check' do
    let(:underage_profile) { Fabricate.build(:user_profile, birthday: (DateTime.now - 12.years)) }
    let(:overage_profile) { Fabricate.build(:user_profile, birthday: (DateTime.now - 120.years)) }
    context 'underage' do
      subject(:underage) { Fabricate(:user, user_profile: underage_profile).user_profile }
      its(:valid?) { should be_false }
      it 'errors' do
        subject.valid?
        subject.errors[:birthday].first.should include('must be before')
      end
    end
    context 'overage' do
      subject(:overage) { Fabricate(:user, user_profile: overage_profile).user_profile }
      its(:valid?) { should be_false }
      it 'errors' do
        subject.valid?
        subject.errors[:birthday].first.should include('must be after')
      end
    end
  end

  context 'GLOBALS' do
    ['GENDERS', 'EDUCATION', 'ETHNICITY',
      'RELIGIONS', 'LIKES', 'DISTANCES', 'DISTANCE_TYPES'].each do |t|
      it "#{t}" do
        UserProfile.const_get(t).should_not be_nil
      end
    end
  end

  context 'validations' do
    let(:zipcode) { Fabricate.build(:user, user_profile: Fabricate.build(:user_profile, address_zip: nil)) }
    it 'zip code is required' do
      zipcode.valid?.should be_falseher
    end
  end

end
