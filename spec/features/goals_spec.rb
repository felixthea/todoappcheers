require 'spec_helper'

describe "logged in user" do

  let(:user) { User.create(username: "hello_world3", password: "123456") }

  before(:each) do
    factory_sign_in(user.username,user.password)
  end

  it "has a show page" do
    visit user_url(user)
    expect(page).to have_content(user.username)
  end

  it "can create a goal" do
    visit new_goal_url
    fill_in 'Name', :with => "Finish this project"
    choose 'Private'
    click_on "Add Goal"

    expect(page).to have_content("Finish this project")
  end

  it "sees private and public incomplete goals" do
    visit new_goal_url
    fill_in 'Name', :with => "Private Goal"
    choose 'Private'
    click_on "Add Goal"

    visit new_goal_url
    fill_in 'Name', :with => "Public Goal"
    choose 'Public'
    click_on "Add Goal"

    visit user_url(user)
    expect(page).to have_content("Private Goal")
    expect(page).to have_content("Public Goal")
  end

  it "can update its own goals" do
    goal = user.goals.create(personal: false, name: "Public incomplete goal")

    visit goal_url(goal)
    click_on "Edit Goal"

    fill_in 'Name', :with => "Changed name"
    choose "Private"
    check "Completed"
    click_on "Update Goal"

    visit goal_url(goal)
    expect(page).to have_content("Changed name")
    expect(page).to have_content("Private")
    expect(page).to have_content("Completed")
  end

  it "sees own private and public completed goals" do
    goal = user.goals.create(personal: false,
      name: "Private goal", completed: true)
    goal = user.goals.create(personal: true,
      name: "Public goal", completed: true)

    visit user_completed_url(user)
    expect(page).to have_content("Private goal")
    expect(page).to have_content("Public goal")
  end

  it "can delete own goals" do
    goal = user.goals.create(personal: false, name: "Goal to be deleted")

    visit goal_url(goal)
    click_button "Delete"

    visit user_url(user)
    expect(page).to_not have_content("Goal to be deleted")
  end
end

describe "logged out user" do

  context "visit user's goals page" do
    before(:each) do
      user = create_user_with_goals
      visit user_url(user)
    end

    it "shows public incomplete goals" do
      expect(page).to have_content("Public incomplete goal")
    end

    it "does not show private goals" do
      expect(page).to_not have_content("Private incomplete goal")
      expect(page).to_not have_content("Private completed goal")
    end

    it "does not show completed goals" do
      expect(page).to_not have_content("Public completed goal")
    end

  end

  context "visit user's completed goals page" do
    before(:each) do
      user = create_user_with_goals
      visit user_completed_url(user)
    end

    it "show completed goals" do
      expect(page).to have_content("Public completed goal")
    end

    it "does not show private goals" do
      expect(page).to_not have_content("Private completed goal")
      expect(page).to_not have_content("Private incomplete goal")
    end

    it "does not show incompleted goals" do
      expect(page).to_not have_content("Public incomplete goal")
    end
  end

  it "cannot create a goal" do
    visit new_goal_url
    expect(page).to have_button("Log In")
  end
end