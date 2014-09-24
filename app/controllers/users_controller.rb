class UsersController < ApplicationController
  before_action :user, only: [:show]

  # GET /users/1.json
  def show
    @user = user

    render json: @user
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def user
    @user = User.find(params[:id])
  end
end