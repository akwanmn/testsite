Fabricator(:user_profile) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  birthday { Date.today }
  gender   { ['male', 'female'].sample }
  seeking  { ['male', 'female'].sample }
  min_age  { (18...35).to_a.sample }
  max_age  { (36...50).to_a.sample }
  address_street { Faker::Address.street_address}
  address_city   { Faker::Address.city }
  address_state  { Faker::AddressUS.state }
  address_zip    { Faker::AddressUS.zip_code }
  address_country 'US'
end
