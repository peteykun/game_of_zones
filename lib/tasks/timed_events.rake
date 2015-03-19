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

      # Reset user levels
      max_level = Manifest.where(region: regions[j], user: regions[j].user)[0].level unless regions[j].user == nil

      Manifest.where(region: regions[j]).each do |m|
        m.update(level: 0, past_level: m.level)
      end

      # Replace programs that have already been solved or seen
      regions[j].problems.each do |p|
        if (regions[j].user != nil and p.difficulty <= max_level + 1)
          p.active = false

          replacement = Problem.where(active: nil, difficulty: p.difficulty)[0]
          
          # ABORT AND ENTER PANIC MODE if you can't find a replacement
          if replacement == nil
            puts "Couldn't find Level #{p.difficulty} replacement."
            break
            # Program remains unchanged
          end

          replacement.region = p.region
          replacement.active = true

          Problem.transaction do
            replacement.save
            p.save
          end

          puts "Level #{p.difficulty} Problem #{p.name} replaced with #{replacement.name}."
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

          puts "Level #{p.difficulty} Problem #{p.name} replaced with #{replacement.name}."
        else
          # DO NOTHING
          # Program remains unchanged
          puts "Couldn't find Level #{p.difficulty} replacement."
        end
      end

      # Turn off the old region and turn on the new one
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
