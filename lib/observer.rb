class Observer


  @@created_sections_ids = []
  @@cases_ids = []



  def self.set_milestone=(milestone)
    @@milestone = milestone
  end


  def self.milestone
    @@milestone
  end

  def self.set_type=(type)
    @@type = type
  end


  def self.type
    @@type
  end


  def self.add_created_section_id id
    @@created_sections_ids << id
  end


  def self.created_sections_ids
    @@created_sections_ids
  end


  def self.set_features=(features)
    @@features = features
  end


  def self.features
    @@features
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

  def self.set_tag=(tag)
    @@tag = tag
  end


  def self.tag
    @@tag
  end


  def self.set_cases_with_results=(cases_with_results)
    @@cases_with_results = cases_with_results
  end


  def self.cases_with_results
    @@cases_with_results
  end



end # end class