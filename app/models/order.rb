class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :transactions, class_name: 'OrderTransaction'
  field :ip_address,        type: String
  field :card_type,         type: String
  field :card_expires_on,   type: Date
end