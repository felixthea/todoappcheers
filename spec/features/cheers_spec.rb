require 'spec_helper'
require 'debugger'

describe Cheer do
  describe "logged in" do
    let(:user) { User.create(username: "hello_world4", password: "123456")}
    let(:other_user) { User.create(username: "hello_world5", password: "123456")}

    it "should show the number of cheers to give" do
      factory_sign_in(user.username, user.password)
      visit user_url(user)
      expect(page).to have_content("10 cheers left")
    end

    context "cheer giving/receiving" do

      before(:each) do
        factory_sign_in(user.username, user.password)
        goal = user.goals.create(name: "Goal to cheer")
        click_button "Sign Out"

        factory_sign_in(other_user.username, other_user.password)
        visit user_url(user)

        click_button "Cheer!"
      end

      it "should be able to give a cheer" do
        expect(page).to have_content("9 cheers left")
        expect(page).to have_content("1 goal cheer")
      end

      it "should show the number of cheers received" do
        click_button "Sign Out"
        factory_sign_in(user.username, user.password)

        expect(page).to have_content("1 cheer received")
      end

      it "should not show cheer button when there are 0 cheers to give" do
        9.times do
          click_button "Cheer!"
        end

        expect(page).to have_content("0 cheers left")
        expect(page).to_not have_button('Cheer')
      end
    end
  end

  describe "logged out" do
    let(:user) { User.create(username: "hello_world4", password: "123456")}
    let(:other_user) { User.create(username: "hello_world5", password: "123456")}

    before(:each) do
      visit user_url(user)
    end

    it "should not see a cheer button" do
      expect(page).to_not have_button('Cheer')
    end

    it "should not see cheers left" do
      expect(page).to_not have_content("cheers left")
    end

    it "should see cheer numbers next to goal" do
      factory_sign_in(user.username, user.password)
      goal = user.goals.create(name: "Goal to cheer")
      click_button "Sign Out"

      factory_sign_in(other_user.username, other_user.password)
      visit user_url(user)

      click_button "Cheer!"
      click_button "Sign Out"

      visit user_url(user)
      expect(page).to have_content("1 goal cheer")
    end
  end
end
