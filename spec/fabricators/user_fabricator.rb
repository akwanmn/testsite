Fabricator(:user) do
  email { Faker::Internet.email }
  first_name 'Andy'
  last_name 'Holman'
  password 'andy12'
  password_confirmation 'andy12'
  user_profile { |u| Fabricate.build(:user_profile, user: u) }
  nickname { Faker::Internet.user_name }
  #after_create { |user| Fabricate(:mailbox, user: user) }
end
