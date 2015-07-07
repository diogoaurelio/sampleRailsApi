require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before { @user = FactoryGirl.build(:user) }
  subject { @user }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }
end

describe "example validation if email present - result: " do
  before { @user.email = " " }
  it { should_not be_valid }
end
# after installing gem "shoulda-matchers"
describe "email & password confirmations: " do
  #before { @user.email = " " }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }
end
