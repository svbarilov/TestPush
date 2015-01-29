require 'pry'
require_relative './rail_request.rb'
require_relative './observer.rb'

class AddTestsToSection < RailRequest



  def params
  {
          "title" => @scenario_name,
          "type_id" => 2,
          "priority_id" => 5,
          "estimate" => "3m",
          "milestone" => Observer.milestone,
          "custom_steps" => @scenario_steps,
          "custom_expected" => "See steps for Validation"
      }
  end


  def perform
    ############################################
    @scenario = Observer.features.first[:gherkin]["elements"]
    @scenario_name = Observer.features.first[:gherkin]["name"]
    @scenario_steps_array = @scenario.first['steps']
    ############################################
    @created_section_id = Observer.created_section_id
    @scenario_steps = ""
      @scenario_steps_array.each do |step|
        @scenario_steps << "#{step["keyword"]}#{step["name"]}\n"
      end
      test_case = @client.send_post("add_case/#{@created_section_id}", params)
      Observer.add_case_id (test_case["id"])
      puts "Test Cases Added to section ##{@created_section_id} in TestRail"
    end



end # end class
