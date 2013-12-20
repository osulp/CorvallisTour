module AuthHelper
  USERNAME = 'admin'
  PASSWORD = 'secretadmin'

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