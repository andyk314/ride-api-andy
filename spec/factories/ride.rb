FactoryBot.define do
  factory :ride do
    start_address { Faker::Address.full_address }
    destination_address { Faker::Address.full_address }
    driver
  end
end
