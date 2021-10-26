# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :gender }
  it {
    should define_enum_for(:gender)
             .with_values([:male, :female])
  }
end
