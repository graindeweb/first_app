class UsersController < ApplicationController
  def new
    @title = "Enregistrement"
  end

  def show
    @user = User.find(params[:id])
    @title = "Profil de #{@user.name}"
  end
end
