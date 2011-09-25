class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :content
  field :tags,       :type => Array
  field :actived_at, :type => DateTime

  field :number_id,  :type => Integer
  index :number_id,  :unique => true
  scope :number, lambda{|id| where(:number_id => id)}

  belongs_to :user

  validates :title, :content, :user, :presence => true

  before_create :set_actived_at, :set_number_id

  def set_actived_at
    self.actived_at = Time.now
  end

  def set_number_id
    self.number_id = Mongoid.master.collection("counters").find_and_modify({
      :query  => {:_id   => self.class.name},
      :update => {'$inc' => {:next => 1}},
      :new    => true,
      :upsert => true
    })["next"]
  end

  def to_param
    self.number_id.to_s
  end

  def edited?
    updated_at > created_at
  end
end
