class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
    if @user.nil?
      render file: "/public/404", layout: false, status: 404
    else
      @user
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
