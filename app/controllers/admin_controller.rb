class AdminController < ApplicationController
  before_filter :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      md5password = Digest::MD5.hexdigest(password)
      username == APP_CONFIG['authentication']['username'] && md5password == APP_CONFIG['authentication']['password']
    end
  end
end
