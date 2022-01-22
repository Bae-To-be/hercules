# frozen_string_literal: true

desc 'Creates a seed with random users'
task :user_seed, [:lat, :lng] => :environment do |t, args|
  male_gender = Gender.find_or_create_by!(name: 'Male')
  female_gender = Gender.find_or_create_by!(name: 'Female')
  all_genders = Gender.find_or_create_by!(name: 'All')

  origin = Geokit::LatLng.new(args.lat.presence || 19.138449, args.lng.presence || 72.862637)

  100.times do
    location = origin.endpoint((0..360).to_a.sample, ENV.fetch('DEFAULT_SEARCH_RADIUS').to_i)

    user = User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      birthday: Time.now.utc.to_date - 20.years,
      interested_age_lower: 18,
      interested_age_upper: 50,
      lat: location.lat,
      lng: location.lng,
      gender: [male_gender, female_gender].sample,
      industry: Industry.find_or_create_by!(name: Faker::IndustrySegments.industry),
      company: Company.find_or_create_by!(name: Faker::Company.bs),
      work_title: WorkTitle.find_or_create_by!(name: Faker::Job.unique.title),
      interested_genders: [[male_gender, female_gender, all_genders].sample],
      linkedin_url: 'https://www.linkedin.com/john-doe',
      linkedin_public: [true, false].sample,
      country_code: %w[IN US].sample,
      locality: ['Bangalore', 'San Francisco'].sample,
      bio: Faker::Hipster.sentence(word_count: 5, supplemental: false),
      hometown_city_id: City.find_or_create_by!(name: Faker::Address.city),
      hometown_country: Faker::Address.country,
      religion: Religion.find_or_create_by!(name: %w[Atheism Hinduism Christianity].sample),
      height_in_cms: 167,
      food_preference: FoodPreference.find_or_create_by!(name: %w[Vegan Veg Non-Veg].sample),
      smoking_preference: SmokingPreference.find_or_create_by!(name: %w[Sometimes Never Frequently].sample),
      drinking_preference: DrinkingPreference.find_or_create_by!(name: %w[Sometimes Never Frequently].sample),
      children_preference: ChildrenPreference.find_or_create_by!(name: %w[Someday Never].sample)
    )
    user.educations.create!(course: Course.find_or_create_by!(name: Faker::Educator.degree),
                            university: University.find_or_create_by!(name: Faker::University.name), year: (2010..2021).to_a.sample)
    languages = %w[English Hindi French Tamil].sample(2)
    user.languages = languages.map { |language| Language.find_or_create_by!(name: language) }
  rescue ActiveRecord::RecordNotUnique
    next
  end
end
