#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
class CreateUserWithTypes < ActiveRecord::Migration
#
# Create a view so we can see what types of users we have.  Rather
# than putting a user type in the users table this is done using 
# joins with the organisations and functions tables.  There must be
# a way that this can be done natively with ActiveRecord but I 
# can't see a way right now. 
#
  def self.up
    create_view :user_with_types, "SELECT users.*, " + 
	    "CASE " +  
	    "  WHEN functions.id <> '' THEN 'Operational' " +  
	    "  WHEN organisations.id <> '' THEN 'Organisational' " +  
 	    "  ELSE 'Administrative' " + 
	    "END AS user_type " + 
	    "FROM organisations RIGHT OUTER JOIN functions RIGHT OUTER JOIN users " + 
        "ON functions.user_id = users.id ON users.id = organisations.user_id " do |t|
      t.column :id
      t.column :passkey
      t.column :email
      t.column :created_on
      t.column :updated_on
      t.column :user_type
    end
  end

  def self.down
    drop_view :user_with_types
  end
end
