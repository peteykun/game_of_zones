class ZoneChangeMailer < ApplicationMailer
  default to: Proc.new { User.pluck(:email) },
          from: "gameofzones@gmail.com"

  def zone_change_email(zone)
    @zone = zone

    if zone.users.size == 0
      @leader_name = 'Nobody'
    else
      @leader_name = zone.users.pluck(:username).map { |x| x.titleize }.join(', ')
    end

    mail(subject: "Zone Change Notification: #{@zone.name}")
  end

end
