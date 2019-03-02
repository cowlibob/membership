class CsvExportsController < ApplicationController
  include Clearance::Controller
  before_action :require_login
  before_action :set_csv_export, only: [:show, :edit, :update, :destroy]

  # GET /csv_exports
  def index
    @csv_exports = CsvExport.all
  end

  # GET /csv_exports/1
  def show
    respond_to do |format|
      format.html
      format.csv { send_data @csv_export.content, filename: @csv_export.filename, type: Mime::Type.lookup("text/csv"), disposition: 'attachment'}
    end
  end

  # GET /csv_exports/new
  def new
    @csv_export = CsvExport.new
  end

  # GET /csv_exports/1/edit
  def edit
  end

  # POST /csv_exports
  def create
    @csv_export = CsvExport.new(csv_export_params.merge(user_id: current_user.id))

    if @csv_export.populate && @csv_export.save
      redirect_to csv_exports_path, notice: 'Csv export was successfully created.'
    else
      render :new
    end
  end

  # DELETE /csv_exports/1
  def destroy
    @csv_export.destroy
    redirect_to csv_exports_url, notice: 'Csv export was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_csv_export
      @csv_export = CsvExport.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def csv_export_params
      params.require(:csv_export).permit(:year, :content, :user_id)
    end
end
