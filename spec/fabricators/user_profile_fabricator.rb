Fabricator(:user_profile) do
  user { Fabricate(:user) }
  birthday { Date.today }
  gender   { ['male', 'female'].sample }
  seeking  { ['male', 'female'].sample }
  min_age  { (18...35).to_a.sample }
  max_age  { (36...50).to_a.sample }
end
