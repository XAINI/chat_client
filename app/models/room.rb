class Room
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickename, type: String

  validates :nickename, presence: true
end
