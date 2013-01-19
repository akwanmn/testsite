class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :membership_status
end
