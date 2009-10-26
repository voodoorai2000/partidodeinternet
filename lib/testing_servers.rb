
  def with_servers
    xserver_pid = run_command("startx -- `which Xvfb` :1 -screen 0 1024x768x24")
    selenium_pid = run_command("sh -c 'DISPLAY=:1 selenium -browserSessionReuse'")
    yield
  ensure 
    system("killall xterm")
    require 'selenium'
    Selenium::SeleniumServer.new.stop
  end
  
  def run_command(cmd)
    fork do
      [STDOUT,STDERR].each {|f| f.reopen '/dev/null', 'w' }
      exec cmd
    end
  end
