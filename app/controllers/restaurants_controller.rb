class RestaurantsController < ApplicationController
  def index
    @restaurant

    location = params[:search]
    term = params[:term]
    sort = params[:sort].to_i
    params = {limit: 20,
        sort: sort,
        term: term
    }
    if location.present?
        @responses = Yelp.client.search(location, params)
        @responses.businesses.each do |response|
          if Restaurant.find_by_yelp_id(response.id)==nil
            then Restaurant.create(yelp_id: response.id, name: response.name)
          end
        end
      end
    end

<<<<<<< HEAD
  end
def show
  puts @current_restaurant
  @current_restaurant = Restaurant.find_by_yelp_id(params[:id].to_s)
end
=======
>>>>>>> 6ef0a20875a40394cc0be7b34162c3238be46106

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




end
