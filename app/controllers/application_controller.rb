class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  private
    def already_signed_in
      redirect_to(root_path, :notice => "Vous êtes déjà connecté") if signed_in?
    end
end
