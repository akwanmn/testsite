class Photo
  include Mongoid::Document
  attr_accessible :photo_file
  embedded_in :user # has many photos for each user.
  mount_uploader :photo_file, ProfilePhotoUploader
  field :approved,   type: Boolean,   default: true
end
