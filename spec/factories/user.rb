FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    gender { ['male', 'female'].sample }
    birthday { Time.at(rand * Time.now.to_i) }
    interested_in { ['male', 'female'].sample }
  end
end