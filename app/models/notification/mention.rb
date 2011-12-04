class Notification::Mention < Notification::Base
  belongs_to :mentionable, :polymorphic => true

  validates :mentionable, :presence => true
end
