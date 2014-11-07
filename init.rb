require 'pry'
require 'wally'
require_relative 'parser.rb'
require_relative 'testrail.rb'
require 'nokogiri'

##################################################################################################################
#   Define Variables


# Expedia official project
client = TestRail::APIClient.new('https://testrail.sea.corp.expecn.com')
client.user = 'sbarylau'
client.password = 'Valerik26'
project_id = 25 # in official TestRailk
automated_section_id = 1943 # in official TestRail
suite_id = 1076 # in official TestRail


# Exepdia Test Project
#client = TestRail::APIClient.new('https://expediabookings.testrail.com')
#client.user = 'sbarylau@expedia.com'
#client.password = 'Valerik26'
#project_id = "1" # "25" in official TestRailk
#automated_section_id = 10  # 1943 in official TestRail
#suite_id = 1 # 1076 in official TestRail



##################################################################################################################
# delete all sections inside Automated section

all_sections = client.send_get("get_sections/#{project_id}&suite_id=#{suite_id}")
to_delete_ids = all_sections.select { |name| name["parent_id"] == automated_section_id }

puts ""

delete_section = []
to_delete_ids.each do |delete_id|
  delete_section << client.send_post("delete_section/#{delete_id['id']}", {"suite_id" => "#{suite_id}"})
end

puts "Automated section cleaned!!!"
##################################################################################################################
##################################################################################################################


$features.each do |feature|  # global features DO

    $cases_ids =  [] # stores IDs of added test cases
    test_results = [] # stores test results after run
    steps = ""
    scenarios =  feature[:gherkin]["elements"]
    feature_name = feature[:gherkin]["name"]
    feature_description = feature[:gherkin]["description"]
    feature_tags = feature[:gherkin]["tags"]
    scenarios_array =  feature[:gherkin]["elements"]


    section_params =  {
        "name" => feature_name,
        "description" => feature_description,
        "parent_id" => automated_section_id,
        "suite_id" => suite_id
    }

    puts "Variables initialized"

    ##################################################################################################################
    #   Create Section

    post_section = client.send_post("add_section/#{project_id}", section_params)
    puts "Section added: #{post_section}"
    section_id =  post_section["id"]

    puts "Test suite created in TestRail"
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
      $cases_ids << test_case["id"]
    end

    puts "Test Cases Added to TestRail"
    ##################################################################################################################
    #   Create Test Run based on earlier added test cases


    run_params =  {
        "name" => "Automated: " + feature_name + " | " + Time.now.strftime("%d/%m/%Y %H:%M"),
        "description" => feature_description,
        "assign_to" => 1,
        "include_all" => false,
        "case_ids" => $cases_ids,
        "suite_id" => suite_id
    }


    run = client.send_post("add_run/#{project_id}", run_params)
    run_id = run["id"]


    puts "TestRun created"
    ##################################################################################################################
    #   Run test suite
    puts "Running test suite"

    puts "\nTest Run is commented out!!!\n"
     #puts %x(cd ~/gitRepos/ExpediaBookingsUITests/Tablets_UI && bundle exec cucumber -p standard /Users/sbarylau/gitRepos/ExpediaBookingsUITests/Tablets_UI/features/in_development/test.feature)

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

      test_results << result
    end

    results_params =  { "results" => test_results }


    client.send_post("add_results_for_cases/#{run_id}", results_params)


    ##################################################################################################################
    puts " << SUCCESS: Test results pushed to TestRail!!! -;) >> "


end # global features END









