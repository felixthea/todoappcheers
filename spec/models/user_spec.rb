require 'spec_helper'

describe User do
  let(:incomplete_user) { FactoryGirl.build(:user) }

  it "validates presence of username" do
    expect(incomplete_user).to have(1).error_on(:username)
  end

  it "validates presence of password digest" do
    expect(incomplete_user).to have(1).error_on(:password_digest)
  end

  it "validates the length of password is greater than 6" do
      expect(incomplete_user).to have(1).error_on(:password)
  end

  it { should allow_mass_assignment_of(:username) }
  it { should allow_mass_assignment_of(:password) }

  it "should not store the password" do
    user = FactoryGirl.create(:complete_user)
    User.find(user.id).password.should be_nil
  end
end

