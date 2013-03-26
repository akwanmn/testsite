Fabricator(:mailbox) do
  user
  communications(count: 1)
end
