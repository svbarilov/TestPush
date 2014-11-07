#require 'pry'
require "restclient"
require "json"
require "wally/parses_features"

##################################################################################################################


features_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Tablets_UI/features/regression_tablet/hotels_features"
feature_name_pattern = "hotels_search.feature"

# features_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Tablets_UI/features/in-development"
# feature_name_pattern = "test.feature"


##################################################################################################################

  $features = []
  Dir.glob(File.join(features_path, feature_name_pattern)).each do |feature_path|
    begin
      gherkin = Wally::ParsesFeatures.new.parse(File.read(feature_path))
    rescue
      puts "Couldn't parse '#{feature_path}'"
      puts "Contents:"
      puts File.read(feature_path)
    end
    $features << {:path => feature_path, :gherkin => gherkin}
  end
  
##################################################################################################################


 
  


