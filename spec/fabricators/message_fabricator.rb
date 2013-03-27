Fabricator(:message) do
  from_user { Fabricate(:user) }
  to_user { Fabricate(:user) }
  subject { Faker::Lorem.words(3).join(' ') }
  body    { Faker::Lorem.paragraph(3)}
end
