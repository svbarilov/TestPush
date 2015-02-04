require 'pry'
require_relative './rail_request.rb'
require_relative './observer.rb'


class CleanParentSection < RailRequest



  def perform
    all_sections = @client.send_get("get_sections/#{@project_id}&suite_id=#{@suite_id}")
    sections_to_delete = all_sections.select { |name| name["parent_id"] == @automation_section_id }
    sections_to_delete.each do |to_delete|
      @client.send_post("delete_section/#{to_delete['id']}", {"suite_id" => "#{@suite_id}"})
      puts "\"#{to_delete['name']}\" section with id-> #{to_delete['id']} was deleted"
    end
    puts "Automated section id# #{@automation_section_id} cleaned!!!"
  end



end # end class


#a = CleanSection.new.perform