class IdentitiesController < ApplicationController
    def edit
        @identity = Identity.find_by(params[:id])
    end

    def update
        identity = params['identity']
        Identity.update(params[:id],
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
