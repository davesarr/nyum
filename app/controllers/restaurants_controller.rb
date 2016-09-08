require 'open-uri'
class RestaurantsController < ApplicationController
  def index
    location = params[:search]
    term = params[:term]
    sort = params[:sort]
    params = {limit: 20,
        sort: sort,
        term: term
    }
    if location.present?
        @responses = Yelp.client.search(location, params)
        @responses.businesses.each do |response|
          if Restaurant.find_by_yelp_id(response.id)==nil
            then Restaurant.create(yelp_id: response.id, name: response.name, image_url: response.image_url, address:response.location.display_address.to_s.gsub(/[\[\]"]/, ''), phone: response.phone, rating: ((response.rating-1)*(99/4)+1).to_i)
          end
        end
      end
    end

  def show
    @current_restaurant = Restaurant.find_by_yelp_id(params[:id])
    menu_url = fetch_menu_url_from_zomato( @current_restaurant.name )
    unless menu_url == 'no match'
      doc = Nokogiri::HTML( open( menu_url ) )
      unless doc == nil
        @menu = doc.css( 'div.tmi-name' )
      end
    end
  end

  def upvote
    @restaurant = Restaurant.find_by_yelp_id(params[:id])
    @restaurant.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @restaurant = Restaurant.find_by_yelp_id(params[:id])
    @restaurant.downvote_by current_user

    redirect_to :back
  end


  def fetch_menu_url_from_zomato( db_restaurant_name )
    fuzzy_string_match = FuzzyStringMatch::JaroWinkler.create( :native )
    best_match = 0
    menu_url = ''
    options = {
        query: { "q" => db_restaurant_name },
        headers: { "user-key" => ENV["ZOMATO_API_KEY"] }}

    response = HTTParty.get(
      "https://developers.zomato.com/api/v2.1/search",
      options )

    zomato_restaurants = JSON.parse(response.body)['restaurants']

    zomato_restaurants.each do | restaurant |
      zomato_restaurant_name = restaurant['restaurant']['name']
      match_ratio = fuzzy_string_match.getDistance(
        db_restaurant_name,
        zomato_restaurant_name )
      if match_ratio > best_match
        best_match = match_ratio
        menu_url = restaurant['restaurant']['menu_url']
      end
    end
    return best_match > 0.666 ? menu_url : 'no match'
  end



end
