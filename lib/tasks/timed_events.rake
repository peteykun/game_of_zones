namespace :timed_events do
  desc "Changes the current zone by setting the next zone as act'ive"
  task next_zone: :environment do

    zone_scheduler_enabled    = ConfigTable.lookup('zone_scheduler_enabled')

    if zone_scheduler_enabled == 'true'
      regions = Region.all.order(:id)
      active_region = Region.find_by_active(true)

      i = regions.index(active_region)
      n = regions.size

      if i + 1 == n
        j = 0
      else
        j = i + 1
      end

      Manifest.where(region: regions[j]).each do |m|
        m.update(level: 0, past_level: m.level)
      end

      Region.transaction do
        regions[i].update(active: false)
        regions[j].update(active: true)
      end

      puts "#{regions[i].name} deactivated, #{regions[j].name} activated."
    else
      puts "Zone scheduler disabled."
    end

    ConfigTable.set('zone_scheduler_last_run', Time.now.to_s)
  end

  desc "Updates scores by looking up the current leader of the current zone"
  task update_scores: :environment do

    scoring_scheduler_enabled = ConfigTable.lookup('scoring_scheduler_enabled')

    if scoring_scheduler_enabled == 'true'
      current_zone  = Region.find_by_active(true)

      if current_zone == nil
        puts "No zone is active"
        return
      end

      user  = current_zone.user

      if user != nil and current_zone != nil
        mani = Manifest.where(region: current_zone, user: user)[0]
        level = mani.level
        level = mani.past_level if level == 0 and mani.past_level != nil

        old_score = user.score
        user.score += level
        user.save

        puts "Updated #{user.username.titleize}'s score from #{old_score} to #{user.score}."
      else
        puts "No one in charge of zone #{current_zone.name}."
      end
    else
      puts "Scoring scheduler disabled"
    end

    ConfigTable.set('scoring_scheduler_last_run', Time.now.to_s)
  end

end
