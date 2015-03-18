class ZonesController < ApplicationController
  before_action :check_if_logged_in
  
  def index
    @zones = Region.all.order(:id)
    @active_zone = Region.find_by_active(true)
  end
end
