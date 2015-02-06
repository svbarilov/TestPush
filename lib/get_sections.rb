
class GetSections < RailRequest



  def set_suite_id(suite_id)
    @suite_id = suite_id
  end


  def perform
    get_sections = @client.send_get("get_sections/25&suite_id=#{@suite_id}")
    puts "Sections from suite ##{@suite_id}: \n#{get_sections.inspect}"
  end



end # end class