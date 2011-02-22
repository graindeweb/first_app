module ApplicationHelper

  # Return a title on a per-page basis
  def title
    base_title = 'Première Application avec Ruby on Rails'
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag("logo.png", :alt => "Première application", :class => "round")
  end

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag (user.email.downcase,  :alt      => user.name,
                                              :class    => 'gravatar',
                                              :gravatar => options)
  end
end
