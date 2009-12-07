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
    
    #tmp until we install ar_mailer in the continous integration server
    def perform_delivery_activerecord(mail)
      email_class = ActionMailer::ARMailer.email_class

      mail.destinations.each do |destination|
        email_class.create :mail => mail.encoded, :to => destination,
                           :from => mail.from.first
      end
    end
end
