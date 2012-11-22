Fabricator(:order) do
  ip_address      { Faker::Internet.ip_v4_address }
  card_type       { ["Visa", "MasterCard", "Discover", "American Express"].sample }
  card_expires_on { Date.today + 1.year }
end
