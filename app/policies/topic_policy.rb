class TopicPolicy < ApplicationPolicy

  def create?
    user.present? && user.admin?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
