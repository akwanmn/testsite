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

  def response=(response)
    self.success        = response.success?
    self.authorization  = response.authorization
    self.message        = response.message
    self.params         = response.params
  rescue ActiveMerchant::ActiveMerchantError => e 
    self.success        = false
    self.authorization  = nil
    self.message        = e.message 
    self.params         = {}
  end
end
