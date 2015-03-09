class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :request_input, :submit_output]

  # GET /problems
  def index
    @problems = Problem.all
  end

  # GET /problems/1
  def show
    @submission_time_limit = AdminConfig[:submission_time_limit].to_i

    current_runs = @problem.runs.where(user: User.first).where("timestamp > ?", DateTime.strptime((Time.now.to_i - 120).to_s, "%s"))
    @submission_time_limit = AdminConfig[:submission_time_limit].to_i

    if current_runs.size > 0
      @running = true
      total_time   = @submission_time_limit
      time_elapsed = Time.now.to_i - current_runs.last.timestamp.to_i
      @submission_time_left = total_time - time_elapsed
    else
      @running = false
    end
  end

  # GET /problems/1/request_input
  def request_input
    @test_case_limit = AdminConfig[:test_case_limit].to_i
    current_runs = @problem.runs.where(user: User.first).where("timestamp > ?", DateTime.strptime((Time.now.to_i - 120).to_s, "%s"))

    if current_runs.size > 0
      run = current_runs.last
    else
      run = @problem.generate_new_run(current_user, @test_case_limit)
    end

    filename = "input_" + params[:id] + "_" + run.timestamp.to_i.to_s + ".txt"
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
