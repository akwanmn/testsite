Fabricator(:communication) do
  messages(count: 1) { |attrs, i| Fabricate(:message, subject: "Subject #{i}")}
end
