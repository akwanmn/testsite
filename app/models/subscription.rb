class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  field :duration,    type: Integer
  field :recurring,   type: Boolean, default: false
  field :name,        type: String
  field :amount,      type: Float
  field :disabled,    type: Boolean

  validates_inclusion_of :duration, in: (0...366).to_a, message: 'Must be between 0 and 365 days.'
  validates_presence_of :name, :amount, :duration
  validates_format_of :amount, :with => /^[0-9]+\.[0-9]{2}$/, :message => "must contain dollars and cents, seperated by a period (xxxxx.xx)"
end
