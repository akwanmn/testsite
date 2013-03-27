class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  ############## Associations ##############
  has_and_belongs_to_many :communications
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'

  field :subject, type: String
  field :body,    type: String
  field :sent_at, type: DateTime
  ############## Callbacks ##############
  after_create :update_sent_at

  ############## Validations ##############
  validates_presence_of :subject, :body, :from_user, :to_user

  ############## Public  ##############
  # Used only when its a brand new message, otherwise use reply.
  def new_message
    create_sender_communication
    create_receiver_communication
  end

  def reply_message
    # pending
  end

  ##############  Private ##############
  def create_sender_communication
    self.communications << Communication.create!(mailbox: from_user.mailbox)
  end
  private :create_sender_communication

  def create_receiver_communication
    self.communications << Communication.create!(mailbox: to_user.mailbox)
  end
  private :create_receiver_communication

  def update_sent_at
    self.sent_at = DateTime.now.utc
  end
  private :update_sent_at
end
