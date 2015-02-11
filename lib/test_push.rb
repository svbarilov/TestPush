#encoding utf-8

require 'pry'
require 'wally'
require 'yaml'
require 'nokogiri'
require 'require_all'
require 'encryptor'
require 'require_all'
require_relative '../../project_path.rb'
require_relative './rail_request.rb'
require_relative './run_tests.rb'
require_relative './testrail.rb'
require_relative './observer.rb'
require_relative './scan_features.rb'
require_relative './get_sections.rb'
require_relative './create_sections.rb'
require_relative './add_tests_to_sections.rb'
require_relative './create_run.rb'
require_relative './clean_parent_section.rb'
require_relative './parse_test_results.rb'
require_relative './push_test_results.rb'

class TestPush



  def initialize type, tag=nil
    Observer.set_type= type
    Observer.set_tag= tag
    ScanFeatures.new.perform
  end


  def set_milestone=(milestone)
    Observer.set_milestone= milestone
  end


  def milestone
    Observer.milestone
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


  def run_tests (run_option = "")
    RunTests.new.perform run_option
  end


  def parse_test_results
    ParseTestResults.new.perform
  end


  def push_test_results
    PushTestResults.new.perform
  end




end # end class BaseRail








