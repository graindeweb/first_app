require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Accueil")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => " A propos")
  end

  it "should have a help page at '/help'" do
    get '/help'
    response.status.should be(200)
    response.should have_selector('title', :content => "Aide")
  end

  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Enregistrement")
  end
end
