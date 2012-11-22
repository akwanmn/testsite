class UserProfile
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  embedded_in :user

  field :first_name,    type: String
  field :last_name,     type: String
  field :birthday,      type: Date
  field :gender,        type: String
  field :seeking,       type: String
  field :min_age,       type: Integer
  field :max_age,       type: Integer
  field :coordinates,   type: Array


  # validations
  #validates_inclusion_of :gender, in: ['male', 'female']
  #validates_inclusion_of :seeking, in: ['male', 'female']
  #validates_numericality_of :min_age, greater_than_or_equal_to: 18
  #alidates_numericality_of :max_age, less_than_or_equal_to: 120
end
