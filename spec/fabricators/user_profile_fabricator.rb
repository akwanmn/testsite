Fabricator(:user_profile) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  gender   { ['Male', 'Female'].sample }
  seeking  { ['Male', 'Female'].sample }
  min_age  { (18...35).to_a.sample }
  max_age  { (36...50).to_a.sample }
  address_street { Faker::Address.street_address}
  address_city   { Faker::Address.city }
  address_state  { Faker::AddressUS.state }
  address_zip    '48843'
  address_country 'US'
  search_radius 1000
  birthday { DateTime.now - 30.years }
  biography 'This is a sample biography'
  likes { [ LIKES.sample ]}
  biography 'This is a test biography.'
end
