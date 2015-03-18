namespace :timed_events do
  desc "Changes the current zone by setting the next zone as act'ive"
  task next_zone: :environment do
    regions = Region.all
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

    puts "#{regions[i].name} deactivated, #{regions[j].name} activated."
  end

  desc "Updates scores by looking up the current leader of the current zone"
  task update_scores: :environment do
    current_zone  = Region.find_by_active(true)

    if current_zone == nil
      puts "No zone is active"
      return
    end

    user  = current_zone.user

    if user != nil and current_zone != nil
      level = Manifest.where(region: current_zone, user: user)[0].level

      old_score = user.score
      user.score += level
      user.save

      puts "Updated #{user.username.titleize}'s score from #{old_score} to #{user.score}."
    else
      puts "No one in charge of zone #{current_zone.name}."
    end
  end

end
