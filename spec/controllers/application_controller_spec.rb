describe ApplicationController, type: :controller do
  it 'prevents CSRF attacks with exception' do
    strategy = ActionController::RequestForgeryProtection::ProtectionMethods::Exception
    expect(subject.forgery_protection_strategy).to eq(strategy)
  end
end
