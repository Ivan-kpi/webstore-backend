class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /api/users
    def index
        users = User.where.not(id: current_user.id)
        render json: users
    end

  # GET /api/users/:id
    def show
        render json: @user
    end

  # POST /api/users
    def create
        user = User.new(user_params)

        if user.save
        render json: user, status: :created
        else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

  # PATCH/PUT /api/users/:id
    def update
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: { error: "Update failed", details: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

  # DELETE /api/users/:id
    def destroy
        @user.destroy
        head :no_content
    end

    def me
        render json: current_user
    end

    private

    def check_admin
        unless current_user.role == "admin"
        render json: { error: "Forbidden" }, status: :forbidden
        end
    end

    def set_user
        @user = User.find(params[:id])
    end

    # Дозволені параметри
    def user_params
        params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :role
        )
    end
end

