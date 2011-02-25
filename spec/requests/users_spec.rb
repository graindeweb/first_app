require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ''
          fill_in "Email",        :with => ''
          fill_in "Password",     :with => ''
          fill_in "Confirmation", :with => ''
          click_button
          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
      end
    end

    describe "sign in/out" do
      describe "failure" do
        it "should not sign a user in" do
          user = User.new(:email => '', :password => '')
          integration_sign_in(user)
          response.should have_selector("div.flash.error", :content => "incorrect")
        end
      end

      describe "success" do
        it "should sign a user in and out" do
          integration_sign_in(Factory(:user))
          controller.should be_signed_in
          click_link "Déconnexion"
          controller.should_not be_signed_in
        end
      end
    end

    describe "success" do
      it "should create a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "toto"
          fill_in "Email",        :with => "toto" + Time.now.to_i.to_s + "@toto.fr"
          fill_in "Password",     :with => "tototi"
          fill_in "Confirmation", :with => "tototi"
          click_button
          response.should have_selector('div.flash.success', :content => "Bienvenue")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
end
