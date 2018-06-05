module UsersHelper
  def gravatar_for user
    gravatar_url = "ki.png"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
