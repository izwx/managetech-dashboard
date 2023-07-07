class Api::V1::TeamsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_team, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @teams = Team.all
    @teams = @teams.search(filter_params[:q]) if filter_params[:q].present?
    @teams = @teams.where(company_id: filter_params[:company_id]) if filter_params[:company_id].present?
    @teams = @teams.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @teams = @teams.paginate(page: page_num, per_page: items_per_page)
    render json: @teams, meta: { pagination: pagination_dict(@teams) }, status: :ok
  end

  def show
    render json: @team, serializer: TeamDetailSerializer, status: :ok
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      render json: @team, status: :created
    else
      render json: { errors: @team.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @team.update(team_params)
      render json: { errors: @team.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @team, status: :ok
    end
  end

  def destroy
    unless @team.destroy
      render json: { errors: @team.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @team, status: :ok
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Team not found" }, status: :not_found
  end

  def team_params
    params.require(:team).permit(:team_name, :company_id)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : Team.per_page
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
    params.slice(:q, :options, :company_id)
  end
end
