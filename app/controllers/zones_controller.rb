class ZonesController < ApplicationController
  def index
    @zones = Region.all.order(:id)
    @active_zone = Region.find_by_active(true)
  end
end
