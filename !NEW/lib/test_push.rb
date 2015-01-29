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
require_relative './clean_section.rb'


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
    AddSection.new.perform
  end


  def add_tests_to_section
    AddTestsToSection.new.perform
  end

  def create_run
    CreateRun.new.perform
  end

  def clean_section
    CleanSection.new.perform
  end


end # end class BaseRail


# a = TestPush.new('tablet')
# a.get_sections



b = TestPush.new('phone', 'p_flights_checkout')
b.get_sections
puts ""
b.add_section
b.add_tests_to_section
b.add_section
b.add_tests_to_section
b.clean_section
# b.add_section
# b.add_tests_to_section
# b.create_run





