class UserProfile
  include Mongoid::Document

  attr_accessor :selected_birthday

  GENDERS = ['Male', 'Female']

  embedded_in :user

  field :first_name,        type: String
  field :last_name,         type: String
  field :birthday,          type: Date
  field :gender,            type: String
  field :seeking,           type: String
  field :min_age,           type: Integer
  field :max_age,           type: Integer
  field :address_city,      type: String
  field :address_state,     type: String
  field :address_zip,       type: String
  field :address_country,   type: String

  #geocoded_by :address_zip
  #after_validation :geocode, :if => :address_zip_changed?

  # validations
  validates_inclusion_of :gender, in: GENDERS
  validates_inclusion_of :seeking, in: GENDERS
  validates_numericality_of :min_age, greater_than_or_equal_to: 18
  validates_numericality_of :max_age, less_than_or_equal_to: 120
  validates_presence_of :first_name, :last_name, :selected_birthday, 
    :gender, :seeking, :min_age, :max_age

  # Calculate the age of this person.
  def age
    return "-" if birthday.blank?
    now = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  def latitude
    coordinates[1]
  end

  def longitude
    coordinates[0]
  end

  def address
    #addy = "#{address_city} #{address_state}, #{address_zip} #{address_country}"
    address_zip
  end

  def approximate_location
    if !user.coordinates.blank?
      location = Geocoder.search(user.coordinates.reverse).first
    else
      location = Geocoder.search(address_zip).first
    end
    location.nil? ? 'Unknown' : location.data['formatted_address']
  end
end
