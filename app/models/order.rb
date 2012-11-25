class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_PRICE = 12.95 # hard coded for now until we build a subscription class.

  attr_accessor :card_number, :card_verification, :address, :city, :state, :zip, :name,
    :country, :amount

  paginates_per 5
  belongs_to :user
  embeds_many :transactions, class_name: 'OrderTransaction'

  field :ip_address,        type: String
  field :card_type,         type: String
  field :card_expires_on,   type: Date
  field :card_used,         type: String

  # make sure we have a good card on new order.
  validate :validate_card, on: :create
  validates_presence_of :address, :card_number, :card_verification, :city, :state, :zip, :name, :country,
    :card_expires_on, :amount

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create(action: 'purchase', amount: price_in_cents, response: response)
    user.make_paid!  if response.success?
    response.success?
  end

  def initial_transaction
    transactions.first
  end

  # Determine the overall status of the order.
  def status
    statuses = []
    transactions.where(action: 'purchase').each do |t|
      statuses << (t.is_refunded ? 'Refunded' : 'Valid')
    end
    if statuses.uniq.length > 1
      'Partially Refunded'
    else
      (statuses.uniq == ['Refunded']) ? 'Fully Refunded' : 'Valid'
    end
  end

  # default
  def price_in_cents
    amount.to_f * 100
  end

  # TODO: Make this actually take input params
  # not just what we have on file, to allow for 
  # other cards to be used?
  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name => name,
        :address1 => address,
        :city => city,
        :state => state,
        :country => 'US',
        :zip => zip
      }
    }
  end
  private :purchase_options

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add :card_number, message
      end
    end
  end
  private :validate_card


  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :brand              => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => user.first_name,
      :last_name          => user.last_name
    )
  end

end