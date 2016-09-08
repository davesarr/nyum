class ApplicationController < ActionController::Base
  require 'fuzzystringmatch'
  protect_from_forgery with: :exception

  before_action :authenticate

  def authenticate
    unless ENV['HTTP_AUTH_USERNAME'].blank? or ENV['HTTP_AUTH_PASSWORD'].blank?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['HTTP_AUTH_USERNAME'] && password == ENV['HTTP_AUTH_PASSWORD']
      end
    end
  end

  def fetch_menu_url_from_zomato( db_restaurant_name )
    fuzzy_string_match = FuzzyStringMatch::JaroWinkler.create( :native )
    best_match = 0
    menu_url = ''
    @options = {
        query: { "q" => db_restaurant_name },
        headers: { "user-key" => ENV["ZOMATO_API_KEY"] }}

    response = HTTParty.get(
      "https://developers.zomato.com/api/v2.1/search",
      @options )

    zomato_restaurants = JSON.parse(response.body)['restaurants']

    zomato_restaurants.each do | restaurant |
      restaurant_name = restaurant['restaurant']['name']
      match_ratio = fuzzy_string_match.getDistance(
        "db_restaurant_name",
        "zomato_restaurant_name" )
      if match_ratio > best_match
        best_match = match_ratio
        menu_url = restaurant['restaurant']['menu_url']
      end
    end
    return menu_url
  end
end
