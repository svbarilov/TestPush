require_relative '../lib/test_push.rb'





b = TestPush.new('phone', '@acceptance')
b.run_tests
b.clean_parent_section
b.create_sections
b.add_tests_to_sections
b.create_run
puts ""