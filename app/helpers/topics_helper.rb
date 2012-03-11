module TopicsHelper
  def subscribe_url
    case action_name
    when 'index', 'newest'
      newest_topics_url(:format => :rss)
    when 'tagged'
      tagged_topics_url(:format => :rss, :tag => params[:tag])
    end
  end
end
