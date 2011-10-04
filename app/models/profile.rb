class Profile
  include Mongoid::Document

  field :name
  field :url
  field :description

  embedded_in :user

  validates :name, :length => {:in => 3..20, :allow_blank => true}
  validates :url, :length => {:maximum => 100}
  validates :description, :length => {:maximum => 300}

  attr_accessible :name, :url, :description
end
