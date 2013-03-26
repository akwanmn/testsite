Fabricator(:communication) do
  from_user { Fabricate(:user) }
  to_user { Fabricate(:user) }
  subject 'Testing'
  body 'Testing Again'
  messages(count: 3) { |attrs, i| Fabricate(:message, subject: "Subject #{i}")}
end
