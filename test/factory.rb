FactoryGirl.define do

  factory :activity do
    sequence(:name){|i| "Activity #{i}"}
    association :completer
    association :approver
    association :qc_officer
    association :service_area
    review_on Date.today

  end

  factory :service_area do
    sequence(:name){|i| "Service Area #{i}"}
    association :approver
    association :directorate
  end

  factory :question do
    section "impact"
    strand  "gender"
    sequence(:name){|i| "impact_gender_#{i}_test"}
    association :activity
    needed true
    completed false
  end

  factory :issue do
    description "Issue description"
    association :activity
  end

  factory :user do
    sequence(:email) {|n| "test#{n}@example.com"}
    password "password"
    password_confirmation "password"

    factory :completer do
    end

    factory :approver do
    end

    factory :creator do
      creator true
    end

    factory :corporate_cop do
      corporate_cop true
    end

    factory :cop do
    end

    factory :qc_officer do
    end
  end

  factory :administrator do
    sequence(:email) {|n| "admin#{n}@example.com"}
    password "password"
    password_confirmation "password"
  end

  factory :strategy do
    sequence(:name){|i| "Strategy #{i}"}
  end

  factory :directorate do
    sequence(:name){|i| "Directorate #{i}"}
    association :creator
    # association :cop
    cops { [FactoryGirl.build(:user)] }

    # after_build do |u|
    #   u.cops << FactoryGirl.build(:user, :directorates => [u])
    #   #a = FactoryGirl.build(:user, :directorates => [u])
    #   #u.cops = [a]
    #   #u.save!
    # end
  end

end