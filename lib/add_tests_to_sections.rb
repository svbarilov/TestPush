
class AddTestsToSections < RailRequest



  def params
    {
        "title" => @scenario_name,
        "type_id" => 2,
        "priority_id" => 1,
        "estimate" => "3m",
        "milestone" => Observer.milestone,
        "custom_steps" => @scenario_steps,
        "custom_expected" => "See steps for Validation"
    }
  end


  def perform
    Observer.features.each_with_index do |feature, index|
      @created_section_id = Observer.created_sections_ids[index]
      @scenarios = feature[:gherkin]["elements"]
      if @scenarios
        @scenarios.each do |scenario|
          @scenario_name = scenario["name"]
          @scenario_steps_array = scenario['steps']
          @scenario_steps = ""
          @scenario_steps_array.each do |step|
            @scenario_steps << "#{step["keyword"]}#{step["name"]}\n"
          end
          test_case = @client.send_post("add_case/#{@created_section_id}", params)
          Observer.add_case_id (test_case["id"])
          puts "Test Cases Added to section ##{@created_section_id} in TestRail"
        end
      end
    end
  end # end perform



end # end class
