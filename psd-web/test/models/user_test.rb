require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    mock_out_keycloak_and_notify
    @user = User.find_by(name: "Test User_one")
    @user_four = User.find_by(name: "Test User_four")

    mock_user_as_non_opss(@user)
    mock_user_as_opss(@user_four)
  end

  test "display name includes user's organisation for non-org-member viewers" do
    sign_in_as @user_four
    assert_equal "Test User_one (Organisation 1)", @user.display_name

    sign_in_as @user
    assert_equal "Test User_four (Office of Product Safety and Standards)", @user_four.display_name
  end

  test "assignee short name is full name when user's organisation is same as that of current user" do
    sign_in_as @user
    assert_equal "Test User_one", @user.assignee_short_name
  end

  test "assignee short name is organisation when user's organisation is different to that of current user" do
    assert_equal "Office of Product Safety and Standards", @user_four.assignee_short_name
  end

  test "don't load non-psd users" do
    assert_not User.find_by(name: "Test Non_psd_user")
  end
end
