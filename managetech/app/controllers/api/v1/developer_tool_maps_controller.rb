class Api::V1::DeveloperToolMapsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_developer_tool_map, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @developer_tool_maps = DeveloperToolMap.all
    @developer_tool_maps = @developer_tool_maps.search(filter_params[:q]) if filter_params[:q].present?
    @developer_tool_maps = @developer_tool_maps.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    # @developer_tool_maps = @developer_tool_maps.paginate(page: page_num, per_page: items_per_page)
    render json: @developer_tool_maps, status: :ok
  end

  def show
    render json: @developer_tool_map, status: :ok
  end

  def new
    @developer_tool_map = DeveloperToolMap.new
    @developer_tool_map.teams.build
  end

  def create
    @developer_tool_map = DeveloperToolMap.new(developer_tool_map_params)
    if @developer_tool_map.save
      render json: @developer_tool_map, status: :created
    else
      render json: { errors: @developer_tool_map.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @developer_tool_map.update(developer_tool_map_params)
      render json: { errors: @developer_tool_map.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @developer_tool_map, status: :ok
    end
  end

  def destroy
    unless @developer_tool_map.destroy
      render json: { errors: @developer_tool_map.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @developer_tool_map, status: :ok
    end
  end

  private

  def set_developer_tool_map
    @developer_tool_map = DeveloperToolMap.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Developer Tool Info not found" }, status: :not_found
  end

  def developer_tool_map_params
    params.require(:developer_tool_map).permit(:developer_id, :tool_id, :account_name)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : DeveloperToolMap.per_page
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
