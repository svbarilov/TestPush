require 'pry'
require 'wally'
require 'yaml'
require_relative '../project_path.rb'
require_relative './testrail.rb'
require_relative './scan_features.rb'
require_relative './get_sections.rb'
require_relative './add_section.rb'
require_relative './add_tests_to_section.rb'
require_relative './create_run.rb'
# require_relative './Bucket.rb'


class TestPush


  def initialize type, test_file=nil
    Observer.set_type= type
    Observer.set_test_file= test_file
    @features = ScanFeatures.new.perform
    Observer.set_features= @features
  end


  def get_sections(suite_id=nil)
    section = GetSections.new
    section.set_suite_id(suite_id) unless suite_id.nil?
    section.perform
  end


  def add_section
    section = AddSection.new.perform
  end


  def add_tests_to_section
    section = AddTestsToSection.new.perform
  end

  def create_run
    section = CreateRun.new.perform
  end



end # end class BaseRail


# a = TestPush.new('tablet')
# a.get_sections



b = TestPush.new('phone', 'p_flights_checkout')
#b.clean_section
b.add_section
b.add_tests_to_section
b.create_run





