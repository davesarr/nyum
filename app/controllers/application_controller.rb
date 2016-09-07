class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate

  def authenticate
    unless ENV['HTTP_AUTH_USERNAME'].blank? or ENV['HTTP_AUTH_PASSWORD'].blank?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['HTTP_AUTH_USERNAME'] && password == ENV['HTTP_AUTH_PASSWORD']
      end
    end
  end

  helper_method :zomato

private

  def zomato( restaurant_name )
    @options = {
        query: { 'res_id' => restaurant_name },
        headers: { 'user-key' => ENV["ZOMATO_API_KEY"] }
    }
    response = HTTParty.get("https://developers.zomato.com/api/v2.1/restaurant",
      @options
    )
    JSON.parse(response.body)
  end

end
