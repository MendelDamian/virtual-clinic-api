FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    account_type { User.account_types.keys.sample }
  end

  factory :patient, parent: :user do
    account_type { :patient }
  end

  factory :doctor, parent: :user do
    account_type { :doctor }
  end
end