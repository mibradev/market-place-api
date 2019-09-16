module Authenticatable
  def current_user
    return @current_user if @current_user.present?

    token = request.headers["Authorization"]
    return unless token.present?

    user_id = JsonWebToken.decode(token)["user_id"]
    return unless user_id.present?

    @current_user = User.find_by_id(user_id)
  end
end
