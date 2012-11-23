Fabricator(:order) do
  ip_address        { Faker::Internet.ip_v4_address }
  card_type         'bogus'
  card_expires_on   { Date.today + 1.year }
  card_number       '1'
  card_verification  '111'
  user
end
