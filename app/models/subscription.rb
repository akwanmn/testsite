class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  field :duration,    type: Integer
  field :recurring,   type: Boolean, default: false
  field :name,        type: String
  field :amount,      type: Float
  field :disabled,    type: Boolean

  validates :duration,
    inclusion: {in: (0...366).to_a, message: 'Must be between 0 and 365.'},
    presence: true
  validates :amount,
    presence: true,
    format: {with: /^[0-9]+\.[0-9]{2}$/, message: 'must contain dollars and cents, separated by a period (xxxx.xx)'}
  validates_presence_of :name
end
