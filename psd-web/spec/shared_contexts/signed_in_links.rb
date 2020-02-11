RSpec.shared_context "signed in links" do
  def expect_header_to_have_signed_in_links
    expect(page).to have_link("Sign out")
    expect(page).to have_link("Your account")
    expect(page).not_to have_link("Sign in")
  end
end
