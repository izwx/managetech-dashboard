class Api::V1::BatchLogsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_batch_log, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @batch_logs = BatchLog.all
    @batch_logs = @batch_logs.search(filter_params[:q]) if filter_params[:q].present?
    @batch_logs = @batch_logs.where(company_id: filter_params[:company_id]) if filter_params[:company_id].present?
    @batch_logs = @batch_logs.order("#{orderby_name} #{orderby_desc}") if orderby_name.present?
    @batch_logs = @batch_logs.paginate(page: page_num, per_page: items_per_page)
    render json: @batch_logs, meta: { pagination: pagination_dict(@batch_logs) }, status: :ok
  end

  def show
    render json: @batch_log, serializer: BatchLogDetailSerializer, status: :ok
  end

  def new
    @batch_log = BatchLog.new
    @batch_log.teams.build
  end

  def create
    @batch_log = BatchLog.new(batch_log_params)
    if @batch_log.save
      render json: @batch_log, status: :created
    else
      render json: { errors: @batch_log.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @batch_log.update(batch_log_params)
      render json: { errors: @batch_log.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @batch_log, status: :ok
    end
  end

  def destroy
    unless @batch_log.destroy
      render json: { errors: @batch_log.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @batch_log, status: :ok
    end
  end

  private

  def set_batch_log
    @batch_log = BatchLog.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "BatchLog not found" }, status: :not_found
  end

  def batch_log_params
    params.require(:batch_log).permit()
  end

  def items_per_page
    filter_params[:options] ? (JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page] == -1 ? 1000 : JSON.parse(filter_params[:options]).deep_symbolize_keys[:items_per_page]) : BatchLog.per_page
  end

  def page_num
    filter_params[:options] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:page] : 1
  end

  def orderby_name
    filter_params[:options] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_by].first : "end_datetime"
  end

  def orderby_desc
    desc = filter_params[:options] ? JSON.parse(filter_params[:options]).deep_symbolize_keys[:sort_desc].first : true
    return desc == true ? "DESC" : "ASC"
  end

  def filter_params
    params.slice(:q, :options, :company_id)
  end
end
