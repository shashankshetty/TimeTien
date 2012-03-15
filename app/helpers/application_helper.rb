module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title || "Personal Time Management System" }
    content_tag :h2, page_title
  end

  def truncate(text)
    count = 25
    return text if (text.blank? || text.length < count)
    formatted_text = text[0, count] + " ..."
    return formatted_text
  end

  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=18"
  end
end
