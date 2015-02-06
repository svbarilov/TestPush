
class ScanFeatures


  @@features = []
  @@tag_features = []


  def initialize
    case Observer.type
      when 'phone'
        @features_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Phones_UI/features/regression_phone"
      when 'tablet'
        @features_path = "/Users/sbarylau/gitRepos/ExpediaBookingsUITests/Tablets_UI/features/regression_tablet"
    end
    @feature_name_pattern = "**/**.feature"
  end



  def perform
    Dir.glob(File.join(@features_path, @feature_name_pattern)).each do |feature_path|
      begin
        gherkin = Wally::ParsesFeatures.new.parse(File.read(feature_path))
        puts""
      rescue
        puts "Couldn't parse '#{feature_path}'"
        puts "Contents:"
        puts File.read(@feature_path)
      end
      @@features << {:path => feature_path, :gherkin => gherkin}
    end

    scan_by_tag
  end # end perform method



  def scan_by_tag
    @@features.each do |feature|

      @num = true

      if feature[:gherkin]["tags"]
        feature[:gherkin]["tags"].each do |tag|
          if tag["name"] == Observer.tag
            f = feature.clone
            @@tag_features << f
            @num = false
            puts ""
          end
        end
      end

      if feature[:gherkin]["elements"] && @num
        feature[:gherkin]["elements"].delete_if do |element|
          @tag = []
          if element["tags"]
            element["tags"].each do |tag|
              @tag << tag["name"]
            end
          end
          !@tag.include? Observer.tag
        end
      end

    end # end each feature

    @@features.delete_if do |feature|
      (feature[:gherkin]["elements"] == []) || (feature[:gherkin]["elements"].nil?)
    end

    @@features = @@features + @@tag_features
    @@features.uniq!

    Observer.set_features= @@features
    return @@features

  end # end scan by tag




end # end class