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

  it "should have the right links on the layout" do
    visit root_path
    click_link "Enregistrez-vous dès maintenant !"
    response.should have_selector('title', :content => "Enregistrement")
    click_link "A propos"
    response.should have_selector('title', :content => "A propos")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Aide"
    response.should have_selector('title', :content => "Aide")
    click_link "Connexion"
    response.should have_selector('title', :content => "Connexion")

  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a",  :href => signin_path,
                                          :content => 'Connexion')
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email,   :with => @user.email
      fill_in 'session_password',:with => @user.password
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector('a',  :href => signout_path,
                                          :content => 'Déconnexion')
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector('a',  :href => user_path(@user),
                                          :content => 'Profil')
    end
  end
end
