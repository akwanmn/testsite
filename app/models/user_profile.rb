class UserProfile
  include Mongoid::Document

  # Maybe move out to a lib/constants for now?
  GENDERS = ['Male', 'Female']
  EDUCATION = [
    "High School",
    "Some College",
    "Associate Degree",
    "Bachelor's Degree",
    "Master's Degree",
    "PhD / Post Doctoral",
    "Trade",
    "Other"
  ]

  ETHNICITY = [
    "African-American",
    "American Indian",
    "Asian / Pacific Islander",
    "Caucasian",
    "Hispanic",
    "Indian",
    "Middle-Eastern"
  ]

  RELIGIONS = [
    'African Traditional and Diasporic',
    'Agnostic',
    'Assemblies of God',
    'Baptist',
    'Cao Dai',
    'Catholic',
    'Chinese Traditional',
    'Christian',
    'Church of Latter-Day Saints (Mormon)',
    'Episcopalian',
    'Hinduism',
    'Islam',
    'Juche',
    'Judaism',
    'Lutheran (Evangelical)',
    'Lutheran (Missouri Synod)',
    'Methodist',
    'Neo-Paganism',
    'Non-Religious (Secular/Agnostic/Atheist)',
    'Presbyterian',
    'Primal-Indigenous',
    'Shinto',
    'Sikhism',
    'Spiritism',
    'Tenrikyo',
    'Unitarian-Universalism',
    'Zoroastrianism'
  ]

  LIKES = [
    'Animals',
    'Books & Reading',
    'Career',
    'Education',
    'Family',
    'Health & Fitness',
    'Nightlife',
    'Outdoors',
    'Politics',
    'Religion',
    'Social Life',
    'Travel'
  ]

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
    numericality: {greater_than: 0, less_than_or_equal_to: 4000, message: 'must be between 0 and 4000'},
    presence: true,
    on: :update
  validates :address_street, presence: true, on: :create # needed for billing / paypal
  validates :first_name, :last_name, :address_zip, :address_country, :address_city, :address_state,
    presence: true

  # callbacks
  after_validation :calculate_profile_percentage
  after_validation :clean_up_likes, on: :update
  delegate :photos, to: :user

  # Calculate the age of this person.
  def age
    return "-" if birthday.blank?
    now = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  # Calculate the percentage complete of the profile, maybe even send emails
  # out if they are < 50% on occassion or something for reminders.
  def calculate_profile_percentage
    fields = ['gender', 'seeking', 'min_age', 'max_age', 'address_zip', 'address_country',
      'biography', 'occupation', 'education', 'ethnicity', 'religion', 'likes', 'search_radius',
      'photos', 'birthday', 'address_state', 'address_city']
    filled_in = 0
    Rails.logger.debug "*" * 40
    fields.each do |f|
      if self.send(f).is_a?(Array)
        # see if the array is actually empty
        filled_in += 1 unless self.send(f).reject(&:blank?).count == 0
        Rails.logger.debug "Missing: #{f}" if self.send(f).reject(&:blank?).count == 0
      else
        Rails.logger.debug "Missing: #{f}" if self.send(f).blank?
        filled_in += 1 unless self.send(f).blank?
      end
    end
    percent = (filled_in.to_f / fields.length.to_f).round(2) * 100
    self.percent_complete = percent.to_i
  end

  def clean_up_likes
    self.likes.reject! {|l| l.empty? }
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
    if age.to_i < 18
      errors.add(:birthday, "must be before #{(Date.today - 18.years).strftime('%m/%d/%Y')}")
    elsif age.to_i > 110
      errors.add(:birthday, "must be after #{(Date.today - 110.years).strftime('%m/%d/%Y')}")
    end
  end
  private :check_age
end
