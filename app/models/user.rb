class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Voter
  include ActiveModel::SecurePassword
  include Gravtastic
  gravtastic :rating => 'G', :size => 48

  field :name
  field :email
  field :password_digest
  field :favorite_tags, :type => Array, :default => []

  has_secure_password

  validates :name, :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :format => {:with => /\A\w+\z/, :message => 'only A-Z, a-z, _ allowed'}, :length => {:in => 3..20}
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, :message => 'Invalid Email address'}
  validates :password, :password_confirmation, :presence => true, :on => :create
  validates :password, :length => {:minimum => 6, :allow_nil => true}
  validates :current_password, :current_password => {:fields => [:name, :email, :password]}, :on => :update
  validates :extra_favorite_tag_string, :format => { :with => /\A[^\/]+\z/, :message => "no allow slash", :allow_blank => true}
  
  attr_accessor :current_password
  attr_reader :extra_favorite_tag_string
  attr_accessible :name, :email, :password, :password_confirmation, :current_password, :extra_favorite_tag_string

  has_many :resources
  has_many :comments
  has_many :topics
  has_many :replies
  embeds_one :profile

  before_create :build_profile
  after_save :clear_extra_favorite_tag_string

  def remove_favorite_tag(tag)
    collection.update({:_id => self.id},
                      {"$pull" => {:favorite_tags => tag}})
  end

  def extra_favorite_tag_string=(string)
    self.favorite_tags += string.to_s.downcase.split(/[,\s]+/).uniq
    self.favorite_tags.uniq!
    @extra_favorite_tag_string = string
  end

  def clear_extra_favorite_tag_string
    @extra_favorite_tag_string = nil
  end

  def to_param
    name
  end

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_token(token)
    user = first :conditions => {:_id => token.split('$').first}
    (user && user.remember_token == token) ? user : nil
  end
end
