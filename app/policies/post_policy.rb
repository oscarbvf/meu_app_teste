class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present? # only logged users can create
  end

  def new?
    create?
  end

  def update?
    user.present?  # only logged users can edit
  end

  def edit?
    update?
  end

  def destroy?
    user.present? # only logged users can destroy
  end
end
