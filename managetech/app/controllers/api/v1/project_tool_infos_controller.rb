class Api::V1::ProjectToolInfosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project_tool_info, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @project_tool_infos = ProjectToolInfo.all
    @project_tool_infos = @project_tool_infos.search(filter_params[:q]) if filter_params[:q].present?
    @project_tool_infos = @project_tool_infos.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    # @project_tool_infos = @project_tool_infos.paginate(page: page_num, per_page: items_per_page)
    render json: @project_tool_infos, status: :ok
  end

  def show
    render json: @project_tool_info, status: :ok
  end

  def new
    @project_tool_info = ProjectToolInfo.new
    @project_tool_info.teams.build
  end

  def create
    @project_tool_info = ProjectToolInfo.new(project_tool_info_params)
    if @project_tool_info.save
      render json: @project_tool_info, status: :created
    else
      render json: { errors: @project_tool_info.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @project_tool_info.update(project_tool_info_params)
      render json: { errors: @project_tool_info.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @project_tool_info, status: :ok
    end
  end

  def destroy
    unless @project_tool_info.destroy
      render json: { errors: @project_tool_info.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @project_tool_info, status: :ok
    end
  end

  private

  def set_project_tool_info
    @project_tool_info = ProjectToolInfo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Project Tool Info not found" }, status: :not_found
  end

  def project_tool_info_params
    params.require(:project_tool_info).permit(:project_id, :tool_id, :token, :target, :payload)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : ProjectToolInfo.per_page
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
    params.slice(:q, :options)
  end
end
