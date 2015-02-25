json.array!(@payments) do |payment|
  json.extract! payment, :id, :date, :memo, :paysb, :payks, :paysc, :paykn
  json.url payment_url(payment, format: :json)
end
