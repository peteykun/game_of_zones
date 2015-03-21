class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :request_input, :submit_output]
  before_action :check_if_allowed, only: [:show, :request_input, :submit_output]
  before_action :set_cache_buster
  before_action :check_if_logged_in

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  # GET /problems
  def index
    @problems = Problem.where(region: current_zone, active: true).order('difficulty ASC').paginate(page: params[:page], per_page: 10)
    @current_zone = current_zone
    @allowed_level = Manifest.where(user: current_user, region: current_zone)[0].level + 1
  end

  # GET /problems/1
  def show
    @submission_time_limit = AdminConfig[:submission_time_limit].to_i
    @runs = Run.where(user: current_user, problem: @problem).order('id DESC')

    current_runs = @problem.runs.where(user: current_user).where("timestamp > ?", DateTime.strptime((Time.now.to_i - 120).to_s, "%s"))
    @submission_time_limit = AdminConfig[:submission_time_limit].to_i

    if current_runs.size > 0 and current_runs.last.tested == false
      @running = true
      total_time   = @submission_time_limit
      time_elapsed = Time.now.to_i - current_runs.last.timestamp.to_i
      @submission_time_left = total_time - time_elapsed
    else
      @running = false
    end

    if not flash == nil
      @flash = true
      @success = flash[:success]
      @message = flash[:message]
    end
  end

  # GET /problems/1/request_input
  def request_input
    @test_case_limit = AdminConfig[:test_case_limit].to_i
    current_runs = @problem.runs.where(user: current_user, tested: false).where("timestamp > ?", DateTime.strptime((Time.now.to_i - 120).to_s, "%s"))

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
    current_runs = @problem.runs.where(user: current_user, tested: false).where("timestamp > ?", DateTime.strptime((Time.now.to_i - 120).to_s, "%s"))

    if current_runs.size > 0
      run = current_runs.last
    else
      #render json: [success: false, message: "Input set not requested or time limit expired."]

      redirect_to @problem, flash: {success: false, message: "Input set not requested or time limit expired."}
      return
    end

    uploaded_output = params[:output]
    uploaded_source = params[:source]

    run.output = uploaded_output.read
    run.code   = uploaded_source.read
    run.save

    if run.test
      #render json: [success: true, message: "Accepted."]
      redirect_to @problem, flash: {success: true, message: "Accepted."}
    else
      #render json: [success: false, message: "Submission incorrect."]
      redirect_to @problem, flash: {success: false, message: "Submission incorrect."}
    end
  end

  private
    # Use callbacks to share common setup or coenstraints between actions.
    def set_problem
      begin
        @problem = ::Problem.find(params[:id])
      rescue Exception => e
        redirect_to action: 'index', notice: 'This problem doesn\'t exist.'
        return
      end
    end

    def check_if_allowed
      if @problem.active == false
        redirect_to action: 'index', notice: 'This problem has been archived.'
        return
      elsif @problem.active == nil
        redirect_to action: 'index', notice: 'This problem has not been activated.'
        return
      end

      if @problem.region != current_zone
        redirect_to action: 'index', notice: 'This region is closed right now.'
        return
      end

      if @problem.difficulty > current_user.level(current_zone) + 1
        redirect_to action: 'index', notice: 'This problem is locked right now.'
        return
      end
    end
end
