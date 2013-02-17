class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_PRICE = 12.95 # hard coded for now until we build a subscription class.

  attr_accessor :card_number, :card_verification, :address, :city, :state, :zip, :name,
    :country, :amount, :first_name, :last_name, :purchase_response

  paginates_per 5
  belongs_to :user
  embeds_many :transactions, class_name: 'OrderTransaction'

  field :ip_address,        type: String
  field :card_type,         type: String
  field :card_expires_on,   type: Date
  field :card_used,         type: String

  # only run validate_card if card_number is not blank
  validate :validate_card, on: :create, unless: lambda {|r| r.card_number.blank? }
  # make sure we have all these fields.
  validates_presence_of :address, :card_number, :card_verification, :city, :state, :zip, :name, :country,
    :card_expires_on, :amount

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create(action: 'purchase', amount: price_in_cents, response: response)
    user.make_paid!  if response.success?
    response.success?
  end

  # simpliefied for the join process page.
  def join_purchase
    @purchase_response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    @purchase_response.success?
  end

  # used to finalize a transaction for pages like join where we need a response
  # before adding the uer, this does the rest of the purchase items.
  def finalize_transaction(type='purchase')
    self.save
    self.user.make_paid! if (!user.nil? && user.persisted?)
    self.transactions.create(action:type, amount: self.price_in_cents, response: self.purchase_response)
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

  # takes the params passed in and builds an order for the
  # index page.
  def from_join_params(params)
    self.first_name          = params[:user_profile_attributes][:first_name]
    self.last_name           = params[:user_profile_attributes][:last_name]
    self.card_number         = params[:order][:card_number]
    self.card_verification   = params[:order][:card_verification]
    self.ip_address          = params[:request_ip]
    self.address             = params[:user_profile_attributes][:address_street]
    self.city                = params[:user_profile_attributes][:address_city]
    self.state               = params[:user_profile_attributes][:address_state]
    self.zip                 = params[:user_profile_attributes][:address_zip]
    self.country             = params[:user_profile_attributes][:address_country]
    self.amount              = DEFAULT_PRICE
    self.card_expires_on     = Date.parse(params[:order][:card_expires_on]).end_of_month rescue nil
    self.name                = "#{first_name} #{last_name}"
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
        :country => country,
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
      :month              => (card_expires_on.month rescue nil),
      :year               => (card_expires_on.year rescue nil),
      :first_name         => (user.first_name rescue first_name),
      :last_name          => (user.last_name rescue last_name)
    )
  end

end