class Demo
  
  def initialize(email)
    @email = email
    self.build
  end
  attr_accessor :email, :organisation, :passkey
  
  def build
    # Demo Council
    # 
    #    * Adult, Community and Housing Services
    #          o Libraries, Archives and Adult Learning
    #          o Housing Management
    #          o Strategic and Private Sector Housing
    #          o Building Services
    #          o Mental Health and Learning Disabilities
    #          o Older People and Adults with Physical Disabilities
    #          o Business Services
    # 
    #    * Children's Services
    #          o Resources
    #          o Policy, Performance and Information
    #          o Partnership and Children's Trust
    #          o Early Years, Youth and Education Services
    #          o Children's Specialist Services
    # 
    #    * Finance, ICT and Procurement
    #          o Benefits
    #          o Audit
    #          o Purchasing
    #          o ICT
    #          o Financial
    #          o Revenues
    # 
    #    * Law and Property
    #          o Property Consultancy
    #          o Corporate Estate Service
    #          o Legal and Democratic Services
    # 
    #    * Urban Environment
    #          o Development and Environmental Protection Division
    #          o Culture and Community Services
    #          o Environmental Management Division
    #          o Economic Regeneration Division
    
    # Create an organisation
    @organisation = Organisation.new({:name => 'Demo Council', :style => 'www'})
      
    # Create a new organisation manager with the e-mail address we were given
    @organisation_manager = @organisation.build_organisation_manager(:email => email)
    @organisation_manager.passkey = OrganisationManager.generate_passkey(@organisation_manager)
    @passkey = @organisation_manager.passkey

    # Give the organisation some strategies
    strategy_names = ['Manage resources effectively, flexibly and responsively',
      'Investing in our staff to build an organisation that is fit for its purpose',
      'Raising performance in our services for children, young people, families and adult',
      'Raising performance in our housing services',
      'Cleaner, greener and safer environment',
      'Investing in regeneration',
      'Improving our transport and tackling congestion',
      'Providing more effective education and leisure opportunities']
    strategy_names.each { |strategy_name|
      strategy = @organisation.organisation_strategies.build
      strategy.name = strategy_name
      strategy.description = strategy_name
    }
    
    dir1 = { :name => "Adult, Community and Housing Services",
             :activities => [ "Libraries, Archives and Adult Learning",
                              "Housing Management",
                              "Strategic and Private Sector Housing",
                              "Building Services",
                              "Mental Health and Learning Disabilities",
                              "Older People and Adults with Physical Disabilities",
                              "Business Services" ] }
    dir2 = { :name => "Children's Services",
             :activities => [ "Resources",
                              "Policy, Performance and Information",
                              "Partnership and Children's Trust",
                              "Early Years, Youth and Education Services",
                              "Children's Specialist Services" ] }
    dir3 = { :name => "Finance, ICT and Procurement",
             :activities => [ "Benefits",
                              "Audit",
                              "Purchasing",
                              "ICT",
                              "Financial",
                              "Revenues" ] }
    dir4 = { :name => "Law and Property",
             :activities => [ "Property Consultancy",
                              "Corporate Estate Service",
                              "Legal and Democratic Services" ] }
    dir5 = { :name => "Urban Environment",
             :activities => [ "Development and Environmental Protection Division",
                              "Culture and Community Services",
                              "Environmental Management Division",
                              "Economic Regeneration Division" ] }
    
                              
    directorates = [dir1,dir2,dir3,dir4,dir5]

    # Give the organisation five directorates
    directorates.each { |directorate_data|
      # Create a directorate
      directorate = @organisation.directorates.build(:name => directorate_data[:name])
      # directorate.organisation = @organisation #this should be filled in directly above, don't know why not

      activity_names = directorate_data[:activities]
      activity_names.each { |activity_name|
        # Create a activity
        activity = directorate.activities.build(:name => activity_name)
        # Create a activity manager
        activity_manager = activity.build_activity_manager(:email => email)
        activity_manager.passkey = ActivityManager.generate_passkey(activity_manager)
      }        
    }
  end
  
  def save!
    # Save the organisation, and its dependencies, with validations, surrounded by a transaction.
    Organisation.transaction do
      @organisation.save!
    end
  end
  
end
