class Api::V1::UsersController < ApplicationController

    def facebook
        if params[:facebook_access_token]
            Koala.http_service.http_options = {:ssl => { :verify_mode => OpenSSL::SSL::VERIFY_NONE }} 
            graph = Koala::Facebook::API.new params[:facebook_access_token]
            user_data = graph.get_object('me?fields=name,email,id,picture')

            user = User.find_by email: user_data["email"]
            if user
                user.generate_new_authentication_token
                json_response "Info Login", true, {user: user}, :ok
            else
                user = User.new(email: user_data["email"],
                                uid: user_data["id"],
                                provider: "facebook",
                                image: user_data["image"],
                                password: Devise.friendly_token[0,20])

                user.authentication_token = User.generate_unique_secure_token

                if user.save
                    json_response "Login Facebook Success", true, {user: user}, :ok
                else
                    json_response "Error Login Facebook",false, {}, :unprocessable_entity
                end
            end
        else
            json_response "Token akses facebook tidak ditemukan", false, {}, :unprocessable_entity
        end
    end
    
end