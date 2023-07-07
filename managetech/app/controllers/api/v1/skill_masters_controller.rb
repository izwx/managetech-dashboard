class Api::V1::SkillMastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_skill_master, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @skill_masters = SkillMaster.all
    @skill_masters = @skill_masters.search(filter_params[:q]) if filter_params[:q].present?
    @skill_masters = @skill_masters.where(creater_id: get_creater_id) if is_admin?
    @skill_masters = @skill_masters.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @skill_masters = @skill_masters.paginate(page: page_num, per_page: items_per_page)
    render json: @skill_masters, meta: { pagination: pagination_dict(@skill_masters) }, status: :ok
  end

  def all_skill_masters
    @skill_masters = SkillMaster.all
    render json: @skill_masters, status: :ok
  end

  def show
    render json: @skill_master, status: :ok
  end

  def new
    @skill_master = SkillMaster.new
    @skill_master.teams.build
  end

  def create
    @skill_master = SkillMaster.new(skill_master_params)
    if @skill_master.save
      render json: @skill_master, status: :created
    else
      render json: { errors: @skill_master.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @skill_master.update(skill_master_params)
      render json: { errors: @skill_master.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @skill_master, status: :ok
    end
  end

  def destroy
    unless @skill_master.destroy
      render json: { errors: @skill_master.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @skill_master, status: :ok
    end
  end

  private

  def set_skill_master
    @skill_master = SkillMaster.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Skill Master not found" }, status: :not_found
  end

  def skill_master_params
    params.require(:skill_master).permit(:skill_name, :project_id, :creater_id)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : SkillMaster.per_page
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

  def get_creater_id
    filter_params[:options] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:creater_id] : nil
  end

  def filter_params
    params.slice(:q, :options)
  end
end
