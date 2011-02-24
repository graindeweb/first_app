class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Enregistrement"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # redirection vers l'action show
      sign_in(@user)
      flash[:success] = "Bienvenue sur la première application"
      redirect_to @user
    else
      @title = "Enregistrement"
      @user.password = @user.password_confirmation = nil
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @title = "Profil de #{@user.name}"
  end
end
