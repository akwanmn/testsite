Fabricator(:user) do
  email { Faker::Internet.email }
  password 'andy12'
  password_confirmation 'andy12'
  user_profile { |u| Fabricate.build(:user_profile, user: u) }
end
