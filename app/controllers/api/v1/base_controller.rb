module Api
  module V1
    class BaseController < ActionController::API
      include Pundit::Authorization

      before_action :authenticate_request

      # Rescue for common errors
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      # --- JWT auth ---
      def authenticate_request
        header = request.headers["Authorization"]
        token = header.split(" ").last if header.present?

        if token.present?
          begin
            secret = Rails.application.credentials.jwt_secret
            decoded = JWT.decode(token, secret, true, algorithm: "HS256")
            @current_user = User.find(decoded[0]["user_id"])
          rescue JWT::ExpiredSignature
            render_error("Token expired", :unauthorized)
          rescue JWT::DecodeError
            render_error("Invalid token", :unauthorized)
          end
        else
          render_error("Missing token", :unauthorized)
        end
      end

      # Pundit `current_user`
      def pundit_user
        @current_user
      end

      # --- Response Helpers ---
      def render_success(data, status = :ok)
        render json: { status: "success", data: data }, status: status
      end

      def render_error(message, status = :unprocessable_entity)
        render json: { status: "error", message: message }, status: status
      end

      # --- Errors ---
      def record_not_found(error)
        render_error(error.message, :not_found)
      end

      def parameter_missing(error)
        render_error(error.message, :bad_request)
      end

      def user_not_authorized
        render_error("Operation not allowed", :forbidden)
      end
    end
  end
end
