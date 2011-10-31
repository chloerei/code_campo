# config/mongoid.yml
#
# development:
#   host: localhost
#   database: code_campo
#   identity_map_enabled: true
#   databases:
#     campo:
#       database: campo
#       host: localhost

require File.expand_path('../../config/environment',  __FILE__)

module Campo
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    set_database :campo
    self.collection_name = 'users'

    field :username
    field :email
    field :locale
    field :favorite_tags, :type => Array
    field :banned, :type => Boolean
    field :crypted_password
    field :password_salt
    field :access_token
  end

  class Reply
    include Mongoid::Document
    include Mongoid::Timestamps
    set_database :campo
    self.collection_name = 'replies'

    field :content
    belongs_to :topic, :class_name => 'Campo::Topic'
    belongs_to :user, :class_name => 'Campo::User'

    has_and_belongs_to_many :mention_users, :class_name => 'Campo::User'
  end

  class Topic
    include Mongoid::Document
    include Mongoid::Timestamps
    set_database :campo
    self.collection_name = 'topics'

    field :title
    field :content
    field :tags, :type => Array
    field :marker_ids, :type => Array
    field :replier_ids, :type => Array
    field :actived_at, :type => Time
    field :replies_count, :type => Integer
    field :edited_at, :type => Time
    belongs_to :user, :class_name => 'Campo::User'
  end
end

Mongoid.database.collections.each do |coll|
  coll.remove if coll.name !~ /system/
end

puts Campo::User.count
Campo::User.order_by([[:created_at, :asc]]).where(:banned.ne => true).each do |old_user|
  begin
    user = User.new :name => old_user.username,
                    :email => old_user.email,
                    :locale => old_user.locale,
                    :favorite_tags => old_user.favorite_tags
    user.id = old_user.id
    user.created_at = old_user.created_at
    user.crypted_password = old_user.crypted_password
    user.password_salt = old_user.password_salt
    user.access_token = old_user.access_token
    user.save!(:validate => false)
  rescue => e
    puts e
  end
end
puts User.count

puts Campo::Topic.count
Campo::Topic.order_by([[:created_at, :asc]]).all.each do |old_topic|
  begin
    topic = Topic.new :title => old_topic.title,
                      :content => old_topic.content,
                      :tags => old_topic.tags
                      
    topic.id = old_topic.id
    topic.marker_ids = old_topic.marker_ids.to_a
    topic.user = User.find(old_topic.user_id)
    topic.created_at = old_topic.created_at
    topic.actived_at = old_topic.actived_at
    topic.save!
  rescue => e
    puts e
  end
end
puts Topic.count

puts Campo::Reply.count
Campo::Reply.order_by([[:created_at, :asc]]).all.each do |old_reply|
  begin
    reply = Reply.new :content => old_reply.content
    reply.mentioned_user_ids = old_reply.mention_user_ids.to_a
    reply.id = old_reply.id
    reply.user = User.find(old_reply.user_id)
    reply.topic = Topic.find(old_reply.topic_id)
    reply.created_at = old_reply.created_at
    reply.updated_at = old_reply.updated_at
    reply.save!
  rescue => e
    puts e
  end
end
puts Reply.count

Campo::Topic.order_by([[:created_at, :asc]]).all.each do |old_topic|
  Topic.find(old_topic.id).update_attribute :actived_at, old_topic.actived_at
end
