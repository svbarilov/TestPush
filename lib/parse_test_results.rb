
class ParseTestResults < RailRequest



  def perform
    xml_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Phones_UI/junit_format/TEST-features-regression_phone-flights_features-p_flights_search.xml"


    doc = Nokogiri::XML( File.open(xml_path) )
    fails = doc.xpath("//testsuite/testcase").map { |node| node.xpath("failure") }
    parse_result = []
    fails.each { |r| r.empty? ? parse_result << "5" : parse_result << "1" }


    cases_with_results = (Hash[$cases_ids.zip(parse_result)]).to_a

    puts "Test Results parsed"
  end



end # end class
