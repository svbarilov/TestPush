require 'pry'
require_relative './rail_request.rb'
require_relative './observer.rb'

class CreateRun < RailRequest



  def params

    ################################
    @feature_name = Observer.features.first[:gherkin]["name"]
    @feature_description = Observer.features.first[:gherkin]["description"]
    ################################


    {
        "name" => "Automated: " + @feature_name + " | " + Time.now.strftime("%d/%m/%Y %H:%M"),
        "description" => @feature_description,
        "assign_to" => 1,
        "include_all" => false,
        "case_ids" => Observer.cases_ids,
        "suite_id" => @suite_id
    }
  end


  def perform
    run = @client.send_post("add_run/#{@project_id}", params)
    Observer.set_run_id= run["id"]
  end



end # end class
