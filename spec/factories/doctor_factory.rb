FactoryBot.define do
  factory :doctor, parent: :user do
    account_type { :doctor }
    professions { [FactoryBot.create(:profession)] }
  end
end
