
class RunTests < RailRequest




  def perform (run_option = "")
    case Observer.type
      when 'phone'
        system "cd #{$project_path}/Phones_UI && #{run_option} TEST_PROFILE=#{Observer.tag.reverse.chop.reverse} ./go.sh"
      when 'tablet'
        system "cd #{$project_path}/Tablets_UI && #{run_option} TEST_PROFILE=#{Observer.tag.reverse.chop.reverse} ./go.sh"
    end
  end



end # end class