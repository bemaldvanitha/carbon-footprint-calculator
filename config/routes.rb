Rails.application.routes.draw do
  namespace 'api' do
    namespace 'auth' do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'
    end
    namespace 'calculator' do
      post 'calculate', to: 'carbon_calculator#calculate'
    end
  end
end
