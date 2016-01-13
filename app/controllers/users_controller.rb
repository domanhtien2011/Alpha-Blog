class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to our blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Updated your profile successfully'
      redirect_to :back
    else
      render 'edit'
    end
  end

  def destroy
    set_user
    @user.destroy
    flash[:success] = 'User and all articles created by user are deleted.'
    redirect_to(users_url)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = 'You can only edit your account!'
      redirect_to(root_url)
    end
  end

  def require_admin
    if logged_in? && !current_user.admin?
      flash[:danger] = 'Only admin user can perform this action'
      redirect_to(root_url)
    end
  end
end
