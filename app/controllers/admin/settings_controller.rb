class Admin::SettingsController < ApplicationController
  before_action :check_if_admin
  layout 'admin'

  def index
    @test_case_limit        = ConfigTable.find_by_key('test_case_limit').value
    @submission_time_limit  = ConfigTable.find_by_key('submission_time_limit').value

    @current_test_case_limit        = AdminConfig[:test_case_limit]
    @current_submission_time_limit  = AdminConfig[:submission_time_limit]
  end

  def update
    test_case_limit        = ConfigTable.find_by_key('test_case_limit')
    submission_time_limit  = ConfigTable.find_by_key('submission_time_limit')

    @current_test_case_limit        = AdminConfig[:test_case_limit]
    @current_submission_time_limit  = AdminConfig[:submission_time_limit]

    test_case_limit.value       = params[:test_case_limit].to_i
    submission_time_limit.value = params[:submission_time_limit].to_i

    test_case_limit.save
    submission_time_limit.save

    @test_case_limit        = test_case_limit.value
    @submission_time_limit  = submission_time_limit.value

    render 'index'
  end
end
