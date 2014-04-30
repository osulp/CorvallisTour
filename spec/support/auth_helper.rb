module AuthHelper
  USERNAME = 'admin'
  PASSWORD = 'secretadmin'
  RSpec.configure do |config|
    config.before(:each) do
      APP_CONFIG['authentication'].stub(:[]).with('username').and_return('admin')
      APP_CONFIG['authentication'].stub(:[]).with('password').and_return(Digest::MD5.hexdigest('secretadmin'))
    end
  end
  def http_login
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(USERNAME, PASSWORD)
  end

  def capybara_login
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(USERNAME, PASSWORD)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(USERNAME, PASSWORD)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(USERNAME, PASSWORD)
    else
      raise "I don't know how to log in!"
    end
  end
end
