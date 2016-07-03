require 'rails_helper'

describe User, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'validations' do
    before { create(:user) }

    describe 'presence' do
      it { is_expected.to validate_presence_of :email }
      it { is_expected.to validate_presence_of :encrypted_password }
    end

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'devise modules' do
    let(:modules) do
      [
        :database_authenticatable, :registerable, :confirmable,
        :recoverable, :lockable, :rememberable, :trackable, :validatable
      ]
    end

    it 'should contain exactly the defined modules' do
      expect(User.devise_modules).to contain_exactly(*modules)
    end
  end
end
