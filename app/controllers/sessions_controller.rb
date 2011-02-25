class SessionsController < ApplicationController
  def new
    @title = 'Connexion'
  end

  def create
    user = User.authenticate(params[:session][:email],
                              params[:session][:password])
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
