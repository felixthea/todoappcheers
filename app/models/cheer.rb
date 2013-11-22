class Cheer < ActiveRecord::Base
  attr_accessible :user_id, :goal_id

  validates :user_id, :goal_id, presence: true

  belongs_to(
    :cheer_giver,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id,
    inverse_of: :cheers_given
  )

  belongs_to(
    :goal,
    class_name: "Goal",
    foreign_key: :goal_id,
    primary_key: :id,
    inverse_of: :cheers
  )

  def self.users_cheers_received(user)
    sum = 0
    user.goals.each do |goal|
      sum += Cheer.goals_cheers_received(goal)
    end

    sum
  end

  def self.goals_cheers_received(goal)
    Cheer.find_all_by_goal_id(goal.id).size
  end

  def self.cheers_left(user)
    user_cheers = Cheer.find_all_by_user_id(user.id)
    10 - user_cheers.count { |cheer| cheer.created_at > Date.today }
  end

  def self.any_cheers_left?(user)
    cheers_left(user) > 0 ? true : false
  end
end
