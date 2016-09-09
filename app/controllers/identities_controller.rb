class IdentitiesController < ApplicationController
  layout 'application', :except => :show


    def edit
        @identity = Identity.find(params[:id])
    end


    def show
      unless ActiveRecord::RecordNotFound
      @identity = Identity.find(params[:id])
      else
      @user= User.find(params[:id])
      end
      @likes=[]
      votes= Vote.where(voter_id: params[:id])
      votes.each do |vote|
        @likes+=Restaurant.where(id: vote.votable_id)
      end
      render layout: 'user_profile'
    end

    def update
        identity = params['identity']
        Identity.update( id: params[:id],
                name: identity[:name],
                nickname: identity[:nickname],
                phone: identity[:phone]
        )
        redirect_to (:back)
    end


private
    def updated_params
        params.require(:identity).permit(:name, :nickname, :phone)
    end

end
