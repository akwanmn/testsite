class UserProfile
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  belongs_to :user

  field :birthday,      type: Date
  field :gender,        type: String
  field :seeking,       type: String
  field :min_age,       type: Integer
  field :max_age,       type: Integer
  field :coordinates,   type: Array


  # validations
  validates_inclusion_of :gender, in: ['male', 'female']
  validates_inclusion_of :seeking, in: ['male', 'female']
  validates_numericality_of :min_age, greater_than_or_equal_to: 18
  validates_numericality_of :max_age, less_than_or_equal_to: 120
end
