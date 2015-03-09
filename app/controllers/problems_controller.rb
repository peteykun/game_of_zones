class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :request_input, :submit_output]

  # GET /problems
  def index
    @problems = Problem.all
  end

  # GET /problems/1
  def show
  end

  # GET /problems/1/request_input
  def request_input
    run = @problem.generate_new_run(current_user)

    filename = "input_" + params[:id] + ".txt"
    send_data run.input, filename: filename
  end

  # GET /problems/1/submit_output
  def submit_output
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = ::Problem.find(params[:id])
    end
end
