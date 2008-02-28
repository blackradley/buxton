class Demo
  
  def initialize(admin_email)
    @admin_email = admin_email
    self.build
  end
  attr_accessor :admin_email, :organisation
  
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
  end
  
  def save
    # Save the organisation, and its dependencies, with validations,
    # surrounded by a transaction.
    Organisation.transaction do
      @organisation.save!
    end
  end
  
end