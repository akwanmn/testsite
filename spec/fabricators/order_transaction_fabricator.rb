Fabricator(:order_transaction) do
  action 'Purchase'
  amount '10000'
  success true
  authorization 'Authorization'
  message 'This is the message'
  params 'params'
  is_refunded false
end
