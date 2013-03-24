# Make it a gem for easier management - http://timcardenas.com/automatically-reload-gems-in-rails-327-on-eve
# Mailbox (belongs_to)
# => Communications (from, to, mailbox, trash, read, unread, untrash)
#   - 1 per side, linking to the same message? With their status.
# => => Messages (created_at, read_at, sent_at, subject, body)
# has_many :sent_messages, class_name: 'Message', foreign_key: 'from_id'
# has_many :received_messages, class_name: 'Message', foreign_key: 'to_id'
# inverse_of ?
# maybe communication embeds many messages?
class Communication
  include Mongoid::Document
  include Mongoid::Timestamps
  #include AASM

  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'
  has_and_belongs_to_many :messages

  field :read_at,   type: DateTime
  field :sent_at,   type: DateTime

  ########## CALLBACKS #############
  before_save :update_sent_at

  ########### PUBLIC  ##############

  ########### PRIVATE ##############
  def update_sent_at
    self.sent_at = DateTime.now.utc
  end
  private :update_sent_at


end
