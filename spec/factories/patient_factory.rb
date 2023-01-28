FactoryBot.define do
  factory :patient, parent: :user do
    account_type { :patient }
  end
end
