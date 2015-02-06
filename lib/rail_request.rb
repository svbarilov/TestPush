
class RailRequest


  def initialize
    read_options_from_config
    set_test_rail_data
    create_test_rail_object
  end


  def read_options_from_config
    @password1 = "0Ze\xC9]W\x8D\xD6\xCF\x9A\xA0`\n#(I"
    @secret_key1 = "secret"
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
    @secret_key = @options['secret_key']
    @password = @options['password']
    @password = Encryptor.decrypt(:value => @password1, :key => @secret_key1).force_encoding('UTF-8').force_encoding('UTF-8')
  end


  def create_test_rail_object
    @client = ::TestRail::APIClient.new(@url)
    @client.user = @user
    @client.password = @password
  end


end