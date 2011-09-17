class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :name
  field :email
  field :password_digest

  has_secure_password

  validates :name, :email, :presence => true
end
