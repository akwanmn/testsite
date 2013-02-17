
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  include AASM

  paginates_per 10

  # association
  embeds_one  :user_profile
  embeds_many :photos
  has_many :orders
  accepts_nested_attributes_for :user_profile

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :nickname,           :type => String
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password
  validates :nickname, presence: true, uniqueness: true

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # extra fields
  field :is_admin,           :type => Boolean, :default => false
  field :coordinates,         type: Array
  field :current_state,       type: String
  field :suspended_at,        type: Date

  geocoded_by :address
  after_validation :geocode

  # some delegations to make things cleaner -- Thanks Jon.
  delegate :first_name, :last_name, :address, :address_zip, :likes, to: :user_profile

  default_scope where(:suspended_at => nil)
  scope :suspended, where(:suspended_at.ne => nil)

  # handle membership status
  aasm column: :current_state do
    state :free, initial: true
    state :paid
    state :charter
    state :suspended

    event :make_paid do
      transitions to: :paid, from: [:free, :charter]
    end

    event :make_charter do
      transitions to: :charter, from: [:paid, :free]
    end

    event :make_free do
      transitions to: :free, from: [:charter, :paid, :suspended]
    end

    event :make_suspended do
      transitions to: :suspended, from: [:charter, :paid, :free]
    end
  end

  # def membership_status
  #   case current_state
  #   when 'free'
  #     'Free'
  #   when 'paid'
  #     'Current'
  #   when 'charter'
  #     'Charter'
  #   end
  # end

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  def full_name
    "#{user_profile.first_name} #{user_profile.last_name}" unless user_profile.blank?
  end

  # suspend a user.
  def suspend!
    make_suspended!
    update_attribute(:suspended_at, Date.today)
  end

  def restore!
    make_free!
    update_attribute(:suspended_at, nil)
  end

  # Override the devise valid_password? method so that we can use Django passwords
  # here as well.  Import them straight in and we will check for Devise passwords,
  # otherwise check against Django's format.
  def valid_password?(password)
    begin
      super(password)
    rescue BCrypt::Errors::InvalidHash
      type, salt, enc_pass = encrypted_password.split('$')
      Digest::SHA1.hexdigest("#{salt}#{password}") == enc_pass
    end
  end
  alias :devise_valid_password? :valid_password?

  def self.search(search)
    if search.blank?
      all
    else
      where("$or" => [{email: /#{search}/i}, {'user_profile.first_name' => /#{search}/i}, {'user_profile.last_name' => /#{search}/i}])
    end
  end
end
