# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def is_authorized?(user)
    current_user and
    (current_user == user or 
    current_user.is_admin?)
  end
end
