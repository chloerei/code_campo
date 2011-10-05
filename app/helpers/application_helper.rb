module ApplicationHelper
  def format_text(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       :autolink => true, :space_after_headers => true)
    sanitize markdown.render(text.to_s)
  end

  def link_to_person(user)
    link_to user.name, person_path(:name => user)
  end

  def link_avatar_to_person(user, options = {})
    options[:size] ||= 48
    link_to image_tag(user.gravatar_url(:size => options[:size])), person_path(:name => user)
  end
end
