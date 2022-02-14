# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
end

describe '#current_age' do
  context 'when birthday lies in same month as current' do
    let(:user) { build(:user, birthday: Time.zone.today - 20.years) }

    it 'should return age' do
      expect(user.current_age).to eq(20)
    end
  end

  context 'when birthday lies in previous month' do
    let(:user) { build(:user, birthday: Time.zone.today - 20.years - 13.months) }

    it 'should return age' do
      expect(user.current_age).to eq(21)
    end
  end

  context 'when birthday lies in next month' do
    let(:user) { build(:user, birthday: Time.zone.today - 20.years - 11.months) }

    it 'should return age' do
      expect(user.current_age).to eq(20)
    end
  end
end
