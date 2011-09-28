class Reply
  include Mongoid::Document
  include Mongoid::NumberId

  field :content

  belongs_to :user
  belongs_to :topic

end
