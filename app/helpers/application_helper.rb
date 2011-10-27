module ApplicationHelper
  def format_text(text, options = {})
    sanitize markdown(link_mentions(text, options[:mention_names]))
  end

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       :autolink => true, :space_after_headers => true)
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
end
