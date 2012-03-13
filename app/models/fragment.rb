class Fragment
  include Mongoid::Document

  field :home_sidebar_bottom
  field :topics_sidebar_bottom
  field :footer

  embedded_in :site
end
