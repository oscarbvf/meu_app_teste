class CommentPolicy < ApplicationPolicy
  def create?
    user.present? # user needs to be logged in
  end

  def update?
    user_owns_comment? # only the owner can edit
  end

  def edit?
    update?
  end

  def destroy?
    user_owns_comment? # only the owner can destroy
  end

  private

  def user_owns_comment?
    user.present? && record.user == user
  end
end
