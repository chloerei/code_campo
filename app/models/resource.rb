class Resource
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::NumberId
  include Mongo::Voteable

  voteable self, :up => 1, :index => true

  field :title
  field :url
  field :tags, :type => Array, :default => []
  field :comments_count, :default => 0

  belongs_to :user
  has_many :comments, :dependent => :delete

  attr_accessible :title, :url, :tag_string

  validates :title, :url, :presence => true
  validates :tag_string, :tag_string => true, :format => { :with => /\A[^\/]+\z/, :message => I18n.t("errors.no_allow_slash"), :allow_blank => true}
  validates :url, :format => {:with => URI::Parser.new.regexp[:ABS_URI]}

  def tag_string=(string)
    self.tags = string.to_s.downcase.split(/[,\s]+/).uniq
  end

  def tag_string
    self.tags.join(', ')
  end

  def host
    URI.parse(url).try(:host)
  end

  def relate_resources(count)
    Resource.any_in(:tags => tags).limit(count).where(:_id.ne => id)
  end

  def anchor
    "resource-#{number_id}"
  end
end
