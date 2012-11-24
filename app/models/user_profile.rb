class UserProfile
  include Mongoid::Document
  include Geocoder::Model::Mongoid

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
  field :coordinates,       type: Array
  field :address_street,    type: String
  field :address_street2,   type: String
  field :address_city,      type: String
  field :address_state,     type: String
  field :address_zip,       type: String
  field :address_country,   type: String



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
end
