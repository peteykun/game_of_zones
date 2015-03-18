namespace :timed_events do
  desc "Changes the current zone by setting the next zone as active"
  task next_zone: :environment do
  end

  desc "Updates scores by looking up the current leader of the current zone"
  task compute_scores: :environment do
  end

end
