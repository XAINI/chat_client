class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :member, type: Array

  validates :name, :member, presence: true;

end