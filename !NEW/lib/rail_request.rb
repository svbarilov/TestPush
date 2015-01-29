require_relative './observer.rb'
require_relative './rail_request.rb'

class RailRequest


  def initialize
    global_params = YAML.load_file("#{$project_path}/config/config.yml")
    @global_config_params = global_params['global_config_params']
    @options = @global_config_params
    if !@options['base_url'].match(/\/$/)
      @options['base_url'] += '/'
    end
    @url = @options['base_url']
    @user = @options['user']
    @password = @options['password']

    @client = ::TestRail::APIClient.new(@url)
    @client.user = @user
    @client.password = @password

    @automation_section_params = global_params['automation_section_params'][Observer.type]
    @project_id = @automation_section_params['project_id']
    @suite_id = @automation_section_params['suite_id']
    @automation_section_id = @automation_section_params['automation_section_id']

  end


end