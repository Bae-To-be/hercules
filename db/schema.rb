# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_06_095002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "google_id", null: false
    t.string "email", null: false
    t.integer "role", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["google_id"], name: "index_admin_users_on_google_id", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
    t.index ["position"], name: "index_articles_on_position", unique: true
  end

  create_table "background_migration_jobs", force: :cascade do |t|
    t.bigint "migration_id", null: false
    t.bigint "min_value", null: false
    t.bigint "max_value", null: false
    t.integer "batch_size", null: false
    t.integer "sub_batch_size", null: false
    t.integer "pause_ms", null: false
    t.datetime "started_at", precision: 6
    t.datetime "finished_at", precision: 6
    t.string "status", default: "enqueued", null: false
    t.integer "max_attempts", null: false
    t.integer "attempts", default: 0, null: false
    t.string "error_class"
    t.string "error_message"
    t.string "backtrace", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["migration_id", "finished_at"], name: "index_background_migration_jobs_on_finished_at"
    t.index ["migration_id", "max_value"], name: "index_background_migration_jobs_on_max_value"
    t.index ["migration_id", "status", "updated_at"], name: "index_background_migration_jobs_on_updated_at"
  end

  create_table "background_migrations", force: :cascade do |t|
    t.string "migration_name", null: false
    t.jsonb "arguments", default: [], null: false
    t.string "batch_column_name", null: false
    t.bigint "min_value", null: false
    t.bigint "max_value", null: false
    t.bigint "rows_count"
    t.integer "batch_size", null: false
    t.integer "sub_batch_size", null: false
    t.integer "batch_pause", null: false
    t.integer "sub_batch_pause_ms", null: false
    t.integer "batch_max_attempts", null: false
    t.string "status", default: "enqueued", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["migration_name", "arguments"], name: "index_background_migrations_on_unique_configuration", unique: true
  end

  create_table "children_preferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_children_preferences_on_name", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_cities_on_name", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "course_relationships", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "(ARRAY[LEAST(source_id, target_id), GREATEST(target_id, source_id)])", name: "course_pair_uniq", unique: true
    t.index ["source_id"], name: "index_course_relationships_on_source_id"
    t.index ["target_id"], name: "index_course_relationships_on_target_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_courses_on_name", unique: true
  end

  create_table "drinking_preferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_drinking_preferences_on_name", unique: true
  end

  create_table "educations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.bigint "university_id", null: false
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_educations_on_course_id"
    t.index ["university_id"], name: "index_educations_on_university_id"
    t.index ["user_id"], name: "index_educations_on_user_id"
  end

  create_table "exercise_preferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_exercise_preferences_on_name", unique: true
  end

  create_table "food_preferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_food_preferences_on_name", unique: true
  end

  create_table "genders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_genders_on_name", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", default: 0
    t.index ["position", "user_id"], name: "index_images_on_position_and_user_id", unique: true
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_industries_on_name", unique: true
  end

  create_table "industry_relationships", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "(ARRAY[LEAST(source_id, target_id), GREATEST(target_id, source_id)])", name: "industry_pair_uniq", unique: true
    t.index ["source_id"], name: "index_industry_relationships_on_source_id"
    t.index ["target_id"], name: "index_industry_relationships_on_target_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_languages_on_name", unique: true
  end

  create_table "match_stores", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "closed_by_id"
    t.datetime "closed_at", precision: 6
    t.index "(ARRAY[LEAST(source_id, target_id), GREATEST(target_id, source_id)])", name: "match_store_pair_uniq", unique: true
    t.index ["closed_by_id"], name: "index_match_stores_on_closed_by_id"
    t.index ["source_id"], name: "index_match_stores_on_source_id"
    t.index ["target_id"], name: "index_match_stores_on_target_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "match_store_id", null: false
    t.text "content"
    t.bigint "author_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "client_id"
    t.datetime "deleted_at", precision: 6
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["match_store_id"], name: "index_messages_on_match_store_id"
  end

  create_table "read_marks", id: :serial, force: :cascade do |t|
    t.string "readable_type", null: false
    t.uuid "readable_id"
    t.string "reader_type", null: false
    t.integer "reader_id"
    t.datetime "timestamp"
    t.index ["readable_type", "readable_id"], name: "index_read_marks_on_readable"
    t.index ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", unique: true
    t.index ["reader_type", "reader_id"], name: "index_read_marks_on_reader"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.string "crypted_token"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["crypted_token"], name: "index_refresh_tokens_on_crypted_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "religions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_religions_on_name", unique: true
  end

  create_table "smoking_preferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_smoking_preferences_on_name", unique: true
  end

  create_table "swipes", force: :cascade do |t|
    t.bigint "from_id", null: false
    t.bigint "to_id", null: false
    t.integer "direction", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_id", "to_id"], name: "index_swipes_on_from_id_and_to_id", unique: true
    t.index ["from_id"], name: "index_swipes_on_from_id"
    t.index ["to_id"], name: "index_swipes_on_to_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_universities_on_name", unique: true
  end

  create_table "user_gender_interests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "gender_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gender_id"], name: "index_user_gender_interests_on_gender_id"
    t.index ["user_id"], name: "index_user_gender_interests_on_user_id"
  end

  create_table "user_languages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "user_report_reasons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_reports", force: :cascade do |t|
    t.bigint "from_id", null: false
    t.bigint "for_id", null: false
    t.bigint "user_report_reason_id", null: false
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["for_id"], name: "index_user_reports_on_for_id"
    t.index ["from_id", "for_id"], name: "index_user_reports_on_from_id_and_for_id", unique: true
    t.index ["from_id"], name: "index_user_reports_on_from_id"
    t.index ["user_report_reason_id"], name: "index_user_reports_on_user_report_reason_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.date "birthday"
    t.string "facebook_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "industry_id"
    t.bigint "company_id"
    t.bigint "work_title_id"
    t.bigint "gender_id"
    t.integer "interested_age_lower"
    t.integer "interested_age_upper"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.integer "search_radius", default: 0
    t.string "google_id"
    t.string "linkedin_url"
    t.string "country_code"
    t.string "locality"
    t.boolean "linkedin_public", default: false
    t.json "fcm", default: {}
    t.string "bio"
    t.bigint "hometown_city_id"
    t.string "hometown_country"
    t.bigint "religion_id"
    t.integer "height_in_cms"
    t.bigint "food_preference_id"
    t.bigint "drinking_preference_id"
    t.bigint "smoking_preference_id"
    t.bigint "children_preference_id"
    t.integer "status", default: 0
    t.datetime "last_logged_in", precision: 6
    t.bigint "exercise_preference_id"
    t.index ["children_preference_id"], name: "index_users_on_children_preference_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["drinking_preference_id"], name: "index_users_on_drinking_preference_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["exercise_preference_id"], name: "index_users_on_exercise_preference_id"
    t.index ["food_preference_id"], name: "index_users_on_food_preference_id"
    t.index ["gender_id"], name: "index_users_on_gender_id"
    t.index ["hometown_city_id"], name: "index_users_on_hometown_city_id"
    t.index ["industry_id"], name: "index_users_on_industry_id"
    t.index ["religion_id"], name: "index_users_on_religion_id"
    t.index ["smoking_preference_id"], name: "index_users_on_smoking_preference_id"
    t.index ["work_title_id"], name: "index_users_on_work_title_id"
  end

  create_table "verification_files", force: :cascade do |t|
    t.integer "file_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "file_type"], name: "index_verification_files_on_user_id_and_file_type", unique: true
    t.index ["user_id"], name: "index_verification_files_on_user_id"
  end

  create_table "verification_requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.boolean "linkedin_approved", default: false
    t.boolean "work_details_approved", default: false
    t.boolean "education_approved", default: false
    t.boolean "identity_approved", default: false
    t.boolean "selfie_approved", default: false
    t.boolean "dob_approved", default: false
    t.string "rejection_reason"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "user_updates", default: [], array: true
    t.index ["user_id"], name: "index_verification_requests_on_user_id"
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: 6
    t.text "object_changes"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  create_table "work_title_relationships", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "(ARRAY[LEAST(source_id, target_id), GREATEST(target_id, source_id)])", name: "work_title_pair_uniq", unique: true
    t.index ["source_id"], name: "index_work_title_relationships_on_source_id"
    t.index ["target_id"], name: "index_work_title_relationships_on_target_id"
  end

  create_table "work_titles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_work_titles_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "background_migration_jobs", "background_migrations", column: "migration_id", on_delete: :cascade
  add_foreign_key "course_relationships", "courses", column: "source_id"
  add_foreign_key "course_relationships", "courses", column: "target_id"
  add_foreign_key "educations", "courses"
  add_foreign_key "educations", "universities"
  add_foreign_key "educations", "users"
  add_foreign_key "industry_relationships", "industries", column: "source_id"
  add_foreign_key "industry_relationships", "industries", column: "target_id"
  add_foreign_key "match_stores", "users", column: "closed_by_id"
  add_foreign_key "match_stores", "users", column: "source_id"
  add_foreign_key "messages", "match_stores"
  add_foreign_key "messages", "users", column: "author_id"
  add_foreign_key "swipes", "users", column: "from_id"
  add_foreign_key "swipes", "users", column: "to_id"
  add_foreign_key "user_gender_interests", "genders"
  add_foreign_key "user_gender_interests", "users"
  add_foreign_key "user_languages", "languages"
  add_foreign_key "user_languages", "users"
  add_foreign_key "user_reports", "user_report_reasons"
  add_foreign_key "user_reports", "users", column: "for_id"
  add_foreign_key "user_reports", "users", column: "from_id"
  add_foreign_key "users", "cities", column: "hometown_city_id"
  add_foreign_key "verification_files", "users"
  add_foreign_key "work_title_relationships", "work_titles", column: "source_id"
  add_foreign_key "work_title_relationships", "work_titles", column: "target_id"

  create_view "work_title_connections", sql_definition: <<-SQL
      SELECT work_title_relationships.source_id AS work_title_id,
      work_title_relationships.target_id AS related_work_title_id
     FROM work_title_relationships
  UNION
   SELECT work_title_relationships.target_id AS work_title_id,
      work_title_relationships.source_id AS related_work_title_id
     FROM work_title_relationships;
  SQL
  create_view "course_connections", sql_definition: <<-SQL
      SELECT course_relationships.source_id AS course_id,
      course_relationships.target_id AS related_course_id
     FROM course_relationships
  UNION
   SELECT course_relationships.target_id AS course_id,
      course_relationships.source_id AS related_course_id
     FROM course_relationships;
  SQL
  create_view "industry_connections", sql_definition: <<-SQL
      SELECT industry_relationships.source_id AS industry_id,
      industry_relationships.target_id AS related_industry_id
     FROM industry_relationships
  UNION
   SELECT industry_relationships.target_id AS industry_id,
      industry_relationships.source_id AS related_industry_id
     FROM industry_relationships;
  SQL
  create_view "matches", sql_definition: <<-SQL
      SELECT match_stores.source_id AS user_id,
      match_stores.target_id AS matched_user_id,
      match_stores.id,
      match_stores.created_at,
      match_stores.updated_at,
      match_stores.closed_by_id,
      match_stores.closed_at
     FROM match_stores
  UNION
   SELECT match_stores.target_id AS user_id,
      match_stores.source_id AS matched_user_id,
      match_stores.id,
      match_stores.created_at,
      match_stores.updated_at,
      match_stores.closed_by_id,
      match_stores.closed_at
     FROM match_stores;
  SQL
end
