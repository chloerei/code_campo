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
  field :access_token

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

  has_many :notifications, :class_name => 'Notification::Base', :dependent => :delete do
    def has_unread?
      unread.count > 0
    end
  end
  has_many :resources, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  has_many :replies, :dependent => :delete
  embeds_one :profile

  before_create :build_profile, :set_access_token
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

  def read_notifications(notifications)
    unread_ids = notifications.find_all{|notification| !notification.read?}.map(&:_id)
    if unread_ids.any?
      Notification::Base.where({
        :user_id => id,
        :_id.in  => unread_ids,
        :read    => false
      }).update_all(:read => true)
    end
  end

  def mark_all_notifications_as_read
    Notification::Base.where({
      :user_id => id,
      :read    => false
    }).update_all(:read => true)
  end

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_token(token)
    user = first :conditions => {:_id => token.split('$').first}
    (user && user.remember_token == token) ? user : nil
  end

  def screen_name
    profile.name == name ? name : "#{name}(#{profile.name})"
  end

  def set_access_token
    self.access_token = generate_token
  end

  def generate_token
    SecureRandom.hex(32)
  end

  def reset_access_token
    update_attribute :access_token, generate_token
  end

  def self.find_by_access_token(token)
    first :conditions => {:access_token => token} if token.present?
  end
end
