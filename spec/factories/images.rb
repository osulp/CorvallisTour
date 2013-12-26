FactoryGirl.define do
  factory :image do
    location
    title "Reser Stadium"
    description "This looks cool"
    photo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/sample_image.png')))
  end
end
