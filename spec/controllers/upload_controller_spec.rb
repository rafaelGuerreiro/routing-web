require 'rails_helper'

describe UploadController, type: :controller do
  context 'user is signed in' do
    sign_in_user

    describe 'GET new' do
      it 'renders new.html.erb when user is signed in' do
        get :new

        expect(response.ok?).to be_truthy
        expect(response.redirect?).to be_falsy
        expect(response.redirect_url).to be_nil
      end
    end
  end

  context 'user is signed out' do
    describe 'GET new' do
      it 'redirects to about_url when user is not signed in' do
        get :new

        expect(response.ok?).to be_falsy
        expect(response.redirect?).to be_truthy

        expect(response.redirect_url).to eq(about_url)
      end
    end
  end
end
