#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class RemovingUnneededActionPlanning < ActiveRecord::Migration
  def self.up
	  remove_column :functions, :action_planning_gender_1
	remove_column :functions, :action_planning_gender_2
	remove_column :functions, :action_planning_gender_3
	remove_column :functions, :action_planning_gender_4
	remove_column :functions, :action_planning_gender_5
	remove_column :functions, :action_planning_gender_6
	remove_column :functions, :action_planning_gender_7
	remove_column :functions, :action_planning_gender_8
	remove_column :functions, :action_planning_gender_9
	remove_column :functions, :action_planning_gender_10
	remove_column :functions, :action_planning_gender_11
	remove_column :functions, :action_planning_gender_12
	remove_column :functions, :action_planning_gender_13
	remove_column :functions, :action_planning_gender_14
	remove_column :functions, :action_planning_gender_15
	remove_column :functions, :action_planning_gender_16
	remove_column :functions, :action_planning_gender_17
	remove_column :functions, :action_planning_gender_18
	remove_column :functions, :action_planning_gender_19
	remove_column :functions, :action_planning_gender_20
	remove_column :functions, :action_planning_gender_21
	remove_column :functions, :action_planning_gender_22
	remove_column :functions, :action_planning_gender_23
	remove_column :functions, :action_planning_gender_24
	remove_column :functions, :action_planning_gender_25
	remove_column :functions, :action_planning_gender_26
	remove_column :functions, :action_planning_gender_27
	remove_column :functions, :action_planning_gender_28
	remove_column :functions, :action_planning_gender_29
	remove_column :functions, :action_planning_gender_30
	remove_column :functions, :action_planning_gender_31
	remove_column :functions, :action_planning_gender_32
	remove_column :functions, :action_planning_gender_33
	remove_column :functions, :action_planning_gender_34
	remove_column :functions, :action_planning_gender_35
	remove_column :functions, :action_planning_gender_36
	remove_column :functions, :action_planning_gender_37
	remove_column :functions, :action_planning_gender_38
	remove_column :functions, :action_planning_gender_39
	remove_column :functions, :action_planning_gender_40
	remove_column :functions, :action_planning_gender_41
	remove_column :functions, :action_planning_gender_42
	remove_column :functions, :action_planning_gender_43
	remove_column :functions, :action_planning_gender_44
	remove_column :functions, :action_planning_gender_45
	remove_column :functions, :action_planning_gender_46
	remove_column :functions, :action_planning_gender_47
	remove_column :functions, :action_planning_gender_48
	remove_column :functions, :action_planning_gender_49
	remove_column :functions, :action_planning_gender_50
	
	remove_column :functions, :action_planning_race_1
	remove_column :functions, :action_planning_race_2
	remove_column :functions, :action_planning_race_3
	remove_column :functions, :action_planning_race_4
	remove_column :functions, :action_planning_race_5
	remove_column :functions, :action_planning_race_6
	remove_column :functions, :action_planning_race_7
	remove_column :functions, :action_planning_race_8
	remove_column :functions, :action_planning_race_9
	remove_column :functions, :action_planning_race_10
	remove_column :functions, :action_planning_race_11
	remove_column :functions, :action_planning_race_12
	remove_column :functions, :action_planning_race_13
	remove_column :functions, :action_planning_race_14
	remove_column :functions, :action_planning_race_15
	remove_column :functions, :action_planning_race_16
	remove_column :functions, :action_planning_race_17
	remove_column :functions, :action_planning_race_18
	remove_column :functions, :action_planning_race_19
	remove_column :functions, :action_planning_race_20
	remove_column :functions, :action_planning_race_21
	remove_column :functions, :action_planning_race_22
	remove_column :functions, :action_planning_race_23
	remove_column :functions, :action_planning_race_24
	remove_column :functions, :action_planning_race_25
	remove_column :functions, :action_planning_race_26
	remove_column :functions, :action_planning_race_27
	remove_column :functions, :action_planning_race_28
	remove_column :functions, :action_planning_race_29
	remove_column :functions, :action_planning_race_30
	remove_column :functions, :action_planning_race_31
	remove_column :functions, :action_planning_race_32
	remove_column :functions, :action_planning_race_33
	remove_column :functions, :action_planning_race_34
	remove_column :functions, :action_planning_race_35
	remove_column :functions, :action_planning_race_36
	remove_column :functions, :action_planning_race_37
	remove_column :functions, :action_planning_race_38
	remove_column :functions, :action_planning_race_39
	remove_column :functions, :action_planning_race_40
	remove_column :functions, :action_planning_race_41
	remove_column :functions, :action_planning_race_42
	remove_column :functions, :action_planning_race_43
	remove_column :functions, :action_planning_race_44
	remove_column :functions, :action_planning_race_45
	remove_column :functions, :action_planning_race_46
	remove_column :functions, :action_planning_race_47
	remove_column :functions, :action_planning_race_48
	remove_column :functions, :action_planning_race_49
	remove_column :functions, :action_planning_race_50	
	
	remove_column :functions, :action_planning_disability_1
	remove_column :functions, :action_planning_disability_2
	remove_column :functions, :action_planning_disability_3
	remove_column :functions, :action_planning_disability_4
	remove_column :functions, :action_planning_disability_5
	remove_column :functions, :action_planning_disability_6
	remove_column :functions, :action_planning_disability_7
	remove_column :functions, :action_planning_disability_8
	remove_column :functions, :action_planning_disability_9
	remove_column :functions, :action_planning_disability_10
	remove_column :functions, :action_planning_disability_11
	remove_column :functions, :action_planning_disability_12
	remove_column :functions, :action_planning_disability_13
	remove_column :functions, :action_planning_disability_14
	remove_column :functions, :action_planning_disability_15
	remove_column :functions, :action_planning_disability_16
	remove_column :functions, :action_planning_disability_17
	remove_column :functions, :action_planning_disability_18
	remove_column :functions, :action_planning_disability_19
	remove_column :functions, :action_planning_disability_20
	remove_column :functions, :action_planning_disability_21
	remove_column :functions, :action_planning_disability_22
	remove_column :functions, :action_planning_disability_23
	remove_column :functions, :action_planning_disability_24
	remove_column :functions, :action_planning_disability_25
	remove_column :functions, :action_planning_disability_26
	remove_column :functions, :action_planning_disability_27
	remove_column :functions, :action_planning_disability_28
	remove_column :functions, :action_planning_disability_29
	remove_column :functions, :action_planning_disability_30
	remove_column :functions, :action_planning_disability_31
	remove_column :functions, :action_planning_disability_32
	remove_column :functions, :action_planning_disability_33
	remove_column :functions, :action_planning_disability_34
	remove_column :functions, :action_planning_disability_35
	remove_column :functions, :action_planning_disability_36
	remove_column :functions, :action_planning_disability_37
	remove_column :functions, :action_planning_disability_38
	remove_column :functions, :action_planning_disability_39
	remove_column :functions, :action_planning_disability_40
	remove_column :functions, :action_planning_disability_41
	remove_column :functions, :action_planning_disability_42
	remove_column :functions, :action_planning_disability_43
	remove_column :functions, :action_planning_disability_44
	remove_column :functions, :action_planning_disability_45
	remove_column :functions, :action_planning_disability_46
	remove_column :functions, :action_planning_disability_47
	remove_column :functions, :action_planning_disability_48
	remove_column :functions, :action_planning_disability_49
	remove_column :functions, :action_planning_disability_50
	
	remove_column :functions, :action_planning_faith_1
	remove_column :functions, :action_planning_faith_2
	remove_column :functions, :action_planning_faith_3
	remove_column :functions, :action_planning_faith_4
	remove_column :functions, :action_planning_faith_5
	remove_column :functions, :action_planning_faith_6
	remove_column :functions, :action_planning_faith_7
	remove_column :functions, :action_planning_faith_8
	remove_column :functions, :action_planning_faith_9
	remove_column :functions, :action_planning_faith_10
	remove_column :functions, :action_planning_faith_11
	remove_column :functions, :action_planning_faith_12
	remove_column :functions, :action_planning_faith_13
	remove_column :functions, :action_planning_faith_14
	remove_column :functions, :action_planning_faith_15
	remove_column :functions, :action_planning_faith_16
	remove_column :functions, :action_planning_faith_17
	remove_column :functions, :action_planning_faith_18
	remove_column :functions, :action_planning_faith_19
	remove_column :functions, :action_planning_faith_20
	remove_column :functions, :action_planning_faith_21
	remove_column :functions, :action_planning_faith_22
	remove_column :functions, :action_planning_faith_23
	remove_column :functions, :action_planning_faith_24
	remove_column :functions, :action_planning_faith_25
	remove_column :functions, :action_planning_faith_26
	remove_column :functions, :action_planning_faith_27
	remove_column :functions, :action_planning_faith_28
	remove_column :functions, :action_planning_faith_29
	remove_column :functions, :action_planning_faith_30
	remove_column :functions, :action_planning_faith_31
	remove_column :functions, :action_planning_faith_32
	remove_column :functions, :action_planning_faith_33
	remove_column :functions, :action_planning_faith_34
	remove_column :functions, :action_planning_faith_35
	remove_column :functions, :action_planning_faith_36
	remove_column :functions, :action_planning_faith_37
	remove_column :functions, :action_planning_faith_38
	remove_column :functions, :action_planning_faith_39
	remove_column :functions, :action_planning_faith_40
	remove_column :functions, :action_planning_faith_41
	remove_column :functions, :action_planning_faith_42
	remove_column :functions, :action_planning_faith_43
	remove_column :functions, :action_planning_faith_44
	remove_column :functions, :action_planning_faith_45
	remove_column :functions, :action_planning_faith_46
	remove_column :functions, :action_planning_faith_47
	remove_column :functions, :action_planning_faith_48
	remove_column :functions, :action_planning_faith_49
	remove_column :functions, :action_planning_faith_50

	remove_column :functions, :action_planning_sexual_orientation_1
	remove_column :functions, :action_planning_sexual_orientation_2
	remove_column :functions, :action_planning_sexual_orientation_3
	remove_column :functions, :action_planning_sexual_orientation_4
	remove_column :functions, :action_planning_sexual_orientation_5
	remove_column :functions, :action_planning_sexual_orientation_6
	remove_column :functions, :action_planning_sexual_orientation_7
	remove_column :functions, :action_planning_sexual_orientation_8
	remove_column :functions, :action_planning_sexual_orientation_9
	remove_column :functions, :action_planning_sexual_orientation_10
	remove_column :functions, :action_planning_sexual_orientation_11
	remove_column :functions, :action_planning_sexual_orientation_12
	remove_column :functions, :action_planning_sexual_orientation_13
	remove_column :functions, :action_planning_sexual_orientation_14
	remove_column :functions, :action_planning_sexual_orientation_15
	remove_column :functions, :action_planning_sexual_orientation_16
	remove_column :functions, :action_planning_sexual_orientation_17
	remove_column :functions, :action_planning_sexual_orientation_18
	remove_column :functions, :action_planning_sexual_orientation_19
	remove_column :functions, :action_planning_sexual_orientation_20
	remove_column :functions, :action_planning_sexual_orientation_21
	remove_column :functions, :action_planning_sexual_orientation_22
	remove_column :functions, :action_planning_sexual_orientation_23
	remove_column :functions, :action_planning_sexual_orientation_24
	remove_column :functions, :action_planning_sexual_orientation_25
	remove_column :functions, :action_planning_sexual_orientation_26
	remove_column :functions, :action_planning_sexual_orientation_27
	remove_column :functions, :action_planning_sexual_orientation_28
	remove_column :functions, :action_planning_sexual_orientation_29
	remove_column :functions, :action_planning_sexual_orientation_30
	remove_column :functions, :action_planning_sexual_orientation_31
	remove_column :functions, :action_planning_sexual_orientation_32
	remove_column :functions, :action_planning_sexual_orientation_33
	remove_column :functions, :action_planning_sexual_orientation_34
	remove_column :functions, :action_planning_sexual_orientation_35
	remove_column :functions, :action_planning_sexual_orientation_36
	remove_column :functions, :action_planning_sexual_orientation_37
	remove_column :functions, :action_planning_sexual_orientation_38
	remove_column :functions, :action_planning_sexual_orientation_39
	remove_column :functions, :action_planning_sexual_orientation_40
	remove_column :functions, :action_planning_sexual_orientation_41
	remove_column :functions, :action_planning_sexual_orientation_42
	remove_column :functions, :action_planning_sexual_orientation_43
	remove_column :functions, :action_planning_sexual_orientation_44
	remove_column :functions, :action_planning_sexual_orientation_45
	remove_column :functions, :action_planning_sexual_orientation_46
	remove_column :functions, :action_planning_sexual_orientation_47
	remove_column :functions, :action_planning_sexual_orientation_48
	remove_column :functions, :action_planning_sexual_orientation_49
	remove_column :functions, :action_planning_sexual_orientation_50
	
	remove_column :functions, :action_planning_age_1
	remove_column :functions, :action_planning_age_2
	remove_column :functions, :action_planning_age_3
	remove_column :functions, :action_planning_age_4
	remove_column :functions, :action_planning_age_5
	remove_column :functions, :action_planning_age_6
	remove_column :functions, :action_planning_age_7
	remove_column :functions, :action_planning_age_8
	remove_column :functions, :action_planning_age_9
	remove_column :functions, :action_planning_age_10
	remove_column :functions, :action_planning_age_11
	remove_column :functions, :action_planning_age_12
	remove_column :functions, :action_planning_age_13
	remove_column :functions, :action_planning_age_14
	remove_column :functions, :action_planning_age_15
	remove_column :functions, :action_planning_age_16
	remove_column :functions, :action_planning_age_17
	remove_column :functions, :action_planning_age_18
	remove_column :functions, :action_planning_age_19
	remove_column :functions, :action_planning_age_20
	remove_column :functions, :action_planning_age_21
	remove_column :functions, :action_planning_age_22
	remove_column :functions, :action_planning_age_23
	remove_column :functions, :action_planning_age_24
	remove_column :functions, :action_planning_age_25
	remove_column :functions, :action_planning_age_26
	remove_column :functions, :action_planning_age_27
	remove_column :functions, :action_planning_age_28
	remove_column :functions, :action_planning_age_29
	remove_column :functions, :action_planning_age_30
	remove_column :functions, :action_planning_age_31
	remove_column :functions, :action_planning_age_32
	remove_column :functions, :action_planning_age_33
	remove_column :functions, :action_planning_age_34
	remove_column :functions, :action_planning_age_35
	remove_column :functions, :action_planning_age_36
	remove_column :functions, :action_planning_age_37
	remove_column :functions, :action_planning_age_38
	remove_column :functions, :action_planning_age_39
	remove_column :functions, :action_planning_age_40
	remove_column :functions, :action_planning_age_41
	remove_column :functions, :action_planning_age_42
	remove_column :functions, :action_planning_age_43
	remove_column :functions, :action_planning_age_44
	remove_column :functions, :action_planning_age_45
	remove_column :functions, :action_planning_age_46
	remove_column :functions, :action_planning_age_47
	remove_column :functions, :action_planning_age_48
	remove_column :functions, :action_planning_age_49
	remove_column :functions, :action_planning_age_50  
  end

  def self.down
	  	add_column :functions, :action_planning_gender_1, :text
	add_column :functions, :action_planning_gender_2, :text
	add_column :functions, :action_planning_gender_3, :text
	add_column :functions, :action_planning_gender_4, :text
	add_column :functions, :action_planning_gender_5, :text
	add_column :functions, :action_planning_gender_6, :text
	add_column :functions, :action_planning_gender_7, :text
	add_column :functions, :action_planning_gender_8, :text
	add_column :functions, :action_planning_gender_9, :text
	add_column :functions, :action_planning_gender_10, :text
	add_column :functions, :action_planning_gender_11, :text
	add_column :functions, :action_planning_gender_12, :text
	add_column :functions, :action_planning_gender_13, :text
	add_column :functions, :action_planning_gender_14, :text
	add_column :functions, :action_planning_gender_15, :text
	add_column :functions, :action_planning_gender_16, :text
	add_column :functions, :action_planning_gender_17, :text
	add_column :functions, :action_planning_gender_18, :text
	add_column :functions, :action_planning_gender_19, :text
	add_column :functions, :action_planning_gender_20, :text
	add_column :functions, :action_planning_gender_21, :text
	add_column :functions, :action_planning_gender_22, :text
	add_column :functions, :action_planning_gender_23, :text
	add_column :functions, :action_planning_gender_24, :text
	add_column :functions, :action_planning_gender_25, :text
	add_column :functions, :action_planning_gender_26, :text
	add_column :functions, :action_planning_gender_27, :text
	add_column :functions, :action_planning_gender_28, :text
	add_column :functions, :action_planning_gender_29, :text
	add_column :functions, :action_planning_gender_30, :text
	add_column :functions, :action_planning_gender_31, :text
	add_column :functions, :action_planning_gender_32, :text
	add_column :functions, :action_planning_gender_33, :text
	add_column :functions, :action_planning_gender_34, :text
	add_column :functions, :action_planning_gender_35, :text
	add_column :functions, :action_planning_gender_36, :text
	add_column :functions, :action_planning_gender_37, :text
	add_column :functions, :action_planning_gender_38, :text
	add_column :functions, :action_planning_gender_39, :text
	add_column :functions, :action_planning_gender_40, :text
	add_column :functions, :action_planning_gender_41, :text
	add_column :functions, :action_planning_gender_42, :text
	add_column :functions, :action_planning_gender_43, :text
	add_column :functions, :action_planning_gender_44, :text
	add_column :functions, :action_planning_gender_45, :text
	add_column :functions, :action_planning_gender_46, :text
	add_column :functions, :action_planning_gender_47, :text
	add_column :functions, :action_planning_gender_48, :text
	add_column :functions, :action_planning_gender_49, :text
	add_column :functions, :action_planning_gender_50, :text
	
	add_column :functions, :action_planning_race_1, :text
	add_column :functions, :action_planning_race_2, :text
	add_column :functions, :action_planning_race_3, :text
	add_column :functions, :action_planning_race_4, :text
	add_column :functions, :action_planning_race_5, :text
	add_column :functions, :action_planning_race_6, :text
	add_column :functions, :action_planning_race_7, :text
	add_column :functions, :action_planning_race_8, :text
	add_column :functions, :action_planning_race_9, :text
	add_column :functions, :action_planning_race_10, :text
	add_column :functions, :action_planning_race_11, :text
	add_column :functions, :action_planning_race_12, :text
	add_column :functions, :action_planning_race_13, :text
	add_column :functions, :action_planning_race_14, :text
	add_column :functions, :action_planning_race_15, :text
	add_column :functions, :action_planning_race_16, :text
	add_column :functions, :action_planning_race_17, :text
	add_column :functions, :action_planning_race_18, :text
	add_column :functions, :action_planning_race_19, :text
	add_column :functions, :action_planning_race_20, :text
	add_column :functions, :action_planning_race_21, :text
	add_column :functions, :action_planning_race_22, :text
	add_column :functions, :action_planning_race_23, :text
	add_column :functions, :action_planning_race_24, :text
	add_column :functions, :action_planning_race_25, :text
	add_column :functions, :action_planning_race_26, :text
	add_column :functions, :action_planning_race_27, :text
	add_column :functions, :action_planning_race_28, :text
	add_column :functions, :action_planning_race_29, :text
	add_column :functions, :action_planning_race_30, :text
	add_column :functions, :action_planning_race_31, :text
	add_column :functions, :action_planning_race_32, :text
	add_column :functions, :action_planning_race_33, :text
	add_column :functions, :action_planning_race_34, :text
	add_column :functions, :action_planning_race_35, :text
	add_column :functions, :action_planning_race_36, :text
	add_column :functions, :action_planning_race_37, :text
	add_column :functions, :action_planning_race_38, :text
	add_column :functions, :action_planning_race_39, :text
	add_column :functions, :action_planning_race_40, :text
	add_column :functions, :action_planning_race_41, :text
	add_column :functions, :action_planning_race_42, :text
	add_column :functions, :action_planning_race_43, :text
	add_column :functions, :action_planning_race_44, :text
	add_column :functions, :action_planning_race_45, :text
	add_column :functions, :action_planning_race_46, :text
	add_column :functions, :action_planning_race_47, :text
	add_column :functions, :action_planning_race_48, :text
	add_column :functions, :action_planning_race_49, :text
	add_column :functions, :action_planning_race_50, :text	
	
	add_column :functions, :action_planning_disability_1, :text
	add_column :functions, :action_planning_disability_2, :text
	add_column :functions, :action_planning_disability_3, :text
	add_column :functions, :action_planning_disability_4, :text
	add_column :functions, :action_planning_disability_5, :text
	add_column :functions, :action_planning_disability_6, :text
	add_column :functions, :action_planning_disability_7, :text
	add_column :functions, :action_planning_disability_8, :text
	add_column :functions, :action_planning_disability_9, :text
	add_column :functions, :action_planning_disability_10, :text
	add_column :functions, :action_planning_disability_11, :text
	add_column :functions, :action_planning_disability_12, :text
	add_column :functions, :action_planning_disability_13, :text
	add_column :functions, :action_planning_disability_14, :text
	add_column :functions, :action_planning_disability_15, :text
	add_column :functions, :action_planning_disability_16, :text
	add_column :functions, :action_planning_disability_17, :text
	add_column :functions, :action_planning_disability_18, :text
	add_column :functions, :action_planning_disability_19, :text
	add_column :functions, :action_planning_disability_20, :text
	add_column :functions, :action_planning_disability_21, :text
	add_column :functions, :action_planning_disability_22, :text
	add_column :functions, :action_planning_disability_23, :text
	add_column :functions, :action_planning_disability_24, :text
	add_column :functions, :action_planning_disability_25, :text
	add_column :functions, :action_planning_disability_26, :text
	add_column :functions, :action_planning_disability_27, :text
	add_column :functions, :action_planning_disability_28, :text
	add_column :functions, :action_planning_disability_29, :text
	add_column :functions, :action_planning_disability_30, :text
	add_column :functions, :action_planning_disability_31, :text
	add_column :functions, :action_planning_disability_32, :text
	add_column :functions, :action_planning_disability_33, :text
	add_column :functions, :action_planning_disability_34, :text
	add_column :functions, :action_planning_disability_35, :text
	add_column :functions, :action_planning_disability_36, :text
	add_column :functions, :action_planning_disability_37, :text
	add_column :functions, :action_planning_disability_38, :text
	add_column :functions, :action_planning_disability_39, :text
	add_column :functions, :action_planning_disability_40, :text
	add_column :functions, :action_planning_disability_41, :text
	add_column :functions, :action_planning_disability_42, :text
	add_column :functions, :action_planning_disability_43, :text
	add_column :functions, :action_planning_disability_44, :text
	add_column :functions, :action_planning_disability_45, :text
	add_column :functions, :action_planning_disability_46, :text
	add_column :functions, :action_planning_disability_47, :text
	add_column :functions, :action_planning_disability_48, :text
	add_column :functions, :action_planning_disability_49, :text
	add_column :functions, :action_planning_disability_50, :text
	
	add_column :functions, :action_planning_faith_1, :text
	add_column :functions, :action_planning_faith_2, :text
	add_column :functions, :action_planning_faith_3, :text
	add_column :functions, :action_planning_faith_4, :text
	add_column :functions, :action_planning_faith_5, :text
	add_column :functions, :action_planning_faith_6, :text
	add_column :functions, :action_planning_faith_7, :text
	add_column :functions, :action_planning_faith_8, :text
	add_column :functions, :action_planning_faith_9, :text
	add_column :functions, :action_planning_faith_10, :text
	add_column :functions, :action_planning_faith_11, :text
	add_column :functions, :action_planning_faith_12, :text
	add_column :functions, :action_planning_faith_13, :text
	add_column :functions, :action_planning_faith_14, :text
	add_column :functions, :action_planning_faith_15, :text
	add_column :functions, :action_planning_faith_16, :text
	add_column :functions, :action_planning_faith_17, :text
	add_column :functions, :action_planning_faith_18, :text
	add_column :functions, :action_planning_faith_19, :text
	add_column :functions, :action_planning_faith_20, :text
	add_column :functions, :action_planning_faith_21, :text
	add_column :functions, :action_planning_faith_22, :text
	add_column :functions, :action_planning_faith_23, :text
	add_column :functions, :action_planning_faith_24, :text
	add_column :functions, :action_planning_faith_25, :text
	add_column :functions, :action_planning_faith_26, :text
	add_column :functions, :action_planning_faith_27, :text
	add_column :functions, :action_planning_faith_28, :text
	add_column :functions, :action_planning_faith_29, :text
	add_column :functions, :action_planning_faith_30, :text
	add_column :functions, :action_planning_faith_31, :text
	add_column :functions, :action_planning_faith_32, :text
	add_column :functions, :action_planning_faith_33, :text
	add_column :functions, :action_planning_faith_34, :text
	add_column :functions, :action_planning_faith_35, :text
	add_column :functions, :action_planning_faith_36, :text
	add_column :functions, :action_planning_faith_37, :text
	add_column :functions, :action_planning_faith_38, :text
	add_column :functions, :action_planning_faith_39, :text
	add_column :functions, :action_planning_faith_40, :text
	add_column :functions, :action_planning_faith_41, :text
	add_column :functions, :action_planning_faith_42, :text
	add_column :functions, :action_planning_faith_43, :text
	add_column :functions, :action_planning_faith_44, :text
	add_column :functions, :action_planning_faith_45, :text
	add_column :functions, :action_planning_faith_46, :text
	add_column :functions, :action_planning_faith_47, :text
	add_column :functions, :action_planning_faith_48, :text
	add_column :functions, :action_planning_faith_49, :text
	add_column :functions, :action_planning_faith_50, :text

	add_column :functions, :action_planning_sexual_orientation_1, :text
	add_column :functions, :action_planning_sexual_orientation_2, :text
	add_column :functions, :action_planning_sexual_orientation_3, :text
	add_column :functions, :action_planning_sexual_orientation_4, :text
	add_column :functions, :action_planning_sexual_orientation_5, :text
	add_column :functions, :action_planning_sexual_orientation_6, :text
	add_column :functions, :action_planning_sexual_orientation_7, :text
	add_column :functions, :action_planning_sexual_orientation_8, :text
	add_column :functions, :action_planning_sexual_orientation_9, :text
	add_column :functions, :action_planning_sexual_orientation_10, :text
	add_column :functions, :action_planning_sexual_orientation_11, :text
	add_column :functions, :action_planning_sexual_orientation_12, :text
	add_column :functions, :action_planning_sexual_orientation_13, :text
	add_column :functions, :action_planning_sexual_orientation_14, :text
	add_column :functions, :action_planning_sexual_orientation_15, :text
	add_column :functions, :action_planning_sexual_orientation_16, :text
	add_column :functions, :action_planning_sexual_orientation_17, :text
	add_column :functions, :action_planning_sexual_orientation_18, :text
	add_column :functions, :action_planning_sexual_orientation_19, :text
	add_column :functions, :action_planning_sexual_orientation_20, :text
	add_column :functions, :action_planning_sexual_orientation_21, :text
	add_column :functions, :action_planning_sexual_orientation_22, :text
	add_column :functions, :action_planning_sexual_orientation_23, :text
	add_column :functions, :action_planning_sexual_orientation_24, :text
	add_column :functions, :action_planning_sexual_orientation_25, :text
	add_column :functions, :action_planning_sexual_orientation_26, :text
	add_column :functions, :action_planning_sexual_orientation_27, :text
	add_column :functions, :action_planning_sexual_orientation_28, :text
	add_column :functions, :action_planning_sexual_orientation_29, :text
	add_column :functions, :action_planning_sexual_orientation_30, :text
	add_column :functions, :action_planning_sexual_orientation_31, :text
	add_column :functions, :action_planning_sexual_orientation_32, :text
	add_column :functions, :action_planning_sexual_orientation_33, :text
	add_column :functions, :action_planning_sexual_orientation_34, :text
	add_column :functions, :action_planning_sexual_orientation_35, :text
	add_column :functions, :action_planning_sexual_orientation_36, :text
	add_column :functions, :action_planning_sexual_orientation_37, :text
	add_column :functions, :action_planning_sexual_orientation_38, :text
	add_column :functions, :action_planning_sexual_orientation_39, :text
	add_column :functions, :action_planning_sexual_orientation_40, :text
	add_column :functions, :action_planning_sexual_orientation_41, :text
	add_column :functions, :action_planning_sexual_orientation_42, :text
	add_column :functions, :action_planning_sexual_orientation_43, :text
	add_column :functions, :action_planning_sexual_orientation_44, :text
	add_column :functions, :action_planning_sexual_orientation_45, :text
	add_column :functions, :action_planning_sexual_orientation_46, :text
	add_column :functions, :action_planning_sexual_orientation_47, :text
	add_column :functions, :action_planning_sexual_orientation_48, :text
	add_column :functions, :action_planning_sexual_orientation_49, :text
	add_column :functions, :action_planning_sexual_orientation_50, :text
	
	add_column :functions, :action_planning_age_1, :text
	add_column :functions, :action_planning_age_2, :text
	add_column :functions, :action_planning_age_3, :text
	add_column :functions, :action_planning_age_4, :text
	add_column :functions, :action_planning_age_5, :text
	add_column :functions, :action_planning_age_6, :text
	add_column :functions, :action_planning_age_7, :text
	add_column :functions, :action_planning_age_8, :text
	add_column :functions, :action_planning_age_9, :text
	add_column :functions, :action_planning_age_10, :text
	add_column :functions, :action_planning_age_11, :text
	add_column :functions, :action_planning_age_12, :text
	add_column :functions, :action_planning_age_13, :text
	add_column :functions, :action_planning_age_14, :text
	add_column :functions, :action_planning_age_15, :text
	add_column :functions, :action_planning_age_16, :text
	add_column :functions, :action_planning_age_17, :text
	add_column :functions, :action_planning_age_18, :text
	add_column :functions, :action_planning_age_19, :text
	add_column :functions, :action_planning_age_20, :text
	add_column :functions, :action_planning_age_21, :text
	add_column :functions, :action_planning_age_22, :text
	add_column :functions, :action_planning_age_23, :text
	add_column :functions, :action_planning_age_24, :text
	add_column :functions, :action_planning_age_25, :text
	add_column :functions, :action_planning_age_26, :text
	add_column :functions, :action_planning_age_27, :text
	add_column :functions, :action_planning_age_28, :text
	add_column :functions, :action_planning_age_29, :text
	add_column :functions, :action_planning_age_30, :text
	add_column :functions, :action_planning_age_31, :text
	add_column :functions, :action_planning_age_32, :text
	add_column :functions, :action_planning_age_33, :text
	add_column :functions, :action_planning_age_34, :text
	add_column :functions, :action_planning_age_35, :text
	add_column :functions, :action_planning_age_36, :text
	add_column :functions, :action_planning_age_37, :text
	add_column :functions, :action_planning_age_38, :text
	add_column :functions, :action_planning_age_39, :text
	add_column :functions, :action_planning_age_40, :text
	add_column :functions, :action_planning_age_41, :text
	add_column :functions, :action_planning_age_42, :text
	add_column :functions, :action_planning_age_43, :text
	add_column :functions, :action_planning_age_44, :text
	add_column :functions, :action_planning_age_45, :text
	add_column :functions, :action_planning_age_46, :text
	add_column :functions, :action_planning_age_47, :text
	add_column :functions, :action_planning_age_48, :text
	add_column :functions, :action_planning_age_49, :text
	add_column :functions, :action_planning_age_50, :text
  end
end
