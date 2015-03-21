class Admin::GameManagerController < ApplicationController
  layout 'admin'
  before_action :check_if_admin
  before_action :set_vars

  def index
    @zones = Region.all.order(:id)
    max_level_problem = Problem.order('difficulty DESC').first

    if max_level_problem == nil
      @max_level = 0
    else
      @max_level = max_level_problem.difficulty
    end

    @total = Hash.new(0)
    @have  = Hash.new
    @need  = Hash.new

    @zones.where(active: false).each do |zone|
      (1..@max_level).each do |level|
        p = Problem.where(region: zone, difficulty: level)[0]

        if zone.user == nil and level == 1
          @total[level] +=1
        elsif zone.user == nil
          # do nothing
        elsif p.difficulty <= @max_level + 1
          @total[level] += 1
        end

      end
    end

    (1..@max_level).each do |level|
      @have[level] = Problem.where(difficulty: level, active: nil).size
      @need[level] = @total[level] - @have[level]
      @need[level] = 0                                    if @need[level] < 0
    end
  end

  def start
    max_level_problem = Problem.order('difficulty DESC').first

    if max_level_problem == nil
      @max_level = 0
    else
      @max_level = max_level_problem.difficulty
    end

    # Assign problems
    Region.all.each do |r|
      (1..@max_level).each do |level|
        next if Problem.where(active: true, difficulty: level, region: r).size > 0
        next if Problem.where(active: nil, difficulty: level).size == 0

        p = Problem.where(active: nil, difficulty: level).sample
        p.update(active: true)
        r.problems << p
      end

      r.save
    end

    # Start schedulers
    ConfigTable.set('zone_scheduler_enabled', 'true')
    ConfigTable.set('scoring_scheduler_enabled', 'true')

    # Set game started
    ConfigTable.set('game_started', 'true')

    redirect_to action: 'index'
  end

  def status
    @zones = Region.all.order(:id)
    max_level_problem = Problem.order('difficulty DESC').first

    if max_level_problem == nil
      @max_level = 0
    else
      @max_level = max_level_problem.difficulty
    end

    @total = Hash.new(0)
    @have  = Hash.new
    @need  = Hash.new

    @zones.where(active: false).each do |zone|
      (1..@max_level).each do |level|
        p = Problem.where(region: zone, difficulty: level)[0]

        if zone.user == nil and level == 1
          @total[level] +=1
        elsif zone.user == nil
          # do nothing
        elsif p.difficulty <= @max_level + 1
          @total[level] += 1
        end

      end
    end

    (1..@max_level).each do |level|
      @have[level] = Problem.where(difficulty: level, active: nil).size
      @need[level] = @total[level] - @have[level]
      @need[level] = 0                                    if @need[level] < 0
    end
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

    # Reset user levels
    max_level = Manifest.where(region: regions[j], user: regions[j].user)[0].level unless regions[j].user == nil

    Manifest.where(region: regions[j]).each do |m|
      m.update(level: 0, past_level: m.level)
    end

    log = ''

    # Replace programs that have already been solved or seen
    regions[j].problems.each do |p|
      if (regions[j].user != nil and p.difficulty <= max_level + 1)
        p.active = false

        replacement = Problem.where(active: nil, difficulty: p.difficulty)[0]

        # ABORT AND ENTER PANIC MODE if you can't find a replacement
        if replacement == nil
          log += "Couldn't find Level #{p.difficulty} replacement.<br>"
          break
          # Program remains unchanged
        end

        replacement.region = p.region
        replacement.active = true

        Problem.transaction do
          replacement.save
          p.save
        end
      
        log += "Level #{p.difficulty} Problem #{p.name} replaced with #{replacement.name}.<br>"
      end
    end

    # If nobody's solved anything, just replace the first program
    if regions[j].user == nil
      p = regions[j].problems.find_by_difficulty(1)
      p.active = false

      replacement = Problem.where(active: nil, difficulty: p.difficulty)[0]

      # ABORT AND ENTER PANIC MODE if you can't find a replacement
      unless replacement == nil
        replacement.region = p.region
        replacement.active = true

        Problem.transaction do
          replacement.save
          p.save
        end
        
        log += "Level #{p.difficulty} Problem #{p.name} replaced with #{replacement.name}.<br>"
      else
        # DO NOTHING
        # Program remains unchanged
        log += "Couldn't find Level #{p.difficulty} replacement.<br>"
      end
    end

    # Turn off the old region and turn on the new one
    Region.transaction do
      regions[i].update(active: false)
      regions[j].update(active: true)
    end

    redirect_to action: 'index', notice: log + "#{regions[i].name} deactivated, #{regions[j].name} activated."
  end

  private
    def set_vars
      @zone_scheduler_enabled    = ConfigTable.lookup('zone_scheduler_enabled') == 'true'
      @scoring_scheduler_enabled = ConfigTable.lookup('scoring_scheduler_enabled') == 'true'
      @game_active               = ConfigTable.lookup('game_started') == 'true'

      @current_zone               = current_zone
      @zone_scheduler_last_run    = ConfigTable.lookup('zone_scheduler_last_run')
      @scoring_scheduler_last_run = ConfigTable.lookup('scoring_scheduler_last_run')

      @zone_scheduler_last_run = 'Never'    if @zone_scheduler_last_run == nil
      @scoring_scheduler_last_run = 'Never' if @scoring_scheduler_last_run == nil
    end
end
