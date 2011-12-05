class Notification::CommentComment < Notification::Base
  belongs_to :comment

  validates :comment, :presence => true
end
