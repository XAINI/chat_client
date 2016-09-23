class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :creator, type: String
  field :member, type: Array

  validates :name, :creator, :member, presence: true;

end