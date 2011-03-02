class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :already_signed_in, :only => [:create, :new]

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
    @user       = User.find(params[:id])
    @title      = "Profil de #{@user.name}"
    @rss_url    = posts_user_url(@user, :rss)
    @microposts = @user.microposts.paginate(:page => params[:page])
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
    if (user != current_user)
      user.destroy
      flash[:success] = "L'utilisateur #{user.name} a bien été supprimé"
    else
      flash[:error]   = "Vous ne pouvez pas supprimer votre propre utilisateur"
    end
    redirect_to users_path
  end

  def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

  def show_follow(action)
    @title  = action.to_s.capitalize
    @user = User.find(params[:id])
    @users  = @user.send(action).paginate(:page => params[:page])
    render 'show_follow'
  end

  def posts
    @user = User.find(params[:id])
    respond_to do |format|
      format.html  { @microposts = @user.microposts.paginate(:page => params[:page]) }
      format.rss   { @microposts = @user.microposts(:limit => 100) }
    end
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
