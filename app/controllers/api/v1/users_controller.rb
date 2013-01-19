module Api
  module V1
    class UsersController <  ApiController
      def index
        render json: current_user
      end
    end
  end
end
