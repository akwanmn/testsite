# Make it a gem for easier management - http://timcardenas.com/automatically-reload-gems-in-rails-327-on-eve
# Mailbox (belongs_to)
# => Communications (from, to, mailbox, trash, read, unread, untrash)
#   - 1 per side, linking to the same message? With their status.
# => => Messages (created_at, read_at, sent_at, subject, body)
# has_many :sent_messages, class_name: 'Message', foreign_key: 'from_id'
# has_many :received_messages, class_name: 'Message', foreign_key: 'to_id'
# inverse_of ?
# maybe communication embeds many messages?
# messages count => messages.sent_at > last_sign_in_at
class Communication
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM


  belongs_to :mailbox
  has_and_belongs_to_many :messages

  field :read_at,     type: DateTime
  field :box,         type: String
  field :touched_at,  type: DateTime # last time a message was updated

  scope :inbox, where(:box => 'inbox')
  scope :archive, where(:box => 'archives')
  scope :trash, where(:box => 'trash')

  ############## VALIDATIONS ##############
  ########## CALLBACKS #############
  after_save :update_touched_at

  ############## State Machine ##############
  aasm column: :box do
    state :inbox, initial: true
    state :archives
    state :trash

    event :archive do
      transitions to: :archives, from: [:inbox]
    end

    event :delete do
      transitions to: :trash, from: [:inbox, :archives]
    end

  end
  ########### PUBLIC  ##############

  def latest_message
    messages.last
  end

  # get the other side of the conversation
  def other_party(current_user)
    users = self.messages.map(&:from_user_id).zip(self.messages.map(&:to_user_id)).flatten#.uniq!
    users.delete(current_user.id)
    User.find(users.uniq.first)
  end
  ########### PRIVATE ##############
  def update_touched_at
    self.touched_at = DateTime.now.utc
  end
  private :update_touched_at
end
