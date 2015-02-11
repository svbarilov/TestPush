require_relative $project_path + "/TestPush/password.rb"
class RailRequest


  def initialize
    read_options_from_config
    set_test_rail_data
    create_test_rail_object
  end


  def read_options_from_config
    global_params = YAML.load_file("#{$project_path}/TestPush/config/config.yml")
    @global_config_params = global_params['global_config_params']
    @options = @global_config_params

    @automation_section_params = global_params['automation_section_params'][Observer.type]
    @project_id = @automation_section_params['project_id']
    @suite_id = @automation_section_params['suite_id']
    @automation_section_id = @automation_section_params['automation_section_id']
  end


  def set_test_rail_data
    if !@options['base_url'].match(/\/$/)
      @options['base_url'] += '/'
    end
    @url = @options['base_url']
    @user = @options['user']
    @password = Encryptor.decrypt(:value => @@password, :key => @@secret_key).force_encoding('UTF-8').force_encoding('UTF-8')
  end


  def create_test_rail_object
    @client = ::TestRail::APIClient.new(@url)
    @client.user = @user
    @client.password = @password
  end


end