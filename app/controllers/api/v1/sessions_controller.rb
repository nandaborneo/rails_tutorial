class Api::V1::SessionController < Devise::SessionController

    def create
        
    end

    private
    def sign_in_params
        params.require(:sign_in).permit(:email, :password)
    end
    
end