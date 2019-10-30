class BundlePolicy < ApplicationPolicy
  def index?
    user.is_a? AdminUser
  end

  def show?
    user.is_a? AdminUser
  end

  def create?
    user.is_a? AdminUser
  end

  def new?
    create?
  end

  def update?
    user.is_a? AdminUser
  end

  def edit?
    user.is_a? AdminUser
  end

  def destroy?
    user.is_a? AdminUser
  end

end

