class Api::V1::SprintsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_sprint, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @sprints = Sprint.all
    @sprints = @sprints.search(filter_params[:q]) if filter_params[:q].present?
    @sprints = @sprints.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @sprints = @sprints.paginate(page: page_num, per_page: items_per_page)
    render json: @sprints, meta: { pagination: pagination_dict(@sprints) }, status: :ok
  end

  def show
    render json: @sprint, serializer: SprintDetailSerializer, status: :ok
  end

  def new
    @sprint = Sprint.new
    @sprint.teams.build
  end

  def create
    @sprint = Sprint.new(sprint_params)
    if @sprint.save
      render json: @sprint, status: :created
    else
      render json: { errors: @sprint.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @sprint.update(sprint_params)
      render json: { errors: @sprint.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @sprint, status: :ok
    end
  end

  def destroy
    unless @sprint.destroy
      render json: { errors: @sprint.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @sprint, status: :ok
    end
  end

  def sprint_phases
    render json: Sprint.sprint_phases, status: :ok
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Sprint not found" }, status: :not_found
  end

  def sprint_params
    params.require(:sprint).permit(:sprint_name)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : Sprint.per_page
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
