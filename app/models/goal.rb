class Goal < ActiveRecord::Base
  attr_accessible :name, :completed, :personal

  validates :name, :user, presence: true

  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id,
    inverse_of: :goals
  )

  def self.find_public_goals_by_user(user)
    Goal.find_all_by_user_id_and_personal(user.id,false)
  end

end
