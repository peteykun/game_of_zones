class ZonesController < ApplicationController
  def index
    @zones = Region.all
  end
end
