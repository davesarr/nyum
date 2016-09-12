class RestaurantsController < ApplicationController

  def index
    location = params[:search]
    term = params[:term]
    sort = params[:sort]
    params = {limit: 20,
        sort: sort,
        term: term
    }
    if location.present? && !Yelp::Error::UnavailableForLocation
      @responses = Yelp.client.search(location, params)
      @responses.businesses.each do |response|
        if Restaurant.find_by_yelp_id(response.id)==nil
          Restaurant.create(yelp_id: response.id,
            name: response.name,
            image_url: response.image_url,
            address:response.location.display_address.to_s.gsub(/[\[\]"]/, ''),
            phone: response.phone,
            rating: ((response.rating-1)*(99/4)+1).to_i,
            latitude: response.location.coordinate.latitude,
            longitude: response.location.coordinate.longitude,
            category: response.categories.to_s.
              gsub(/[ \[\]"]/,'').
              gsub(/\b([a-z])\w+/, ' ').
              gsub(/,/, ' ')
            )
          end
        end
      end
    end

  def show

    @current_restaurant = Restaurant.find_by_yelp_id(params[:id])
    @latitude= @current_restaurant.latitude
    @longitude= @current_restaurant.longitude
    #locu api
    response = HTTParty.get(
      "https://api.locu.com/v1_0/venue/search/?" +
      "location=" + (@latitude).round(3).to_s + ", " + (@longitude).round(3).to_s +
      "&name=" + @current_restaurant.name +
      "&api_key="+ENV["LOCU_API_KEY"]
    )
    if response["objects"].empty? ==false
      @menu_id=response["objects"][response["objects"].length-1]["id"]

    #zomato api
    else
      menu_url = fetch_menu_url_from_api( @current_restaurant )
      unless menu_url == 'no match'
        doc = Nokogiri::HTML( open( menu_url ) )
        unless doc == nil
          @menu = doc.css( 'div.tmi-name' )
        end
      end
    end
  end


  def upvote
    @restaurant = Restaurant.find_by_yelp_id(params[:id])
    @restaurant.upvote_by current_user
    redirect_to request.referer + '#'+@restaurant.yelp_id
  end

  def downvote
    @restaurant = Restaurant.find_by_yelp_id(params[:id])
    @restaurant.downvote_by current_user
    redirect_to request.referer + '#'+@restaurant.yelp_id
  end


  def fetch_menu_url_from_api( db_restaurant_obj )
    fuzzy_string_match = FuzzyStringMatch::JaroWinkler.create( :native )
    best_match = 0
    menu_url = ''
    options = {
        query: {
          "q" => db_restaurant_obj.name,
          "lat" => db_restaurant_obj.latitude,
          "lon" => db_restaurant_obj.longitude
        },
        headers: { "user-key" => ENV["ZOMATO_API_KEY"] }}

    response = HTTParty.get(
      "https://developers.zomato.com/api/v2.1/search",
      options )

    zomato_restaurants = JSON.parse(response.body)['restaurants']

    zomato_restaurants.each do | restaurant |
      zomato_restaurant_name = restaurant['restaurant']['name']
      match_ratio = fuzzy_string_match.getDistance(
        db_restaurant_obj.name,
        zomato_restaurant_name )
      if match_ratio > best_match
        best_match = match_ratio
        menu_url = restaurant['restaurant']['menu_url']
      end
    end
    return best_match > 0.666 ? menu_url : 'no match'
  end



end
