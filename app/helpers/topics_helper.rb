module TopicsHelper
  def subscribe_url
    case action_name
    when 'index', 'newest'
      newest_topics_url(:format => :rss)
    when 'interesting'
      interesting_topics_url(:format => :rss, :access_token => current_user.access_token)
    when 'tagged'
      tagged_topics_url(:format => :rss, :tag => params[:tag])
    end
  end
end
