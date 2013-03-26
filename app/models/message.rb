class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :communications

  field :subject, type: String
  field :body,    type: String
end
