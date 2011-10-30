xml.instruct!
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @page_title
    xml.link @channel_link
    xml.description
    xml.lastBuildDate @topics.first.created_at.to_s(:rfc822) if @topics.any?

    @topics.each do |topic|
      xml.item do
        xml.title topic.title
        xml.description format_text(topic.content)
        xml.pubDate topic.created_at.to_s(:rfc822)
        xml.author topic.user.profile.name
        xml.link topic_url(topic, :page => topic.last_page, :anchor => topic.last_anchor)
        xml.guid topic_url(topic)
        if topic.tags.present?
          topic.tags.each do |tag|
            xml.category tag
          end
        end
      end
    end
  end
end
