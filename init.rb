require 'pry'
require 'wally'
require_relative 'parser.rb'
require_relative 'testrail.rb'

##################################################################################################################
#   Define Variables

client = TestRail::APIClient.new('https://expediabookings.testrail.com')
client.user = 'sbarylau@expedia.com'
client.password = 'Valerik26'

project_id = "1"
parent_id = "10" # Automated section in TestRail

cases_ids =  [] # stores IDs of added test cases
test_results = [] # stores test results after run
##################################################################################################################
# feature = { :name => $features.first[:gherkin]["name"], :description => $features.first[:gherkin]["description"],
#   :tags => $features.first[:gherkin]["tags"], :scenarios =>  $features.first[:gherkin]["elements"] }

  steps = ""
  scenarios =  $features.first[:gherkin]["elements"]
  feature_name = $features.first[:gherkin]["name"]
  feature_description = $features.first[:gherkin]["description"]
  feature_tags = $features.first[:gherkin]["tags"]
  scenarios_array =  $features.first[:gherkin]["elements"]
  first_scenario = $features.first[:gherkin]["elements"][0]
  first_scenario_name = $features.first[:gherkin]["elements"][0]["name"]
  first_scenario_tags = $features.first[:gherkin]["elements"][0]["tags"]
  first_scenario_type = $features.first[:gherkin]["elements"][0]["type"]
  first_scenario_steps_array = $features.first[:gherkin]["elements"][0]["steps"]
  first_scenario_steps_array.each do |a|
    steps << "#{a["keyword"]}#{a["name"]}\n"
  end

  section_params =  {
    "name" => feature_name,
    "description" => feature_description,
    "parent_id" => parent_id
  }
  
##################################################################################################################
#   Create Section  
  
    post_section = client.send_post("add_section/#{project_id}", section_params) 
    section_id =  post_section["id"]

##################################################################################################################
# Add Test Cases to earlier created section

    scenarios_array.each do |scenario|
     scenario_name = scenario["name"]
     scenario_steps_array = scenario["steps"]
     scenario_steps = ""
     scenario_steps_array.each do |a|
       scenario_steps << "#{a["keyword"]}#{a["name"]}\n"
     end
     params =  {
       "title" => scenario_name,
       "type_id" => 2,
       "priority_id" => 5,
       "estimate" => "3m",
       "milestone" => "4.1",
       "custom_steps" => scenario_steps,
       "custom_expected" => "See steps for Validation"
     }
      test_case = client.send_post("add_case/#{section_id}", params)
      cases_ids << test_case["id"]
    end
  
  ##################################################################################################################
  #   Create Test Run based on earlier added test cases
  
  
    run_params =  {
      "name" => "Automated: " + feature_name + " | " + Time.now.strftime("%d/%m/%Y %H:%M"),
      "description" => feature_description,
      "assign_to" => 1, 
      "include_all" => false,
      "case_ids" => cases_ids
    }
  
  
  run = client.send_post("add_run/#{project_id}", run_params) 
  run_id = run["id"]
  
  ##################################################################################################################
  #   Parse test results
 
  case_result = "1" # set test case result
 
 
  ##################################################################################################################
  #   Push test results for test run to TestRail
  
  
  cases_ids.each do |case_id|
    result = { 
      "case_id" => case_id, 
      "status_id" => case_result, 
      "comment" => "Test Comment" 
    }
      
      #binding.pry
    test_results << result
  end  
  
  results_params =  { "results" => test_results }
  
  
  client.send_post("add_results_for_cases/#{run_id}", results_params) 
  


    
  
   
 
  
