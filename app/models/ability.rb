# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :access, :rails_admin     # only allow admin users to access Rails Admin
    can :read, :dashboard

    if user.kyc_agent?
      can :manage, VerificationRequest, status: :in_review
      can :show, User
      can :read, Education
      can :read, Image
      can :read, VerificationFile
    end

    can :manage, :all if user.admin?
  end
end
