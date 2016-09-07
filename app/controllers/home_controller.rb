class HomeController < ApplicationController
    def index
      api_data = Zomato::restaurant_by_id(11534235)
      puts api_data

    end

    def show
        location = params[:search]
        limit = params[:limit].to_i
        params = {limit: limit}
        if location.present?
            @responses = Yelp.client.search(location, params)
        end
    end
end
