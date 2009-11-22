class UserMailer < ActionMailer::Base
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Bienvenido al Partido de Internet'
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Tu cuenta está activada'
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "info@partidodeinternet.com"
      @subject     = ""
      @sent_on     = Time.now
      @body[:user] = user
    end
end
