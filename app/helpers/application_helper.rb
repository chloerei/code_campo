module ApplicationHelper
  def format_text(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       :autolink => true, :space_after_headers => true)
    sanitize markdown.render(text.to_s)
  end
end
