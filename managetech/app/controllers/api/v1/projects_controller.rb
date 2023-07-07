class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @projects = Project.all
    @projects = @projects.search(filter_params[:q]) if filter_params[:q].present?
    # Filter projects by company id
    @projects = @projects.where(company_id: filter_params[:company_id]) if filter_params[:company_id].present?
    @projects = @projects.where(client_company_id: filter_params[:client_company_id]) if filter_params[:client_company_id].present?
    @projects = @projects.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @projects = @projects.paginate(page: page_num, per_page: items_per_page)
    render json: @projects, meta: { pagination: pagination_dict(@projects) }, status: :ok
  end

  def reports
    data = []
    12.times do |i|
      end_of_month = i.months.ago.end_of_month
      projects = Project.where("created_at <= ?", end_of_month)
      count = projects.exists? ? projects.count() : 0
      data << { value: count, date: end_of_month }
    end
    render json: { project_reports: data }
  end

  def show
    render json: @project, serializer: ProjectDetailSerializer, status: :ok
  end

  def new
    @project = Project.new
    @project.teams.build
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      render json: @project, status: :created
    else
      render json: { errors: @project.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @project.update(project_params)
      render json: { errors: @project.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @project, status: :ok
    end
  end

  def destroy
    @project.project_status_inactive!
    unless @project.destroy
      render json: { errors: @project.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @project, status: :ok
    end
  end

  def project_phases
    render json: Project.project_phases, status: :ok
  end

  def project_statuses
    render json: Project.project_statuses, status: :ok
  end

  def current_projects
    @current_projects = Project.project_status_active
    render json: @current_projects, status: :ok
  end

  private

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Project not found" }, status: :not_found
  end

  def project_params
    params.require(:project).permit(:project_name, :company_id, :client_company_id, :project_phase, :project_status, :sprint_week, :current_sprint_order, :backlog_sprint_id)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : Project.per_page
  end

  def page_num
    filter_params[:options] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:page] : 1
  end

  def orderby_name
    filter_params[:options] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_by].first : nil
  end

  def orderby_desc
    desc = filter_params[:options] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_desc].first : true
    return desc == true ? "DESC" : "ASC"
  end

  def filter_params
    params.slice(:q, :options, :company_id, :client_company_id)
  end
end
