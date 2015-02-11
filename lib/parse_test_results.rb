
class ParseTestResults < RailRequest



  def perform
    find_junit_report_files
    scan_junit_files
    push_test_results
  end


  def find_junit_report_files
    @junit_folder_path = "#{$project_path}/Phones_UI/junit_format"
    @junit_folder_content = Dir.entries (@junit_folder_path)
    @junit_folder_content.delete_if { |i| i == "." || i == ".."}
  end


  def scan_junit_files
    @parse_result = []
    @junit_folder_content.each do |file|
      xml_path = @junit_folder_path + "/" + file
      doc = Nokogiri::XML( File.open(xml_path) )
      fails = doc.xpath("//testsuite/testcase").map { |node| node.xpath("failure") }
      fails.each { |r| r.empty? ? @parse_result << "1" : @parse_result << "5" }
    end
  end


  def push_test_results
    Observer.set_cases_with_results= (Hash[Observer.cases_ids.zip(@parse_result)]).to_a
    puts "Test Results for #{Observer.tag} run parsed"
  end



end # end class
