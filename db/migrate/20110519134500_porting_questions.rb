class PortingQuestions < ActiveRecord::Migration
  
  def self.up
    Activity.first.instance_eval do 
      data = File.open(Rails.root + "config/questions.yml"){|yf| YAML::load( yf ) }
      dependents = {}
      Question.where(:name => ["purpose_overall_11", "purpose_overall_12"]).each(&:destroy)
      Activity.question_setup_names.each do |section, strand_list|
        strand_list.each do |strand, question_list|
          question_list.each do |question_number|
            question_data = strand.to_s == "overall" ? data["overall_questions"]['purpose'][question_number] : data["questions"][section.to_s][question_number]
            old_texts = {:label => question_data['label'].dup, :help_text => question_data["help"].dup}
            texts = {}
            old_texts.each do |key, value|
              #some questions have extra wordings on a per section and strand basis. The exceptions for this are codified here
              new_value = value.to_s
              new_value.gsub!('#{wordings[strand]}', data["wordings"][strand.to_s].to_s)
              new_value.gsub!('#{descriptive_term[strand]}', data["wordings"][strand.to_s].to_s)
              new_value.gsub!('#{"different " if strand == "gender"}', strand.to_s == "gender" ? 'different' : '')
              new_value.gsub!('#{sentence_desc(strand)}', sentence_desc(strand.to_s))
              if data["extra_strand_wordings"][section.to_s] && data["extra_strand_wordings"][section.to_s][question_number]
                new_value.gsub!("\#{data[\"extra_strand_wordings\"][\"#{section}\"][#{question_number}][strand]}", data["extra_strand_wordings"][section.to_s][question_number][strand.to_s].to_s)
                new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_word"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_word'][strand.to_s].to_s)
                new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_paragraph"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_paragraph'][strand.to_s].to_s)
              end
              begin
                raise section.to_s+strand.to_s+question_number.to_s+new_value.inspect if new_value.include?("\#{")
              end
              texts[key] = new_value
            end
            basic_attributes = { :help_text => texts[:help_text], :label => texts[:label]}
            basic_attributes[:choices] = data['choices'][question_data['choices']] if question_data['choices']
            questions = self.questions.find_all_by_name("#{section}_#{strand}_#{question_number}")
            questions.each do |q| 
              q.update_attributes(basic_attributes)
              q.save!
            end
          end
        end
      end
    end
    
  end

  def self.down
  end
end
