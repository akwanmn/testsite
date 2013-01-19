class Communication
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include AASM


  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'

  field :subject,       type: String
  field :body,          type: String
  field :sent_at,       type: DateTime
  field :viewed_at,     type: DateTime
  field :status,        type: String

  # validations
  validates_presence_of :from_user_id, :to_user_id, :subject, :body

  # callbacks
  after_create :populate_sent_at

  aasm column: :status do
    state :created, initial: true
    state :viewed

    event :seen, :before => :populate_viewed_at do
      transitions to: :viewed, from: [:created]
    end
  end

  # methods
  def populate_sent_at
    self.sent_at = DateTime.now.utc
  end

  def populate_viewed_at
    self.viewed_at = DateTime.now.utc
  end

end
