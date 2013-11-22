class CheersController < ApplicationController
  def create
    goal = Goal.find(params[:goal_id])
    @cheer = Cheer.new(user_id: current_user.id, goal_id: goal.id)

    flash[:errors] = @cheer.errors.full_messages unless @cheer.save
    redirect_to user_url(goal.user)
  end
end
