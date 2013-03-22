class Mailbox
  include Mongoid::Document
  has_and_belongs_to_many :communications
  belongs_to :user
end
