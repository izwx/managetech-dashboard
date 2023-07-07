class Api::V1::ToolMastersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tool_master, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @tool_masters = ToolMaster.all
    @tool_masters = @tool_masters.search(filter_params[:q]) if filter_params[:q].present?
    @tool_masters = @tool_masters.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @tool_masters = @tool_masters.paginate(page: page_num, per_page: items_per_page)
    render json: @tool_masters, meta: { pagination: pagination_dict(@tool_masters) }, status: :ok
  end

  def show
    render json: @tool_master, status: :ok
  end

  def new
    @tool_master = ToolMaster.new
    @tool_master.teams.build
  end

  def create
    @tool_master = ToolMaster.new(tool_master_params)
    if @tool_master.save
      render json: @tool_master, status: :created
    else
      render json: { errors: @tool_master.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @tool_master.update(tool_master_params)
      render json: { errors: @tool_master.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @tool_master, status: :ok
    end
  end

  def destroy
    unless @tool_master.destroy
      render json: { errors: @tool_master.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @tool_master, status: :ok
    end
  end

  private

  def set_tool_master
    @tool_master = ToolMaster.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Tool Master not found" }, status: :not_found
  end

  def tool_master_params
    params.require(:tool_master).permit(:tool_name, :token_guide, :target_guide, :payload_guide, :account_name_guide)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : ToolMaster.per_page
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
