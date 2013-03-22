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
  include AASM

  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'
  belongs_to :mailbox

  field :subject,       type: String
  field :body,          type: String
  field :sent_at,       type: DateTime

  # validations
  validates_presence_of :from_user_id, :to_user_id, :subject, :body

  # callbacks
  after_create :populate_sent_at

  # inbox = created and sent_to = current_user
  # archived = archived and sent_to = current_user
  # sent = from_user = current_user
  # trash_from_user = ?
  # trash_to_user = ?

  # aasm column: :status do
  #   state :created, initial: true
  #   state :viewed
  #   state :archived

  #   event :view, :before => :populate_viewed_at do
  #     transitions to: :viewed, from: [:created]
  #   end

  #   event :archive do
  #     transitions to: :archived, from: :viewed
  #   end
  # end

  # methods
  def populate_sent_at
    self.sent_at = DateTime.now.utc
  end

  # def populate_viewed_at
  #   self.viewed_at = DateTime.now.utc
  # end

end
