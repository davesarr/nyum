#Class Zomato
#  include HTTParty
#  default_params :output => 'json'
#
#  format :json
#
#  def initialize 
#    @options = {
#        query: { 'res_id': '16774318' },
#        headers: { 'user-key': ENV["ZOMATO_API_KEY"] }
#      }
#  end
#
#  def self.restaurant_by_id
#    get("https://developers.zomato.com/api/v2.1/restaurant",
#      @options
#  )
#  end
#end
