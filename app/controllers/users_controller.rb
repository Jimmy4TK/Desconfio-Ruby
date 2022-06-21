class UsersController < ApplicationController
    before_action :set_user, only:[:change_password]
    before_action :check_token, only:[:change_password]

    def create
        if params[:user][:password] == params[:confirm_password]
            @user=User.create(user_params)
            user_save
        else
            render status:400, json:{message: {path: "confirm_password",message: "Password and confirm password don't match"}}
        end
    end

    def login
        @user=User.find_by(email: params[:email])
        if @user.blank?
            render status:400, json:{message: {path: "email",message: "User doesn't exist"}}
        else
            if @user.authenticate(params[:password])
                render status:200,json:{
                    id: @user.id,
                    email: @user.email,
                    name: @user.name,
                    token: @user.token
                }
            else
                render status:400, json:{message: {path: "password",message: "Password incorrect"}}
            end
        end
    end

    def change_password
        if @user.authenticate(params[:password])
            if params[:new_password]==params[:confirm_password]
                @user.password=params[:password]
                user_save
            else
                render status:400,json:{message: {path: "confirm_password",message: "Password and confirm password don't match"}}
            end
        else
            render status:400, json:{message: {path: "password",message: "Password incorrect"}}
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end

    def render_errors_response
        render status:400, json:{ message: {path: @user.errors.attribute_names[0],message: @user.errors.full_messages[0]} }
    end

    def check_token
        if request.headers["Authorization"] != "Bearer #{@user.token}"
            render status:400,json:{error: "Token's incorrect"}
            false
        end
    end

    def set_user
        @user=User.find_by(id: params[:id])
        if @user.blank?
            render status:400,json:{error: "User doesn't exist"}
            false
        end
    end

    def user_save
        if @user.save
            render status:200, json:{
                id: @user.id,
                email: @user.email,
                name: @user.name,
                token: @user.token
            }
        else
            render_errors_response
        end
    end
end
