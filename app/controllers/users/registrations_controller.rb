class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

    def sign_up(resource_name, resource)
    # НЕ викликаємо super → не створюємо сесію
    end

    private

    def sign_up_params
        params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :password
        )
    end

    def account_update_params
        params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :current_password
        )
    end

    def respond_with(resource, _opts = {})
        if resource.persisted?
        render json: {
            message: "Account created",
            user: resource
        }, status: :ok
        else
        render json: {
            errors: resource.errors.full_messages
        }, status: :unprocessable_entity
        end
  end
end

