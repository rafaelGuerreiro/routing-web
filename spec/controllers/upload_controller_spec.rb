require 'rails_helper'

describe UploadController, type: :controller do
  context 'when user is signed in' do
    sign_in_user

    describe 'GET new' do
      before(:each) { get :new }

      it { is_expected.to be_ok }
      it { is_expected.to render_template(:new) }
    end

    describe 'POST create' do
      before(:each) { post :create }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  context 'when user is not signed in' do
    describe 'GET new' do
      before(:each) { get :new }

      it { is_expected.to_not be_ok }
      it { is_expected.to redirect_to(about_url) }
    end

    describe 'POST create' do
      before(:each) { post :create }

      it { is_expected.to_not be_ok }
      it { is_expected.to redirect_to(new_user_session_url) }
    end
  end
end
