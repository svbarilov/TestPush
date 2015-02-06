
class RunTests < RailRequest




  def perform
    system "cd ~/gitRepos/ExpediaBookingsUITests/Phones_UI && TEST_PROFILE=#{Observer.tag.reverse.chop.reverse} ./go.sh "
  end



end # end class