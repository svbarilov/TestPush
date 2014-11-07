require 'pry'
require 'wally'
require_relative 'parser.rb'
require_relative 'testrail.rb'
require 'nokogiri'

##################################################################################################################
#   Define Variables

client = TestRail::APIClient.new('https://expediabookings.testrail.com')
client.user = 'sbarylau@expedia.com'
client.password = 'Valerik26'

project_id = "1"
parent_id = "10" # Automated section in TestRail

$cases_ids =  [] # stores IDs of added test cases
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
  # first_scenario = $features.first[:gherkin]["elements"][0]
  # first_scenario_name = $features.first[:gherkin]["elements"][0]["name"]
  # first_scenario_tags = $features.first[:gherkin]["elements"][0]["tags"]
  # first_scenario_type = $features.first[:gherkin]["elements"][0]["type"]
  # first_scenario_steps_array = $features.first[:gherkin]["elements"][0]["steps"]
  # first_scenario_steps_array.each do |a|
  #   steps << "#{a["keyword"]}#{a["name"]}\n"
  # end

  section_params =  {
    "name" => feature_name,
    "description" => feature_description,
    "parent_id" => parent_id
  }

  puts "Variables initialized"
##################################################################################################################
#   Create Section

    post_section = client.send_post("add_section/#{project_id}", section_params)
    section_id =  post_section["id"]

    puts "Test suite created in TestRail"
##################################################################################################################
# Add Test Cases to earlier created section

    scenarios_array.each do |scenario|
     scenario_tags = scenario["tags"]
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
      #$cases_ids << "#{scenario_name}: " +  "case id-" + "#{test_case['id']}; " + "tags-" + "#{scenario_tags}"
      $cases_ids << test_case["id"]
    end


puts $cases_ids.inspect
puts ""


    puts "Test Cases Added to TestRail"
  ##################################################################################################################
  #   Create Test Run based on earlier added test cases


    run_params =  {
      "name" => "Automated: " + feature_name + " | " + Time.now.strftime("%d/%m/%Y %H:%M"),
      "description" => feature_description,
      "assign_to" => 1,
      "include_all" => false,
      "case_ids" => $cases_ids
    }


  run = client.send_post("add_run/#{project_id}", run_params)
  run_id = run["id"]


  puts "TestRun created"
  ##################################################################################################################
  #   Run test suite
  puts "Running test suite"

  puts %x(cd ~/gitRepos/ExpediaBookingsUITests/Tablets_UI && cucumber -p standard /Users/sbarylau/gitRepos/ExpediaBookingsUITests/Tablets_UI/features/in_development/test.feature)

  puts "Test run finished"
  ##################################################################################################################
  #   Parse test results
  puts "Parsing Test results"
 
  xml_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Tablets_UI/junit_format/TEST--Users-sbarylau-gitRepos-ExpediaBookingsUITests-Tablets_UI-features-in_development-test.xml"
  
  
  doc = Nokogiri::XML( File.open(xml_path) )
  fails = doc.xpath("//testsuite/testcase").map { |node| node.xpath("failure") }
  parse_result = []
  fails.each { |r| r.empty? ? parse_result << "5" : parse_result << "1" }
 
 
  cases_with_results = (Hash[$cases_ids.zip(parse_result)]).to_a
 
  puts "Test Results parsed"
  ##################################################################################################################
  #   Push test results for test run to TestRail
  puts "Pushing Test Results"
  
  
  cases_with_results.each do |case_result|
    result = { 
      "case_id" => case_result[0], 
      "status_id" =>  case_result[1], 
      "comment" => "Test Comment" 
    }
      
      #binding.pry
    test_results << result
  end  
  
  results_params =  { "results" => test_results }
  

  client.send_post("add_results_for_cases/#{run_id}", results_params) 
  
  
   ##################################################################################################################
  puts " << SUCCESS: Test results pushed to TestRail!!! -;) >> "
 
    
  
   
 
  
