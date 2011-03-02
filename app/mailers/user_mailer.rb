class UserMailer < ActionMailer::Base
  helper :application
  default :from => "bpfefferkorn@linksip.fr"
  default_url_options[:host] = "localhost:3000"

  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => '[FirstApplication] Confirmation d\'enregistrement sur FirstApplication')
  end

  def new_follower_notification(user, follower)
    @user     = user
    @follower = follower
    mail(:to => user.email,
         :subject => '[FirstApplication] Un nouveau follower sur FirstApplication !!') do |format|
        format.text
        format.html
    end
  end
end
