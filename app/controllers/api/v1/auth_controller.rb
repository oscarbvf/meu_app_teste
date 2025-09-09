module Api
  module V1
    class AuthController < BaseController
      # Skip token to login
      skip_before_action :authenticate_request, only: [ :login ]

      def login
        user = User.find_for_authentication(email: params[:email])

        if user&.valid_password?(params[:password])
          token = JwtService.encode(user_id: user.id)
          render_success({ token: token })
        else
          render_error("Invalid email or password", :unauthorized)
        end
      end
    end
  end
end
