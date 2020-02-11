require "rails_helper"

RSspec.feature "Sign in with two factor auth" do

  it "allows user to sign in" do
    sign_in

    fill_in "authentication[code]", with: "some_code"
    click_on "Continue"

    expect(page).to have_css("h2")
  end
end
