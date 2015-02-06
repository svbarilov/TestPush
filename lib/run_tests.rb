
class RunTests < RailRequest




  def perform
    case Observer.type
      when 'phone'
        system "cd #{$project_path}/Phones_UI && TEST_PROFILE=#{Observer.tag.reverse.chop.reverse} ./go.sh"
      when 'tablet'
        system "cd #{$project_path}/Tablets_UI && TEST_PROFILE=#{Observer.tag.reverse.chop.reverse} ./go.sh"
    end
  end



end # end class