
class CreateRun < RailRequest



  def params

    tag = Observer.tag.reverse.chop.reverse

    {
        "name" => "Automated: " + tag.upcase + " | " + Time.now.strftime("%d/%m/%Y %H:%M"),
        "description" => tag.gsub("_", " ").capitalize + " run",
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
