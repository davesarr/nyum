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
          Restaurant.create(yelp_id: response.id,
            name: response.name,
            image_url: response.image_url,
            address:response.location.display_address.to_s.gsub(/[\[\]"]/, ''),
            phone: response.phone,
            rating: ((response.rating-1)*(99/4)+1).to_i,
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
    #locu api
    response = HTTParty.get(
      "https://api.locu.com/v1_0/venue/search/?name=" +
      @current_restaurant.name +
      "&locality=new%20york" +
      "&api_key="+ENV["LOCU_API_KEY"]
    )
    if !response["objects"].empty? && !response == nil
      @menu_id=response["objects"][0]["id"]

    #zomato api
    else
    menu_url = fetch_menu_url_from_api( @current_restaurant.name )
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
    redirect_to :back
  end

  def downvote
    @restaurant = Restaurant.find_by_yelp_id(params[:id])
    @restaurant.downvote_by current_user
    redirect_to :back
  end


  def fetch_menu_url_from_api( db_restaurant_name )
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
