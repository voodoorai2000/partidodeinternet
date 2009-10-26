
  class Webrat::SeleniumSession
    def wait_for_ajax
      selenium.wait_for_condition('!selenium.browserbot.getCurrentWindow().jQuery || selenium.browserbot.getCurrentWindow().jQuery.active == 0', 20000)
    end

    def wait_for_page_to_load(timeout = 20000)
      selenium.wait_for_page_to_load(timeout)
      wait_for_ajax
    end

    def request_path
      selenium.get_location.gsub("http://localhost:3001", "")
    end

    def selenium_window_eval(code)
      selenium.get_eval("selenium.browserbot.getCurrentWindow().#{code}")
    end
  end

  Webrat::Methods.delegate_to_session :request_path, :wait_for_ajax, :wait_for_page_to_load, :selenium_window_eval

  module Webrat

    def self.start_selenium_server 
      nil
    end

    def self.stop_selenium_server
      nil
    end

  end
