class CanAccessResque
  def self.matches?(request)
    raise "ask for access"
    current_user = request.env['warden'].user
    return false if current_user.blank?
    Ability.new(current_user).can? :manage, Resque
  end
end