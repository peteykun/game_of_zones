class Admin::RunsController < ApplicationController
  before_action :set_run, only: [:show]
  before_action :check_if_admin
  layout 'admin'

  # GET /runs
  # GET /runs.json
  def index
    @runs = ::Run.all.order('id DESC').paginate(page: params[:page], per_page: 10)
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run
      @run = ::Run.find(params[:id])
    end
end
