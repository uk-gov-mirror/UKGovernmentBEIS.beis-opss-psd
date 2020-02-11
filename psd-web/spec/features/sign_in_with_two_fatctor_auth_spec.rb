require "rails_helper"

RSpec.feature "Sign in with two factor auth", :with_elasticsearch, :with_stubbed_mailer do

  it "allows user to sign in" do

    fill_in "authentication[code]", with: "some_code"
    click_on "Continue"

    expect(page).to have_css("h2")
  end
end
