class PusherService
  def self.get_channel_name_for_user user
    "#{user.name.parameterize}-pusher-channel"
  end

  def self.trigger_event_on_user_channel(user, event, message)
    puts "TRIGGERED"
    channel = self.get_channel_name_for_user(user)
    Pusher[channel].trigger(event, message)
  end
end