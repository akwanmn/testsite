class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :card_number, :card_verification

  belongs_to :user
  embeds_many :transactions, class_name: 'OrderTransaction'

  field :ip_address,        type: String
  field :card_type,         type: String
  field :card_expires_on,   type: Date

  # make sure we have a good card on new order.
  validate :validate_card, on: :create

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create!(action: 'purchase', amount: price_in_cents, response: response)
    response.success?
  end

  # default
  def price_in_cents
    12.95 * 100
  end

  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name => user.full_name,
        :address1 => user.user_profile.address_street,
        :city => user.user_profile.address_city,
        :state => user.user_profile.address_state,
        :country => user.user_profile.address_country,
        :zip => user.user_profile.address_zip
      }
    }
  end
  private :purchase_options

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add :base, message
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