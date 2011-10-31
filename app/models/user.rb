class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Voter
  include ActiveModel::SecurePassword
  include Gravtastic
  gravtastic :rating => 'G', :size => 48, :secure => false

  field :name
  field :email
  field :password_digest
  field :favorite_tags, :type => Array, :default => []
  field :access_token
  field :locale, :default => I18n.locale.to_s

  has_secure_password

  validates :name, :email, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :format => {:with => /\A\w+\z/, :message => 'only A-Z, a-z, _ allowed'}, :length => {:in => 3..20}
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/}
  validates :password, :password_confirmation, :presence => true, :on => :create
  validates :password, :length => {:minimum => 6, :allow_nil => true}
  validates :current_password, :current_password => {:fields => [:name, :email, :password]}, :on => :update
  validates :extra_favorite_tag_string, :format => { :with => /\A[^\/]+\z/, :message => I18n.t("errors.no_allow_slash"), :allow_blank => true}
  validates :locale, :inclusion => {:in => AllowLocale}
  
  attr_accessor :current_password
  attr_reader :extra_favorite_tag_string
  attr_accessible :name, :email, :password, :password_confirmation, :current_password, :extra_favorite_tag_string, :locale

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
    self.access_token ||= generate_token
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

  # TODO old data migration begin
  field :crypted_password
  field :password_salt
  def authenticate_with_old_data(password)
    if password_digest.present?
      authenticate_without_old_data(password)
    else
      if old_authenticate(password)
        self.password = self.password_confirmation = password
        self.crypted_password = self.password_salt = nil
        save(:validate => false)
        true
      else
        false
      end
    end
  end
  alias_method_chain :authenticate, :old_data

  def old_authenticate(password)
    self.crypted_password == encrypt_password(password)
  end

  def encrypt_password(password)
    digest = [password, self.password_salt].flatten.join('')
    20.times { digest = User.secure_digest(digest) }
    digest
  end
  
  def self.secure_digest(*args)
    Digest::SHA512.hexdigest(args.flatten.join)
  end
  # TODO old data migration end
end
