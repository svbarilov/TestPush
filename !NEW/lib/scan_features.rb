require "pry"
require "wally"
require "nokogiri"
require "restclient"
require "json"
require "wally/parses_features"
require_relative "./observer.rb"


class ScanFeatures


  @@features = []


  def initialize
    case Observer.type
      when 'phone'
        @features_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Phones_UI/features/regression_phone"
      when 'tablet'
        @features_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Tablets_UI/features/regression_tablet"
    end
    @feature_name_pattern = "**/#{Observer.test_file}.feature"
  end



  def perform
   Dir.glob(File.join(@features_path, @feature_name_pattern)).each do |feature_path|
     begin
       gherkin = Wally::ParsesFeatures.new.parse(File.read(feature_path))
     rescue
       puts "Couldn't parse '#{feature_path}'"
       puts "Contents:"
       puts File.read(@feature_path)
     end
    @@features << {:path => feature_path, :gherkin => gherkin}
   end
   return @@features
  end




end   # end class