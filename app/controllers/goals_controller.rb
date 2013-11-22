class GoalsController < ApplicationController
  before_filter :ensure_logged_in, except: [:show, :index]

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = current_user.goals.new(params[:goal])
    if @goal.save
      redirect_to @goal
    else
      flash[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find(params[:id])

    render :show
  end

  def edit
    @goal = Goal.find(params[:id])

    render :edit
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update_attributes(params[:goal])
      redirect_to @goal
    else
      flash[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    Goal.find(params[:id]).destroy
    redirect_to current_user
  end
end
