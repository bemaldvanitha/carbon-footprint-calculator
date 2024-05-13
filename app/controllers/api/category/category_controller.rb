class Api::Category::CategoryController < ApplicationController
  before_action :authorize_request
  attr_reader :user_id, :user_type

  def create_category
    if user_type == "Admin"
      category = Category.new(:title => category_params[:title], :image => category_params[:image])
      if category.save
        render json: {
          status: 'SUCCESS',
          message: 'Category created'
        }, status: :ok
      else
        render json: {
          status: 'ERROR',
          message: 'Category not created'
        }, status: :bad_request
      end
    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users have this function'
      }, status: :forbidden
    end
  end

  private

  def category_params
    params.permit(:title, :image)
  end

  def authorize_request
    authorization_data = AuthorizationService.authorize_request(request)
    if authorization_data[:user_id].present?
      @user_id = authorization_data[:user_id]
      @email = authorization_data[:email]
      @user_type = authorization_data[:user_type]

    else
      render json: { status: 'UNAUTHORIZED', message: authorization_data[:error] }, status: :unauthorized
    end
  end
end
