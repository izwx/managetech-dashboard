class Api::V1::DeveloperCareersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_developer_career, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @developer_careers = DeveloperCareer.joins(developer: [:user]).all
    @developer_careers = @developer_careers.search(filter_params[:q]) if filter_params[:q].present?
    @developer_careers = @developer_careers.where("users.company_id = ?", filter_params[:company_id]) if filter_params[:company_id].present?
    @developer_careers = @developer_careers.where("users.id = ?", filter_params[:user_id]) if filter_params[:user_id].present?
    @developer_careers = @developer_careers.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @developer_careers = @developer_careers.paginate(page: page_num, per_page: items_per_page)
    render json: @developer_careers, meta: { pagination: pagination_dict(@developer_careers) }, status: :ok
  end

  def show
    render json: @developer_career, status: :ok
  end

  def new
    @developer_career = DeveloperCareer.new
  end

  def create
    @developer_career = DeveloperCareer.create(developer_career_params)

    skills_to_add = params[:developer_career][:skill_ids]
    skills_to_add.each do |skill_id|
      if skill_id != ""
        skill_id = skill_id.to_i
        skill_to_add = SkillMaster.find_by_id(skill_id)
        @developer_career.skills << skill_to_add
      end
    end

    domains_to_add = params[:developer_career][:domain_ids]
    domains_to_add.each do |domain_id|
      if domain_id != ""
        domain_id = domain_id.to_i
        domain_to_add = DomainMaster.find_by_id(domain_id)
        @developer_career.domains << domain_to_add
      end
    end

    if @developer_career.save
      render json: @developer_career, status: :created
    else
      render json: { errors: @developer_career.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    @developer_career.update(developer_career_params)

    @developer_career.skills.delete_all
    skills_to_add = params[:developer_career][:skill_ids]
    skills_to_add.each do |skill_id|
      if skill_id != ""
        skill_id = skill_id.to_i
        skill_to_add = SkillMaster.find_by_id(skill_id)
        @developer_career.skills << skill_to_add
      end
    end

    @developer_career.domains.delete_all
    domains_to_add = params[:developer_career][:domain_ids]
    domains_to_add.each do |domain_id|
      if domain_id != ""
        domain_id = domain_id.to_i
        domain_to_add = DomainMaster.find_by_id(domain_id)
        @developer_career.domains << domain_to_add
      end
    end

    if @developer_career.save
      render json: @developer_career, status: :ok
    else
      render json: { errors: @developer_career.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    unless @developer_career.destroy
      render json: { errors: @developer_career.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @developer_career, status: :ok
    end
  end

  private

  def set_developer_career
    @developer_career = DeveloperCareer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Domain Master not found" }, status: :not_found
  end

  def developer_career_params
    params.require(:developer_career).permit(:developer_id, :project_id, :start_month, :end_month, :role)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : DeveloperCareer.per_page
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
    params.slice(:q, :options, :user_id, :company_id)
  end
end
