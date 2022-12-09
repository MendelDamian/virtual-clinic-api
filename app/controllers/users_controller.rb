class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    render json: { data: current_user }
  end
end
