FactoryBot.define do
  factory :profession do
    name { Faker::Job.title }
  end
end
