class Api::V1::DomainMastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_domain_master, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @domain_masters = DomainMaster.all
    @domain_masters = @domain_masters.search(filter_params[:q]) if filter_params[:q].present?
    @domain_masters = @domain_masters.where(creater_id: get_creater_id) unless is_admin?
    @domain_masters = @domain_masters.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @domain_masters = @domain_masters.paginate(page: page_num, per_page: items_per_page)
    render json: @domain_masters, meta: { pagination: pagination_dict(@domain_masters) }, status: :ok
  end

  def all_domain_masters
    @domain_masters = DomainMaster.all
    render json: @domain_masters, status: :ok
  end

  def show
    render json: @domain_master, status: :ok
  end

  def new
    @domain_master = DomainMaster.new
    @domain_master.teams.build
  end

  def create
    @domain_master = DomainMaster.new(domain_master_params)
    if @domain_master.save
      render json: @domain_master, status: :created
    else
      render json: { errors: @domain_master.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @domain_master.update(domain_master_params)
      render json: { errors: @domain_master.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @domain_master, status: :ok
    end
  end

  def destroy
    unless @domain_master.destroy
      render json: { errors: @domain_master.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @domain_master, status: :ok
    end
  end

  private

  def set_domain_master
    @domain_master = DomainMaster.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Domain Master not found" }, status: :not_found
  end

  def domain_master_params
    params.require(:domain_master).permit(:domain_name, :project_id, :creater_id)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : DomainMaster.per_page
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
