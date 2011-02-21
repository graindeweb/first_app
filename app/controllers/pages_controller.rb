class PagesController < ApplicationController
  def home
    @title = "Accueil"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "A propos"
  end

  def help
     @title = "Aide"
    # totoot
  end

end
