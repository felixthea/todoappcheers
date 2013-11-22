require 'spec_helper'

describe "the signup process" do

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "New User"
  end

  describe "signing up a user" do
    before(:each) do
      sign_up_as_hello_world
    end

    it "shows username on the homepage after signup" do
      expect(page).to have_content "hello_world"
    end


  end

end

describe "logging in" do
  before(:each) do
    sign_in
  end

  it "shows username on the homepage after login" do
    expect(page).to have_content "hello_world"
  end

end

describe "logging out" do

  it "begins with logged out state" do
    visit new_session_url
    expect(page).to have_content "Sign In"
  end

  it "doesn't show username on the homepage after logout" do
    sign_in
    click_on "Sign Out"
    expect(page).not_to have_content "hello_world"
  end

end
