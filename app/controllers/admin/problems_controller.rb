class Admin::ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  before_action :check_if_admin
  layout 'admin'

  # GET /problems
  # GET /problems.json
  def index
    @problems = ::Problem.all.order(:id).paginate(page: params[:page], per_page: 10)
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
  end

  # GET /problems/new
  def new
    @problem = ::Problem.new
    @test_case_inputs = ''
    @test_case_outputs = ''
  end

  # GET /problems/1/edit
  def edit
  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = ::Problem.new(problem_params)
    @test_case_inputs = params[:problem][:test_case_inputs]
    @test_case_outputs = params[:problem][:test_case_outputs]

    respond_to do |format|
      if @problem.save
        format.html { redirect_to [:admin, @problem], notice: 'Problem was successfully created.' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { render :new }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    respond_to do |format|
      if @problem.update(problem_params)
        format.html { redirect_to [:admin, @problem], notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { render :edit }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    @problem.destroy
    respond_to do |format|
      format.html { redirect_to admin_problems_url, notice: 'Problem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = ::Problem.find(params[:id])

      if params[:problem] != nil
        @test_case_inputs = params[:problem][:test_case_inputs]
        @test_case_outputs = params[:problem][:test_case_outputs]
      else  
        @test_case_inputs = @problem.test_case_inputs
        @test_case_outputs = @problem.test_case_outputs
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:name, :difficulty, :statement, :sample_input, :sample_output, :test_case_inputs, :test_case_outputs, :region_id)
    end
end
