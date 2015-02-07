
class ParseTestResults < RailRequest



  def perform
    junit_folder_path = "#{$project_path}/Phones_UI/junit_format"
    junit_folder_content = Dir.entries (junit_folder_path)
    junit_folder_content.delete_if { |i| i == "." || i == ".."}



    junit_folder_file = junit_folder_content.first
    xml_path = junit_folder_path + "/" + junit_folder_file

    doc = Nokogiri::XML( File.open(xml_path) )
    fails = doc.xpath("//testsuite/testcase").map { |node| node.xpath("failure") }
    parse_result = []
    fails.each { |r| r.empty? ? parse_result << "1" : parse_result << "5" }


    Observer.set_cases_with_results= (Hash[Observer.cases_ids.zip(parse_result)]).to_a

    puts "Test Results for #{Observer.tag} run parsed"
  end



end # end class
