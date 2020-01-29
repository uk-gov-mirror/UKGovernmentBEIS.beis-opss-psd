RSpec.shared_context "load user" do
  let(:user)              { double(User) }
  let(:user_service)      { instance_double(CreateUserFromAuth, user: user) }
  let(:omniauth_response) { double }

  before do
    allow(CreateUserFromAuth)
      .to receive(:new).with(omniauth_response).and_return(user_service)
  end
end
