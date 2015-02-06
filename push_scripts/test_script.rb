require_relative '../lib/test_push.rb'





b = TestPush.new('phone', '@test_config')
b.clean_parent_section
b.create_sections
b.add_tests_to_sections
b.create_run
b.run_tests
b.parse_test_results
puts ""