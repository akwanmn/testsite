class Mailbox
  include Mongoid::Document
  belongs_to :communication
  belongs_to :user

end
