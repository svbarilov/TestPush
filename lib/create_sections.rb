
class CreateSections < RailRequest


  def params
     {
        "name" => @feature_name,
        "description" => @feature_description,
        "parent_id" => @automation_section_id,
        "suite_id" =>  @suite_id
    }
  end


  def perform
    Observer.features.each do |feature|
      @feature_name = feature[:gherkin]["name"]
      @feature_description = feature[:gherkin]["description"]
      post_section = @client.send_post("add_section/#{@project_id}", params)
      puts "Section added: #{post_section}"
      @created_section_id =  post_section["id"]
      Observer.add_created_section_id @created_section_id
      puts "Test section ##{@created_section_id} created in TestRail"
    end
  end



end # end class


