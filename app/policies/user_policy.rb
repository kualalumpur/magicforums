class UserPolicy < ApplicationPolicy


  def edit?
    user.present? && record == user || user_has_power?
  end

  def update?
    user.present? && record == user || user_has_power?
  end

  private

  def user_has_power?
    user.admin? || user.moderator?
  end

end
