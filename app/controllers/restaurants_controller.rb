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
        @responses.businesses.each do |response|
          if Restaurant.find_by_yelp_id(response.id)==nil
            then Restaurant.create(yelp_id: response.id, name: response.name, image_url: response.image_url, address:response.location.display_address.to_s.gsub(/[\[\]"]/, ''), phone: response.phone, rating: ((response.rating-1)*(99/4)+1).to_i)
          end
        end
      end
    end


  def show
    @current_restaurant = Restaurant.find_by_yelp_id(params[:id])
  end

  def upvote
    byebug
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
