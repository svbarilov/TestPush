require 'pry'
require 'wally'
require 'yaml'
require_relative '../project_path.rb'
require_relative './testrail.rb'
require_relative './scan_features.rb'
require_relative './get_sections.rb'
require_relative './create_sections.rb'
require_relative './add_tests_to_sections.rb'
require_relative './create_run.rb'
require_relative './clean_parent_section.rb'


class TestPush



  def initialize type, tag=nil
    Observer.set_type= type
    Observer.set_tag= tag
    ScanFeatures.new.perform
  end


  def get_sections(suite_id=nil)
    section = GetSections.new
    section.set_suite_id(suite_id) unless suite_id.nil?
    section.perform
  end


  def create_sections
    CreateSections.new.perform
  end


  def add_tests_to_sections
    AddTestsToSections.new.perform
  end


  def create_run
    CreateRun.new.perform
  end


  def clean_parent_section
    CleanParentSection.new.perform
  end



end # end class BaseRail


# a = TestPush.new('tablet')
# a.get_sections



b = TestPush.new('phone', '@regression')
b.clean_parent_section
b.create_sections
b.add_tests_to_sections
b.create_sections
b.add_tests_to_sections
# b.add_section
# b.add_tests_to_section
# b.create_run





