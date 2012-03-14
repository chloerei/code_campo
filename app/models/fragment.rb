class Fragment
  include Mongoid::Document

  FIELDS = %w(home_mainbar_bottom home_sidebar_bottom topics_sidebar_bottom footer)
  FIELDS.each do |name|
    field name
  end

  embedded_in :site
end
