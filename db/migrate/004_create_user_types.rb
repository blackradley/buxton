#  
# * $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/db/migrate/001_create_users.rb $
# * $Rev: 35 $
# * $Author: BlackRadleyJoe $
# * $Date: 2007-04-10 11:31:29 +0100 (Tue, 10 Apr 2007) $
#
class CreateUserTypes < ActiveRecord::Migration
#
# Create a view so we can see what types of users we have.  Rather
# than putting a user type in the users table this is done using 
# joins with the organisations and functions tables.  There must be
# a way that this can be done natively with ActiveRecord but I 
# can't see a way right now. 
#
  def self.up
    create_view :user_with_type, "SELECT users.*, " + 
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
    drop_view :user_with_type
  end
end
