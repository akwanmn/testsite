class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :communication_id

  paginates_per 10

  ############## Associations ##############
  has_and_belongs_to_many :communications
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'

  field :subject, type: String
  field :body,    type: String
  field :sent_at, type: DateTime
  ############## Callbacks ##############
  ############## Validations ##############
  validates_presence_of :subject, :body, :from_user, :to_user

  ############## Public  ##############
  # Used only when its a brand new message, otherwise use reply.
  def send_message
    create_sender_communication
    create_receiver_communication
    update_sent_at
    self.save!
  end

  def reply_message
    format_reply_subject
    update_sent_at
    self.save!
  end

  ##############  Private ##############
  def format_reply_subject
    self.subject = self.subject.downcase.start_with?('re:') ? self.subject : "Re: #{subject}"
  end
  private :format_reply_subject

  def create_sender_communication
    self.communications << Communication.create!(mailbox: from_user.mailbox, touched_at: DateTime.now.utc)
  end
  private :create_sender_communication

  def create_receiver_communication
    self.communications << Communication.create!(mailbox: to_user.mailbox, touched_at: DateTime.now.utc)
  end
  private :create_receiver_communication

  def update_sent_at
    self.sent_at = DateTime.now.utc
  end
  private :update_sent_at
end
