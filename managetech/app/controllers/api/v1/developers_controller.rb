class Api::V1::DevelopersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_developer, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @developers = Developer.joins(:user).all
    @developers = @developers.search(filter_params[:q]) if filter_params[:q].present?
    @developers = @developers.where("users.company_id = ?", filter_params[:company_id]) if filter_params[:company_id].present?
    @developers = @developers.where("users.id = ?", filter_params[:user_id]) if filter_params[:user_id].present?
    @developers = @developers.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @developers = @developers.paginate(page: page_num, per_page: items_per_page)
    render json: @developers, meta: { pagination: pagination_dict(@developers) }, status: :ok
  end

  def reports
    data = []
    12.times do |i|
      end_of_month = i.months.ago.end_of_month
      developers = Developer.where("created_at <= ?", end_of_month)
      count = developers.exists? ? developers.count() : 0
      data << { value: count, date: end_of_month }
    end
    render json: { developer_reports: data }
  end

  def show
    render json: @developer, serializer: DeveloperDetailSerializer, status: :ok
  end

  def new
    @developer = Developer.new
    @developer.teams.build
  end

  def create
    developer_exists = Developer.joins(:user).where("users.company_id = ?", params[:company_id]).where(user_id: developer_params[:user_id]).exists?

    if !developer_exists
      @developer = Developer.new(developer_params)
      if @developer.save
        render json: @developer, status: :created
      else
        render json: { errors: @developer.errors.full_messages },
               status: :unprocessable_entity
      end
    else
      render json: { errors: "Developer exists already" }, status: :unprocessable_entity
    end
  end

  def update
    unless @developer.update(developer_params)
      render json: { errors: @developer.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @developer, status: :ok
    end
  end

  def destroy
    unless @developer.destroy
      render json: { errors: @developer.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @developer, status: :ok
    end
  end

  def current_developers
    @current_developers = Developer.joins(:projects).where("projects.project_status=1")
    render json: @current_developers, status: :ok
  end

  private

  def set_developer
    @developer = Developer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Developer not found" }, status: :not_found
  end

  def developer_params
    params.require(:developer).permit(:user_id, :company_id, :developer_tool_maps_attributes => [:id, :tool_id, :developer_id, :account_name], :team_ids => [])
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : Developer.per_page
  end

  def page_num
    filter_params[:options] && JSON.parse(filter_params[:options]).deep_symbolize_keys[:page] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:page] : 1
  end

  def orderby_name
    filter_params[:options] && JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_by] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_by].first : nil
  end

  def orderby_desc
    desc = filter_params[:options] && JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_desc] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_desc].first : true
    return desc == true ? "DESC" : "ASC"
  end

  def filter_params
    params.slice(:q, :options, :company_id, :user_id)
  end
end
