class HomeController < ApplicationController
    def index

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
