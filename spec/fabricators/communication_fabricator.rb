Fabricator(:communication) do
  from_user { Fabricate(:user) }
  to_user { Fabricate(:user) }
  messages(count: 3) { |attrs, i| Fabricate(:message, subject: "Subject #{i}")}
end
