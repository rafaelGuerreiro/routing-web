require 'rails_helper'

describe User, type: :model do
  context 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  context 'validations' do
    before { create(:user) }

    context 'presence' do
      it { should validate_presence_of :email }
      it { should validate_presence_of :encrypted_password }
    end

    context 'uniqueness' do
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end

  context 'devise' do
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