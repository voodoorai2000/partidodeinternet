class UserMailer < ActionMailer::Base
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Bienvenido a la tribu'
  
    @body[:url]  = "#{host}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{host}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "info@partidodeinternet.com"
      @subject     = ""
      @sent_on     = Time.now
      @body[:user] = user
    end
    
    def host
      "http://iweekend.raimondgarcia.com"
    end
end
