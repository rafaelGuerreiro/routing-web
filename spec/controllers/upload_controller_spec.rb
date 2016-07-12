describe UploadController, type: :controller do
  context 'when user is signed in' do
    sign_in_user

    describe 'GET new' do
      before { get :new }
      subject { response }

      it { is_expected.to be_ok }
      it { is_expected.to render_template(:new) }
    end

    describe 'POST create' do
      before { post :create }
      subject { response }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  context 'when user is not signed in' do
    describe 'GET new' do
      before { get :new }
      subject { response }

      it { is_expected.to_not be_ok }
      it { is_expected.to redirect_to(page_url('about')) }
    end

    describe 'POST create' do
      before { post :create }
      subject { response }

      it { is_expected.to_not be_ok }
      it { is_expected.to redirect_to(new_user_session_url) }
    end
  end
end
