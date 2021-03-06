class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :sender, type: String
  field :msg, type: String
  field :receiver, type: String
  field :group_id, type: String
  field :flag, type: String

  validates :sender, :msg, :receiver, :flag, presence: true

end