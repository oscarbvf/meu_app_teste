module Api
  module V1
    class AuthController < BaseController
      # Skip token to login
      skip_before_action :authenticate_request, only: [ :login ]

      def login
        user = User.find_for_authentication(email: params[:email])

        if user&.valid_password?(params[:password])
          payload = { user_id: user.id, exp: 24.hours.from_now.to_i }

          secret = Rails.application.credentials.jwt_secret
          token = JWT.encode(payload, secret, "HS256")

          render_success({ token: token })
        else
          render_error("Invalid email or password", :unauthorized)
        end
      end
    end
  end
end
