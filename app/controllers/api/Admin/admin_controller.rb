class Api::Admin::AdminController < ApplicationController
  before_action :authorize_request
  attr_reader :user_id, :user_type

  def get_total_funding
    total_funds_received = 0
    if user_type == 'Admin'
      payments = Payment.all()

      payments.each do |payment|
        total_funds_received += payment.amount
      end

      render json: {
        status: 'SUCCESS',
        message: 'Total funding for projects',
        data: {
          total: total_funds_received
        }
      }, status: :ok
    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users have this function'
      }, status: :forbidden
    end
  end

  def funding_by_project
    if user_type == 'Admin'
      project_by_funding = []

      projects = Project.includes(:payments).all()

      projects.each do |project|
        total_project_payment = 0

        project.payments.each do |payment|
          total_project_payment += payment.amount
        end

        project_funding_item = {
          name: project.title,
          funding: total_project_payment
        }

        project_by_funding << project_funding_item
      end

      render json: {
        status: 'SUCCESS',
        message: 'Date fetched successfully',
        data: project_by_funding
      }, status: :ok
    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users have this function'
      }, status: :forbidden
    end
  end

  def funding_by_category
    if user_type == 'Admin'
      category_by_funding = []

      categories = Category.includes(projects: :payments).all

      categories.each do |category|
        total_category_payment = 0

        category.projects.each do |project|
          project.payments.each do |payment|
            total_category_payment += payment.amount
          end
        end

        category_funding_item = {
          name: category.title,
          funding: total_category_payment
        }

        category_by_funding << category_funding_item
      end

      render json: {
        status: 'SUCCESS',
        message: 'Date fetched successfully',
        data: category_by_funding
      }, status: :ok

    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users have this function'
      }, status: :forbidden
    end
  end

  private

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