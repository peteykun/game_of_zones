class ZoneChangeMailer < ApplicationMailer
  default to: Proc.new { User.pluck(:email) },
          from: "noreply@goz.edg.co.in"

  def zone_change_email(zone)
    @zone = zone

    if zone.user.nil?
      @leader_name = 'Nobody'
    else
      @leader_name = zone.user.username
    end

    mail(subject: "Zone Change Notification: #{@zone.name}")
  end

end
