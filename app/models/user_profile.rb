class UserProfile
  include Mongoid::Document

  embedded_in :user

  field :first_name,        type: String
  field :last_name,         type: String
  field :birthday,          type: Date
  field :gender,            type: String
  field :seeking,           type: String
  field :min_age,           type: Integer
  field :max_age,           type: Integer
  field :address_street,    type: String
  field :address_city,      type: String
  field :address_state,     type: String
  field :address_zip,       type: String
  field :address_country,   type: String
  field :biography,         type: String
  field :occupation,        type: String
  field :education,         type: String
  field :ethnicity,         type: String
  field :religion,          type: String
  field :likes,             type: Array
  field :search_radius,     type: Integer, default: 2000
  field :percent_complete,  type: Integer
  field :timezone,          type: String, default: 'UTC'
  field :total_views,       type: Integer
  field :distance_type,     type: String, default: 'mi'

  # more detailed options
  field :marital_status,      type: Integer, default: 0
  field :outdoor_activities,  type: Array, default: []
  field :health_fitness,      type: Integer, default: 0
  field :children,            type: Integer, default: 0
  field :drinking,            type: Integer, default: 0
  field :smoking,             type: Integer, default: 0
  field :eating,              type: Integer, default: 0
  field :politics,            type: Integer, default: 0
  field :reading,             type: Integer, default: 0
  field :nightlife,           type: Array, default: []
  field :travel,              type: Integer, default: 0
  field :career,              type: Integer, default: 0



  # validations -- most are on update so we can create an account without
  # all the profile details
  validates :gender,
    inclusion: {in: GENDERS, message: 'needs a gender'},
    presence: true,
    on: :update
  validates :seeking,
    inclusion: {in: GENDERS, message: 'needs a gender'},
    presence: true,
    on: :update
  validates :min_age,
    numericality: {greater_than_or_equal_to: 18, message: 'must be greater than 18'},
    presence: true,
    on: :update
  validates :max_age,
    numericality: {greater_than: 19, less_than_or_equal_to: 110, message: 'must be between 19 and 110'},
    presence: true,
    on: :update
  validates :birthday,
    presence: true,
    on: :update
  validates :biography,
    presence: true,
    on: :update
  validate :check_age, on: :update
  validates :search_radius,
    numericality: {greater_than: 0, less_than_or_equal_to: 5000, message: 'must be between 0 and 4000'},
    presence: true,
    on: :update

  validates :address_street, presence: true, on: :create # needed for billing / paypal

  # only on my account.
  validates :first_name, :last_name, :address_zip, :address_country, :address_city, :address_state,
    presence: true
  validates :distance_type,
    inclusion: {in: DISTANCE_TYPES.map {|c| c[:value] }, message: 'select miles or kilometers'},
    presence: true,
    on: :update

  # first name, last name, city, state, postal, country, timezone on myaccount

  # callbacks
  after_validation :calculate_profile_percentage
  after_validation :clean_up_arrays, on: :update
  delegate :photos, :coordinates, to: :user

  # Calculate the age of this person.
  def age
    return "-" if birthday.blank?
    now  = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  # Calculate the percentage complete of the profile, maybe even send emails
  # out if they are < 50% on occassion or something for reminders.
  def calculate_profile_percentage
    fields = ['gender', 'seeking', 'min_age', 'max_age', 'address_zip', 'address_country',
      'biography', 'occupation', 'education', 'ethnicity', 'religion', 'likes', 'search_radius',
      'photos', 'birthday', 'address_state', 'address_city', 'distance_type', 'marital_status', 'outdoor_activities', 'health_fitness',
      'children', 'drinking', 'eating', 'politics', 'reading', 'nightlife', 'travel', 'career'
    ]
    percent = (filled_in_fields(fields) / fields.size).round(2) * 100
    self.percent_complete = percent.to_i
  end

  def filled_in_fields(fields)
    filled_in = 0
    fields.each do |f|
      if self.send(f).is_a?(Array)
        # see if the array is actually empty
        filled_in += 1 unless self.send(f).reject(&:blank?).count == 0
      else
        filled_in += 1 unless self.send(f).blank?
      end
    end
    filled_in.to_f
  end

  # cleans up empty items which is silly to have
  def clean_up_arrays
    self.likes.reject! {|l| l.empty? }
    self.outdoor_activities.reject! {|l| l.empty? }
    self.nightlife.reject! {|l| l.empty? }
  end

  # match zipcode to state, just to make sure we have consistent data.
  def zip_code_matches_state
    return false if address_zip.blank?
    location = Geocoder.search(address_zip).first
    unless location.state.downcase == address_state.downcase
      self.errors[:base] << "State (#{address_state}) & Zip Code (#{location.state}) do not match!"
    end
  end

  def latitude
    coordinates[1]
  end

  def longitude
    coordinates[0]
  end

  def address
    address_zip
  end

  # determine their location approximately.
  def approximate_location
    if !user.coordinates.blank?
      location = Geocoder.search(user.coordinates.reverse).first
    else
      location = Geocoder.search(address_zip).first
    end
    location.nil? ? 'Unknown' : location.data['formatted_address']
  end

  # Checks the age to make sure someone is within a proper age range.
  def check_age
    errors.add(:birthday, "must be before #{(Date.today - 18.years).strftime('%m/%d/%Y')}") if age.to_i < 18
    errors.add(:birthday, "must be after #{(Date.today - 110.years).strftime('%m/%d/%Y')}") if age.to_i > 110
  end
  private :check_age
end
