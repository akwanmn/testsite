
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
  has_one :mailbox

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
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
  field :nickname,           :type => String
  field :is_admin,           :type => Boolean, :default => false
  field :coordinates,         type: Array
  field :current_state,       type: String
  field :suspended_at,        type: Date

  # some delegations to make things cleaner -- Thanks Jon.
  delegate :first_name, :last_name, :address, :address_zip, :likes, :birthday, to: :user_profile

  validates_presence_of :email
  validates_presence_of :encrypted_password
  validates :nickname, presence: true, uniqueness: true,
    exclusion: {in: %w(admin superadmin root administrator god support billing user service help
      editor email guest info invite marketing master me media messenger nick nickname operator
      sale sales secure shop signup signin security ssh tech username visitor www you yourname yourusername
      ruby registration random rss profile public anonymous app account address webadmin news operator
      adm daemon sysadmin welcome ftp snmp mail abuse alias newsletter contact customer staff job jobs
      network mobile register ruby subscribe stats stat store stores system), message: 'is already taken'}

  geocoded_by :address
  after_validation :geocode
  after_create :create_mailbox#, :send_welcome_email

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

  # pass in address & radius to search for.
  scope :search_radius, lambda {|address, radius| near(address.to_s, radius.to_i) }
  # search for likes, single word or array.
  scope :with_likes, lambda {|l| where('user_profile.likes' => {'$in' =>  l.to_a}) }
  # find people between min age and max age.
  scope :between_ages, lambda {|age1, age2| where(
        'user_profile.birthday' => {'$gte' => (Date.today.beginning_of_year - age2.to_i.years)}).and(
        'user_profile.birthday' => {'$lte' => (Date.today - age1.to_i.years)}
      )}
  # specific gender
  scope :with_gender, lambda {|gender| where('user_profile.gender' => gender.to_s)}
  scope :suspended, where(current_state: 'suspended', :suspended_at.ne => nil)
  scope :not_current_user, lambda {|cu| where(:id.ne => cu.id)}

  # sorting options
  def self.sort_option(option)
    case option
    when 'joined'
      desc(:created_at)
    when 'updated'
      desc(:updated_at)
    else
      desc(:created_at)
    end
  end

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

  def random_profile_image
    photos.sample.photo_file rescue nil
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

  def create_mailbox
    self.mailbox = Mailbox.create!
  end
  private :create_mailbox

  def send_welcome_email
    Notifier.welcome_email(self).deliver
  end
  private :send_welcome_email
end
