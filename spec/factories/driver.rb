FactoryBot.define do
  factory :driver do
    home_address { Faker::Address.full_address }
  end
end
