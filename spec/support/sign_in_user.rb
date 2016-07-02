module SignInUser
  def sign_in_user(user = :user)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[user]

      obj = FactoryGirl.create(user)
      obj.confirm

      sign_in(user, obj)
    end
  end
end
