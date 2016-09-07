class HomeController < ApplicationController

  def index
  end

    def show
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
end
