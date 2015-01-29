class Observer


  @@created_sections_ids = []
  @@cases_ids = []


  def self.milestone
    "4.5"
  end

  def self.set_type=(type)
    @@type = type
  end


  def self.type
    @@type
  end


  def self.set_created_section_id= id
    @@created_sections_id = id
  end


  def self.created_section_id
    @@created_sections_id
  end


  def self.set_features=(features)
    @@features = features
  end


  def self.features
    @@features
  end


  def self.set_test_file=(test_file)
    @@test_file = test_file
  end


  def self.test_file
    @@test_file
  end


  def self.add_case_id(id)
    @@cases_ids << id
  end


  def self.cases_ids
    @@cases_ids
  end

  def self.set_run_id=(id)
    @@run_id = id
  end

  def self.run_id
    @@run_id
  end


end