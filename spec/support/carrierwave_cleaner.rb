RSpec.configure do |config|
  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/tmp"])
    end
  end
end
