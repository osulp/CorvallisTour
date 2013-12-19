FactoryGirl.define do
  factory :location do
    sequence(:name) { |n| "Raser Stadium #{n}" }
    latitude 44.56
    longitude -123.28
    radius 200.0
  end
end
