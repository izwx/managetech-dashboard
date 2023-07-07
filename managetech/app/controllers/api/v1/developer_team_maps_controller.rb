class Api::V1::DeveloperTeamMapsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_developer_team_map, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @developer_team_maps = DeveloperTeamMap.all
    render json: @developer_team_maps, status: :ok
  end

  def show
    render json: @developer_team_map, status: :ok
  end

  def new
    @developer_team_map = DeveloperTeamMap.new
  end

  def create
    @developer_team_map = DeveloperTeamMap.new(developer_team_map_params)
    if @developer_team_map.save
      render json: @developer_team_map, status: :created
    else
      render json: { errors: @developer_team_map.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @developer_team_map.update(developer_team_map_params)
      render json: { errors: @developer_team_map.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @developer_team_map, status: :ok
    end
  end

  def destroy
    unless @developer_team_map.destroy
      render json: { errors: @developer_team_map.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @developer_team_map, status: :ok
    end
  end

  private

  def set_developer_team_map
    @developer_team_map = DeveloperTeamMap.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Developer Team Map not found" }, status: :not_found
  end

  def developer_team_map_params
    params.require(:developer_team_map).permit(:developer_id, :team_id, :work_hour)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : DeveloperTeamMap.per_page
  end

  def filter_params
    params.slice(:q, :options)
  end
end
