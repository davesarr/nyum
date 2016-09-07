Class Zomato
  require 'httparty'
  default_params :output => 'json'
  format :json

  def self.restaurant_by_id(restaurant_id)
    get("https://developers.zomato.com/api/v2.1/restaurant",
        :query => {:res_id => restaurant_id },
        :header =>{:user_key => ENV["ZOMATO_API_KEY"]})
  end
end
