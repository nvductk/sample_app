class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def show
    @user = User.find_by id: params[:id]
    if @user.nil?
      render file: "/public/404", layout: false, status: 404
    else
      @user
    end
    @microposts = @user.microposts.paginate page: params[:page]
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t (".Please_check")
      redirect_to root_url
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
    if @user.nil?
      render file: "/public/404", layout: false, status: 404
    else
      @user
    end
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update_attributes user_params
      flash[:success] = t(".Profile")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t(".User")
    redirect_to users_url
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t(".Please")
      redirect_to login_url
    end
  end
    # Confirms the correct user.
  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user == current_user
  end

  def following
    @title = t(".following")
    @user = User.find_by id: params[:id]
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t(".followers")
    @user = User.find_by id: params[:id]
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
