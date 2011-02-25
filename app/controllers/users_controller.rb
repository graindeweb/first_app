class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = 'Liste des utilisateurs'
    @users = User.paginate(:page => params[:page])
  end

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

  def edit
    @title = "Modification du profil"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Votre profil a bien été mis à jour'
      redirect_to @user
    else
      @title = 'Modification du profil'
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "L'utilisateur #{user.name} a bien été supprimé"
    redirect_to users_path
  end

  private
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless (signed_in? && current_user.admin?)
    end
end
