
class PushTestResults < RailRequest



  def save_result
    {
        "case_id" => @case_result[0],
        "status_id" =>  @case_result[1],
        "comment" => "Test Comment"
    }
  end


  def perform
    puts "Pushing Test Results to TestRail"
    @test_results = []

    Observer.cases_with_results.each do |case_result|
      @case_result = case_result
      @test_results << save_result.clone
    end

    results_params =  { "results" => @test_results }
    @client.send_post("add_results_for_cases/#{Observer.run_id}", results_params)

    puts " << SUCCESS: Test results for #{Observer.tag} run pushed to TestRail!!! -;) >> "
  end



end # end class
