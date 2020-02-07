require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "display name includes user's organisation for non-org-member viewers" do
    assert_equal "Yann (Southampton Council)", users(:southampton).display_name(other_user: users(:opss))

    assert_equal "Slavosh (Office for Product Safety and Standards)", users(:opss).display_name(other_user: users(:southampton))
  end

  test "assignee short name is full name when user's organisation is same as that of current user" do
    # sign_in_as @user
    assert_equal "Yann", users(:southampton).assignee_short_name(other_user: users(:southampton_steve))
  end

  test "assignee short name is organisation when user's organisation is different to that of current user" do
    assert_equal "Office for Product Safety and Standards", users(:opss).assignee_short_name(other_user: users(:southampton))
  end
end
