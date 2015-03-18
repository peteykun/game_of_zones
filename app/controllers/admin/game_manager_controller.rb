class Admin::GameManagerController < ApplicationController
  layout 'admin'
  before_action :check_if_admin
  before_action :set_vars

  def index
  end

  def toggle_zone_scheduler
    if @zone_scheduler_enabled
      ConfigTable.set('zone_scheduler_enabled', 'false')
      @zone_scheduler_enabled = false
    else
      ConfigTable.set('zone_scheduler_enabled', 'true')
      @zone_scheduler_enabled = true
    end

    redirect_to action: 'index'
  end

  def toggle_scoring_scheduler
    if @scoring_scheduler_enabled
      ConfigTable.set('scoring_scheduler_enabled', 'false')
      @scoring_scheduler_enabled = false
    else
      ConfigTable.set('scoring_scheduler_enabled', 'true')
      @scoring_scheduler_enabled = true
    end

    redirect_to action: 'index'
  end

  def change_active_zone
    regions = Region.all.order(:id)
    active_region = Region.find_by_active(true)

    i = regions.index(active_region)
    n = regions.size

    if i + 1 == n
      j = 0
    else
      j = i + 1
    end

    Region.transaction do
      regions[i].active = false
      regions[j].active = true

      regions[i].save
      regions[j].save
    end

    redirect_to action: 'index', notice: "#{regions[i].name} deactivated, #{regions[j].name} activated."
  end

  private
    def set_vars
      @zone_scheduler_enabled    = ConfigTable.lookup('zone_scheduler_enabled') == 'true'
      @scoring_scheduler_enabled = ConfigTable.lookup('scoring_scheduler_enabled') == 'true'

      @current_zone               = current_zone
      @zone_scheduler_last_run    = ConfigTable.lookup('zone_scheduler_last_run')
      @scoring_scheduler_last_run = ConfigTable.lookup('scoring_scheduler_last_run')

      @zone_scheduler_last_run = 'Never'    if @zone_scheduler_last_run == nil
      @scoring_scheduler_last_run = 'Never' if @scoring_scheduler_last_run == nil
    end
end
