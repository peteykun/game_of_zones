class Admin::TestCasesController < ApplicationController
  before_action :set_problem, only: [:problem, :new]
  before_action :set_test_case, only: [:show, :edit, :update, :destroy]
  before_action :check_if_admin
  layout 'admin'

  # GET /test_cases
  # GET /test_cases.json
  def index
    @problems = ::Problem.all.order(:id).paginate(page: params[:page], per_page: 10)
  end

  # GET /problems/new
  def new
    @test_case = ::TestCase.new
    @test_case.problem = @problem
  end

  # GET /test_cases/1
  # GET /test_cases/1.json
  def show
    @problem = @test_case.problem
    render 'problem'
  end

  # GET /test/cases/problem/1
  def problem
  end

  # GET /test_cases/1/edit
  def edit
  end

  # POST /test_cases
  def create
    @test_case = ::TestCase.new(test_case_params)
    @problem   = @test_case.problem

    respond_to do |format|
      if @test_case.save
        format.html { redirect_to [:admin, @test_case], notice: 'Test Case was successfully created.' }
        format.json { render :show, status: :created, location: @test_case }
      else
        format.html { render :new }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_cases/1
  # PATCH/PUT /test_cases/1.json
  def update
    respond_to do |format|
      if @test_case.update(test_case_params)
        format.html { redirect_to [:admin, @test_case], notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_case }
      else
        format.html { render :edit }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_cases/1
  # DELETE /test_cases/1.json
  def destroy
    problem = @test_case.problem
    @test_case.destroy
    respond_to do |format|
      format.html { redirect_to action: 'problem', id: problem.id, notice: 'Problem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = ::Problem.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_test_case
      @test_case = ::TestCase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_case_params
      params.require(:test_case).permit(:input, :output, :problem_id)
    end
end
