# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Simple List Apis spec', type: :request do
  it_behaves_like 'simple_list_controller', 'FoodPreference'
  it_behaves_like 'simple_list_controller', 'ChildrenPreference'
  it_behaves_like 'simple_list_controller', 'DrinkingPreference'
  it_behaves_like 'simple_list_controller', 'SmokingPreference'
  it_behaves_like 'simple_list_controller', 'Religion'
  it_behaves_like 'simple_list_controller', 'Industry'
  it_behaves_like 'simple_list_controller', 'Language'
end

RSpec.feature 'Simple Search Apis spec', type: :request do
  it_behaves_like 'simple_search_controller', 'Company'
  it_behaves_like 'simple_search_controller', 'Course'
  it_behaves_like 'simple_search_controller', 'City'
  it_behaves_like 'simple_search_controller', 'University'
  it_behaves_like 'simple_search_controller', 'WorkTitle'
end
