# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :access, :rails_admin     # only allow admin users to access Rails Admin
    can :read, :dashboard

    can :manage, :all if user.admin?
  end
end
