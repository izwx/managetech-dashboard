class Api::V1::ProjectTeamMapsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project_team_map, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @project_team_maps = ProjectTeamMap.all
    render json: @project_team_maps, status: :ok
  end

  def show
    render json: @project_team_map, status: :ok
  end

  def new
    @project_team_map = ProjectTeamMap.new
  end

  def create
    @project_team_map = ProjectTeamMap.with_deleted.find_or_initialize_by(project_team_map_params)
    if @project_team_map.save
      render json: @project_team_map, status: :created
    else
      render json: { errors: @project_team_map.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @project_team_map.update(project_team_map_params)
      render json: { errors: @project_team_map.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @project_team_map, status: :ok
    end
  end

  def destroy
    unless @project_team_map.destroy
      render json: { errors: @project_team_map.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @project_team_map, status: :ok
    end
  end

  private

  def set_project_team_map
    @project_team_map = ProjectTeamMap.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Project Team Map not found" }, status: :not_found
  end

  def project_team_map_params
    params.require(:project_team_map).permit(:project_id, :team_id)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : ProjectTeamMap.per_page
  end

  def filter_params
    params.slice(:q, :options)
  end
end
