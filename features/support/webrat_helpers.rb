
module Webrat
  class RailsSession < Session
     def request_path
       integration_session.request.path
     end
     
     def wait_for_ajax; end

     def wait_for_page_to_load(timeout = 20000); end
     
     def method_missing(m, *args)  
       if m == :selenium
         raise "Hey, looks like you are trying to run a selenium scenario with the non-selenium configuration\
                please add '@selenium' to the line before this scenario"
       else
         super
       end
     end
     
  end
  
end

Webrat::Methods.delegate_to_session :request_path, :wait_for_ajax, :wait_for_page_to_load
