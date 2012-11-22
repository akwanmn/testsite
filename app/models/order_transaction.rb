class OrderTransaction
  include Mongoid::Document
  embedded_in :order
  #serialize :params

  field :order_id,      type: Integer
  field :action,        type: String
  field :amount,        type: Integer
  field :success,       type: Boolean
  field :authorization, type: String
  field :message,       type: String
  field :params,        type: String
end
