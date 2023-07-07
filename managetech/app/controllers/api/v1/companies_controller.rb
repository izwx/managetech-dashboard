class Api::V1::CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @companies = Company.all
    @companies = @companies.search(filter_params[:q]) if filter_params[:q].present?
    @companies = @companies.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @companies = @companies.paginate(page: page_num, per_page: items_per_page)
    render json: @companies, meta: { pagination: pagination_dict(@companies) }, status: :ok
  end

  def reports
    data = []
    12.times do |i|
      end_of_month = i.months.ago.end_of_month
      companies = Company.where("created_at <= ?", end_of_month)
      count = companies.exists? ? companies.count() : 0
      data << { value: count, date: end_of_month }
    end
    render json: { company_reports: data }
  end

  def show
    render json: @company, status: :ok
  end

  def new
    @company = Company.new
    @company.teams.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      render json: @company, status: :created
    else
      render json: { errors: @company.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @company.update(company_params)
      render json: { errors: @company.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @company, status: :ok
    end
  end

  def destroy
    unless @company.destroy
      render json: { errors: @company.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @company, status: :ok
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Company not found" }, status: :not_found
  end

  def company_params
    params.require(:company).permit(:company_name)
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : Company.per_page
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
