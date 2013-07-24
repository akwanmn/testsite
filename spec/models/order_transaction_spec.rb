require 'spec_helper'

describe OrderTransaction do
  let!(:user) { Fabricate(:user) }
  let!(:current_order) { Fabricate(:order, user: user,
    address: user.user_profile.address_street,
    city: user.user_profile.address_city,
    zip: user.user_profile.address_zip,
    state: user.user_profile.address_state,
    name: user.full_name,
    first_name: user.first_name,
    last_name: user.last_name,
    country: user.user_profile.address_country) }
  subject { current_order.purchase; current_order.initial_transaction }


  its(:action) { should eql 'purchase' }
  its(:amount) { should eql 1295}
  its(:success) { should be_true }
  its(:authorization) { should eq '53433' }
  its(:message) { should eql 'Bogus Gateway: Forced success' }
  its(:is_refunded) { should be_false }
end
