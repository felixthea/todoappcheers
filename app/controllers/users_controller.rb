class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def show
    @user = User.find(params[:id])
    if logged_in? && (@user.id == current_user.id)
      @goals = @user.goals
    else
      @goals = Goal.find_public_goals_by_user(@user)
    end
    render :show
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      log_in!(@user)
      redirect_to @user
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def completed
    @user = User.find(params[:user_id])
    if logged_in? && (@user.id == current_user.id)
      @goals = @user.goals
    else
      @goals = Goal.find_public_goals_by_user(@user)
    end
    render :completed
  end
end