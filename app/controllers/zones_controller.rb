class ZonesController < ApplicationController
  def index
    @zones = Region.all.order(:id)
  end
end
