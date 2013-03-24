Fabricator(:message) do
  subject { Faker::Lorem.words(3).join(' ') }
  body    { Faker::Lorem.paragraph(3)}
end
