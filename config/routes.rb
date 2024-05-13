Rails.application.routes.draw do
  namespace 'api' do
    namespace 'auth' do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'
    end
    namespace 'calculator' do
      post 'calculate', to: 'carbon_calculator#calculate'
    end
    namespace 'file' do
      post 'generate_url', to: 'file#generate_pre_sign_url'
    end
    namespace 'category' do
      post 'create', to: 'category#create_category'
      get '', to: 'category#get_categories'
      delete ':id', to: 'category#delete_category'
    end
  end
end
