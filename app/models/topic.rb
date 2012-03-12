class Topic
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::NumberId
  include Mentionable

  field :title
  field :content
  field :tags,               :type => Array,   :default => []
  field :actived_at,         :type => Time
  field :edited_at,          :type => Time
  field :replies_count,      :type => Integer, :default => 0
  field :marker_ids,         :type => Array,   :default => []
  field :replier_ids,        :type => Array,   :default => []
  field :last_read_user_ids, :type => Array,   :default => []

  belongs_to :user
  belongs_to :last_reply_user, :class_name => 'User'
  has_many   :replies, :dependent => :delete

  validates :title, :content, :user, :presence => true
  validates :tag_string, :tag_string => true, :format => { :with => /\A[^\/]+\z/, :message => I18n.t("errors.no_allow_slash"), :allow_blank => true}

  before_create :set_actived_at

  attr_accessible :title, :content, :tag_string

  scope :active, order_by([[:actived_at, :desc]])
  scope :mark_by, lambda {|user| where(:marker_ids => user.id)}
  scope :reply_by, lambda {|user| where(:replier_ids => user.id)}

  def tag_string=(string)
    self.tags = string.to_s.downcase.split(/[,\s]+/).uniq
  end

  def tag_string
    self.tags.join(', ')
  end

  def set_actived_at
    self.actived_at = Time.now.utc
  end

  def set_edited_at
    self.edited_at = Time.now.utc
  end

  def edited?
    edited_at.present?
  end

  def last_page
    page = (replies_count.to_f / self.class.default_per_page).ceil
    page > 1 ? page : nil
  end

  def last_anchor
    replies_count > 0 ? "replies-#{replies_count}" : nil
  end

  def anchor
    "topic-#{number_id}"
  end

  def relate_topics(count)
    Topic.active.any_in(:tags => tags).limit(count).where(:_id.ne => id)
  end

  def mark_by(user)
    unless marked_by? user
      collection.update({:_id => self.id},
                        {"$addToSet" => {:marker_ids => user.id}})
      marker_ids.push user.id
    end
 end

  def unmark_by(user)
    if marked_by? user
      collection.update({:_id => self.id},
                        {"$pull" => {:marker_ids => user.id}})
      marker_ids.delete user.id
    end
  end

  def marked_by?(user)
    marker_ids.include? user.id
  end

  def marker_count
    marker_ids.count
  end

  def reply_by(user)
    unless replied_by?(user) || self.user == user
      collection.update({:_id => self.id},
                        {"$addToSet" => {:replier_ids => user.id}})
    end
  end

  def replied_by?(user)
    replier_ids.include? user.id
  end

  def update_reply_stats_by(reply)
    self.actived_at = reply.created_at
    self.last_reply_user = reply.user
    save
  end

  def reset_reply_stats
    last_reply = replies.order([[:created_at, :asc]]).last
    if last_reply
      update_reply_stats_by(last_reply)
    else
      self.actived_at = created_at
      self.last_reply_user = nil
      save
    end
  end

  def last_read?(user)
    last_read_user_ids.include? user.id
  end

  def read_by(user)
    unless last_read?(user)
      add_to_set(:last_read_user_ids, user.id)
    end
  end
end
