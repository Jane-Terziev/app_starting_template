require 'rails_helper'

RSpec.describe "Visit Log In Path", type: :system do
  it "passes" do
    visit Authentication::Engine.routes.url_helpers.new_user_session_path
    expect(page).to have_content "Log In"
    expect(page).to have_content "Email"
    expect(page).to have_content "Password"
    expect(page).to have_content "Sign Up"
  end
end
