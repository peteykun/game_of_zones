class RunsController < ApplicationController
  before_action :set_run, only: [:show]
  before_action :check_if_logged_in

  # GET /runs
  # GET /runs.json
  def index
    @runs = Run.where(user: current_user).order('id DESC').paginate(page: params[:page], per_page: 10)
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run
      begin
        @run = Run.find(params[:id])
      rescue Exception => e
        redirect_to action: 'index', notice: 'This run doesn\'t exist.'
        return
      end
    end
end
