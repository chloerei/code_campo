module ApplicationHelper
  def format_text(text, options = {})
    sanitize markdown(link_mentions(text, options[:mention_names]))
  end

  def markdown(text)
    markdown_render = Redcarpet::Render::HTML.new :hard_wrap => true, :no_styles => true
    markdown = Redcarpet::Markdown.new(markdown_render,
                                       :autolink => true,
                                       :no_intra_emphasis => true)
    markdown.render(text.to_s)
  end

  def link_mentions(text, mention_names)
    if mention_names && mention_names.any?
      text.gsub(/@(#{mention_names.join('|')})(?![.\w])/) do
        username = $1
        %Q[@<a href="/~#{username}">#{username}</a>]
      end
    else
      text
    end
  end

  def link_to_person(user)
    link_to user.name, person_path(:name => user)
  end

  def link_avatar_to_person(user, options = {})
    options[:size] ||= 48
    link_to image_tag(user.gravatar_url(:size => options[:size])), person_path(:name => user)
  end

  def format_time(time)
    t 'time_ago', :duration => time_ago_in_words(time)
  end
end
