class SessionsController < ApplicationController
  before_filter :already_signed_in, :only => [:new, :create]

  def new
    redirect_to root_path if signed_in?
    @title = 'Connexion'
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if !user.nil?
      # Connexion de l'utilisateur
      sign_in user
      flash[:success] = "Vous êtes bien connecté"
      redirect_back_or(user)
    else
      # Erreur : on réaffiche le formulaire
      flash.now[:error] = "Utilisateur/Mot de passe incorrect(s)"
      @title = 'Connexion'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
