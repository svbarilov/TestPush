require 'pry'
require_relative './test_push.rb'


class CleanSection < Base



  def perform
    all_sections = @client.send_get("get_sections/#{@project_id}&suite_id=#{@suite_id}")
    sections_to_delete = all_sections.select { |name| name["parent_id"] == @automated_section_id }
    @delete_section = []
    sections_to_delete.each do |to_delete|
      @delete_section << @client.send_post("delete_section/#{to_delete['id']}", {"suite_id" => "#{@suite_id}"})
      puts "#{to_delete['name']} section with id-> #{to_delete['id']} was deleted"
    end
    puts "Automated section cleaned!!!"
  end



end # end class


#a = CleanSection.new.perform