class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :communication

  field :subject, type: String
  field :body,    type: String
end
