class HomeController < ApplicationController
    def index

<<<<<<< HEAD
=======
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
>>>>>>> 981dfd5d075014506790683466a8a85c3aa7ed18
    end



end
