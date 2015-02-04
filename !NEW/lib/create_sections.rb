require 'pry'
require_relative './rail_request.rb'
require_relative './observer.rb'


class CreateSections < RailRequest


  def params
    ################################
        @feature_name = Observer.features.first[:gherkin]["name"]
        @feature_description = Observer.features.first[:gherkin]["description"]
    ################################

     {
        "name" => @feature_name,
        "description" => @feature_description,
        "parent_id" => @automation_section_id,
        "suite_id" =>  @suite_id
    }
  end


  def perform
    post_section = @client.send_post("add_section/#{@project_id}", params)
    puts "Section added: #{post_section}"
    @created_section_id =  post_section["id"]
    Observer.set_created_section_id= @created_section_id
    puts "Test section ##{@created_section_id} created in TestRail"
  end



end # end class


#a = AddSection.new.perform

