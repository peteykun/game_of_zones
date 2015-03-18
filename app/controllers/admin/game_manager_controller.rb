class Admin::GameManagerController < ApplicationController
  layout 'admin'
  before_action :check_if_admin

  def index
    #ConfigTable.lookup()
  end
end
