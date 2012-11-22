Fabricator(:user_profile) do
  #user { Fabricate(:user) }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  birthday { Date.today }
  gender   { ['male', 'female'].sample }
  seeking  { ['male', 'female'].sample }
  min_age  { (18...35).to_a.sample }
  max_age  { (36...50).to_a.sample }
end
