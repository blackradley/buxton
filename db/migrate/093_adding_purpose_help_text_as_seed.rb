class AddingPurposeHelpTextAsSeed < ActiveRecord::Migration
  def self.up
    wordings = {:gender => 'men and women',
      :race => 'individuals from different ethnic backgrounds',
      :disability => 'individuals with different kinds of disability',
      :faith => 'individuals of different faiths',
      :sexual_orientation => 'individuals of different sexual orientations',
      :age => 'individuals of different ages'}

    #purpose_strand_3 help text
    Activity.strands.each do |strand|
      add_seed :help_text, :question_name => "purpose_#{strand}_3" do
        add_value :existing_function => "This question asks you to identify any positive
             differential impact that the Function has on #{wordings[strand]}.<br/><br/> #{'It is important to have regards for all types of
             disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
             Please indicate whether the Function could affect #{wordings[strand]} differently if it were performed well."
        add_value :proposed_function => "This question asks you to identify any positive
             differential impact that the Function has on #{wordings[strand]}.<br/><br/>  #{'It is important to have regards for all types of
             disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
             Please indicate whether the Function could affect #{wordings[strand]} differently if it were performed well."
        add_value :existing_policy =>  "This question asks you to identify any positive
             differential impact that the Policy has on #{wordings[strand]}.<br/><br/>  #{'It is important to have regards for all types of
             disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
             Please indicate whether the Policy could affect #{wordings[strand]} differently if it were performed well."
        add_value :proposed_policy => "This question asks you to identify any positive
             differential impact that the Policy has on #{wordings[strand]}.<br/><br/> #{'It is important to have regards for all types of
             disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
             Please indicate whether the Policy could affect #{wordings[strand]} differently if it were performed well."
      end

      #purpose_strand_4 help text
      add_seed :help_text, :question_name => "purpose_#{strand}_4" do
        add_value :existing_function => "This question asks you to identify any negative
           differential impact that the Function has on #{wordings[strand]}.<br/><br/> #{'It is important to have regards for all types of
           disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
           Please indicate whether the Function could affect #{wordings[strand]} differently if it were performed badly."
        add_value :proposed_function => "This question asks you to identify any negative
           differential impact that the Function has on #{wordings[strand]}.<br/><br/> #{'It is important to have regards for all types of
           disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
           Please indicate whether the Function could affect #{wordings[strand]} differently if it were performed badly."
        add_value :existing_policy =>  "This question asks you to identify any negative
           differential impact that the Policy has on #{wordings[strand]}.<br/><br/> #{'It is important to have regards for all types of
           disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
           Please indicate whether the Policy could affect #{wordings[strand]} differently if it were performed badly."
        add_value :proposed_policy => "This question asks you to identify any negative
           differential impact that the Policy has on #{wordings[strand]}.<br/><br/> #{'It is important to have regards for all types of
           disability including physical, sensory, learning and mental health.  <br/><br/>' if strand == 'disability'}
           Please indicate whether the Policy could affect #{wordings[strand]} differently if it were performed badly."
      end
    end
  end

  def self.down
    Activity.strands.each do |strand|
      remove_seed :help_text, :question_name => "purpose_#{strand}_3"
      remove_seed :help_text, :question_name => "purpose_#{strand}_4"
    end
  end
end
