require 'spec_helper'

describe UsersController do

  describe "POST create" do
    let(:user) { mock_model(User).as_null_object }

    before do
      User.stub(:new).and_return(user)
    end

    context "when user saved" do
      let(:provider) { 'foo' }
      let(:uid) { '123' }

      before do
        session[:provider] = provider
        session[:uid] = uid

        user.stub!(:save => true)
      end

      it "assigns provider and uid" do
        user.should_receive(:provider=).with(provider).and_return(true)
        user.should_receive(:uid=).with(uid).and_return(true)

        post :create
      end

      it "sets current_user" do
        post :create
        @controller.current_user.should_not be_nil
      end

      it "clears user session data" do
        post :create

        session[:provider].should be_nil
        session[:uid].should be_nil
      end

      it "redirects back" do
        post :create
        should redirect_to(root_url)
      end

    end

    context "when not valid data" do
      before do
        user.stub!(:save => false)
      end

      it "renders user/new" do
        post :create
        should render_template('users/new')
      end
    end
  end
end
