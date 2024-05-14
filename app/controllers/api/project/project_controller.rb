class Api::Project::ProjectController < ApplicationController
  before_action :authorize_request
  attr_reader :user_id, :user_type

  def create_project
    if user_type == 'Admin'
      certification_type = CertificationType.find_or_create_by(:certification_type => project_params[:certification_type])

      if project_params[:project_developer].present?
        project_developer = ProjectDeveloper.find_or_create_by(name: project_params[:project_developer][:name],
                                                               organization: project_params[:project_developer][:organization])
      end

      if project_params[:project_design_validator].present?
        project_design_validator = ProjectDesignValidator.find_or_create_by(name: project_params[:project_design_validator][:name], organization: project_params[:project_design_validator][:organization])
      end

      if project_params[:credit_validator].present?
        credit_validator = CreditsValidator.find_or_create_by(name: project_params[:credit_validator][:name], organization: project_params[:credit_validator][:organization])
      end

      location = Location.create(title: project_params[:location][:title], description: project_params[:location][:description],
                                 latitude: project_params[:location][:latitude], longitude: project_params[:location][:longitude])

      project = Project.create(:title => project_params[:title], :summary => project_params[:summary],
                               :activeSince => project_params[:active_since], :category_id => project_params[:category_id],
                               :howItWork => project_params[:how_it_work], :readMore => project_params[:read_more],
                               :featuredImage => project_params[:featured_image], :totalCarbonCredits => project_params[:total_carbon_credits],
                               :offsetRate => project_params[:offset_rate], :allocatedCarbonCredits => 0, :location_id => location.id,
                               :certification_type_id => certification_type.id, :credits_validator_id => credit_validator.id,
                               :project_design_validator_id => project_design_validator.id, :project_developer_id => project_developer.id)

      if project_params[:project_images].present?
        project_params[:project_images].each do |project_image|
          project_img = ProjectImage.create(:project_id => project.id, :image => project_image)
        end
      end

      if project_params[:technical_documents].present?
        project_params[:technical_documents].each do |technical_document|
          technical_doc = TechnicalDocument.create(:project_id => project.id, :document => technical_document)
        end
      end

      render json: {
        status: 'SUCCESS',
        message: 'Project created successfully',
        data: project
      }, status: :ok
    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users have this function'
      }, status: :forbidden
    end
  end

  private

  def project_params
    params.permit(
      :category_id, :title, :featured_image, :summary, :how_it_work, :active_since, :read_more, :total_carbon_credits, :offset_rate,
      :certification_type, project_images: [], location: [:title, :description, :latitude, :longitude], technical_documents: [],
      project_developer: [:name, :organization], project_design_validator: [:name, :organization], credit_validator: [:name, :organization]
    )
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
