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
end
