require 'pry'
require 'wally'
require_relative 'parser.rb'
require_relative 'testrail.rb'


class TestPush < TestRail::APIClient
  
 
  
  def initialize(base_url, user, password)
    @project_id = "1"
    self.user = user
    self.password = password 
    if !base_url.match(/\/$/)
      base_url += '/'
    end
    @url = base_url + 'index.php?/api/v2/'
  end
  
    
    
  def add_section
    section_params =  {
      "name" => "test_name",
      "description" => "test_description",
      "parent_id" => "10"
    }
    
    post_section = self.send_post("add_section/#{@project_id}", section_params)
    section_id =  post_section["id"]
  end  

end    
    
    
  TestPush.new('https://expediabookings.testrail.com', 'sbarylau@expedia.com', 'Valerik26').add_section
  
  