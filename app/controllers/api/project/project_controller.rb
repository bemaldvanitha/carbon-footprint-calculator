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

  def get_all_projects
    projects = Project.includes(:category, :location, :certification_type).all()
    all_project_list = []

    projects.each do |project|
      project_data = {
        id: project.id,
        image: generate_presigned_url_for_images(project.featuredImage),
        title: project.title,
        certification_type: project.certification_type.certification_type,
        location: project.location.title
      }
      all_project_list << project_data
    end

    render json: {
      status: 'SUCCESS',
      message: 'All projects!',
      data: all_project_list
    }, status: :ok
  end

  def get_projects_by_category
    projects = Project.includes(:category, :location, :certification_type).where(:category_id => params[:id])
    all_projects_list = []

    projects.each do |project|
      project_data = {
        id: project.id,
        image: generate_presigned_url_for_images(project.featuredImage),
        title: project.title,
        certification_type: project.certification_type.certification_type,
        location: project.location.title
      }
      all_projects_list << project_data
    end

    render json: {
      status: 'SUCCESS',
      message: 'All project by category!',
      data: all_projects_list
    }, status: :ok
  end

  def get_single_project
    project = Project.includes(:certification_type, :location, :technical_documents, :project_images, :project_developer,
                               :project_design_validator, :credits_validator).find_by(:id => params[:id])
    if project.nil?
      render json: {
        status: 'ERROR',
        message: 'No project to this id',
        data: {}
      }, status: :not_found
    else
      all_project_images = []
      all_project_technical_docs = []

      project.project_images.each do |project_img|
        all_project_images << generate_presigned_url_for_images(project_img.image)
      end

      project.technical_documents.each do |technical_doc|
        all_project_technical_docs << generate_presigned_url_for_documents(technical_doc.document)
      end

      single_project = {
        id: project.id,
        title: project.title,
        featured_image: generate_presigned_url_for_images(project.featuredImage),
        summary: project.summary,
        how_it_work: project.howItWork,
        active_since: project.activeSince,
        read_more: project.readMore,
        total_carbon_credits: project.totalCarbonCredits,
        allocated_carbon_credit: project.allocatedCarbonCredits,
        offset_rate: project.offsetRate,
        certification_type: project.certification_type.certification_type,
        location: {
          title: project.location.title,
          description: project.location.description,
          latitude: project.location.latitude,
          longitude: project.location.longitude
        },
        project_developer: {
          name: project.project_developer.name,
          organization: project.project_developer.organization
        },
        project_design_validator: {
          name: project.project_design_validator.name,
          organization: project.project_design_validator.organization
        },
        credits_validator: {
          name: project.credits_validator.name,
          organization: project.credits_validator.organization
        },
        project_images: all_project_images,
        technical_documents: all_project_technical_docs
      }

      render json: {
        status: 'SUCCESS',
        message: 'Single Project Fetched Successful!',
        data: single_project
      }, status: :ok
    end
  end

  def update_project
    if user_type == 'Admin'
      project = Project.find(params[:id])
      if project.nil?
        render json: {
          status: 'ERROR',
          message: 'No project to this id',
          data: {}
        }, status: :not_found
      else
        if project_update_params[:title]
          project.title = project_update_params[:title]
        end

        if project_update_params[:featured_image]
          project.featuredImage = project_update_params[:featured_image]
        end

        if project_update_params[:summary]
          project.summary = project_update_params[:summary]
        end

        if project_update_params[:how_it_work]
          project.howItWork = project_update_params[:how_it_work]
        end

        if project_update_params[:read_more]
          project.readMore = project_update_params[:read_more]
        end

        if params[:location].present?
          project.location.update(project_update_params[:location])
        end

        project_update_params[:technical_documents].each do |document|
          doc = TechnicalDocument.create(:document => document, :project_id => project.id)
        end

        project_update_params[:project_images].each do |image|
          img = ProjectImage.create(:image => image, :project_id => project.id)
        end

        if project.save
          render json: {
            status: 'SUCCESS',
            message: 'Project updated successfully',
            data: project
          }, status: :ok
        else
          render json: {
            status: 'ERROR',
            message: 'Project update failed'
          }, status: :bad_request
        end
      end
    else
      render json: {
        status: 'UNAUTHORIZED',
        message: 'Only Admin users have this function'
      }, status: :forbidden
    end
  end

  private

  def project_update_params
    params.permit(:title, :featured_image, :summary, :how_it_work, :read_more, project_images: [],
                  location: [:title, :description, :latitude, :longitude], technical_documents: [],)
  end

  def project_params
    params.permit(
      :category_id, :title, :featured_image, :summary, :how_it_work, :active_since, :read_more, :total_carbon_credits, :offset_rate,
      :certification_type, project_images: [], location: [:title, :description, :latitude, :longitude], technical_documents: [],
      project_developer: [:name, :organization], project_design_validator: [:name, :organization], credit_validator: [:name, :organization]
    )
  end

  def generate_presigned_url_for_images(image)
    bucket_name = 'carbonfootprint123'
    object_path = 'project/images/' + image
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(bucket_name).object(object_path)
    obj.presigned_url(:get, expires_in: 3600)
  end

  def generate_presigned_url_for_documents(document)
    bucket_name = 'carbonfootprint123'
    object_path = 'project/documents/' + document
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(bucket_name).object(object_path)
    obj.presigned_url(:get, expires_in: 3600)
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
