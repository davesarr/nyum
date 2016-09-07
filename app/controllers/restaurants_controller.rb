class RestaurantsController < ApplicationController
  def index

    location = params[:search]
    term = params[:term]
    sort = params[:sort].to_i
    params = {limit: 20,
        sort: sort,
        term: term
    }
    if location.present?
        @responses = Yelp.client.search(location, params)
    end
  end
  def show
    #zomato(restaurant_name)
  end

  def upvote
    puts params
  @restaurant = Restaurant.find(params[:id].to_i)
  @restaurant.upvote_by current_user
  redirect_to :back
end

def downvote
  @restaurant = Restaurant.find(params[:id].to_i)
  @restaurant.downvote_by current_user
  redirect_to :back
end

end
