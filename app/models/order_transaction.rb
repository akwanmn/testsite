class OrderTransaction
  include Mongoid::Document
  embedded_in :order
  #serialize :params

  #field :order_id,      type: Integer
  field :action,        type: String
  field :amount,        type: Integer
  field :success,       type: Boolean
  field :authorization, type: String
  field :message,       type: String
  field :params,        type: Array
  field :is_refunded,   type: Boolean, default: false

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

  def transaction_id
    params['transaction_id']
  end

  def paypal_timestamp
    params['timestamp']
  end

  def cvv2_code
    params['cvv2_code']
  end

  def avs_code
    params['AVSCode']
  end

  def to_dollars
    amount / 100.0
  end

  def refund
    response = GATEWAY.refund(amount, transaction_id)
    order.transactions.create!(action: 'refund', amount: amount, response: response, order: order)
    if response.success?
      self.update_attribute(:is_refunded, true)
    end
    response.success?
  end

end
