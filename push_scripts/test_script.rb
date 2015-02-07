require_relative '../lib/test_push.rb'





b = TestPush.new('phone', '@acceptance')
b.set_milestone= "4.5"
b.clean_parent_section
b.create_sections
b.add_tests_to_sections
b.create_run
b.run_tests ("MOCK=true")
b.parse_test_results
b.push_test_results
puts ""