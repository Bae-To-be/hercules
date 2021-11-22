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

ActiveRecord::Schema.define(version: 2021_11_22_161226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

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
    t.index ["source_id"], name: "index_course_relationships_on_source_id"
    t.index ["target_id"], name: "index_course_relationships_on_target_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_courses_on_name", unique: true
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

  create_table "genders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_genders_on_name", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.boolean "profile_picture", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "refresh_tokens", force: :cascade do |t|
    t.string "crypted_token"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["crypted_token"], name: "index_refresh_tokens_on_crypted_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
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
    t.boolean "student", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender_id"], name: "index_users_on_gender_id"
    t.index ["industry_id"], name: "index_users_on_industry_id"
    t.index ["work_title_id"], name: "index_users_on_work_title_id"
  end

  create_table "work_title_relationships", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "(ARRAY[LEAST(source_id, target_id), GREATEST(target_id, source_id)])", name: "course_pair_uniq", unique: true
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
  add_foreign_key "course_relationships", "courses", column: "source_id"
  add_foreign_key "course_relationships", "courses", column: "target_id"
  add_foreign_key "educations", "courses"
  add_foreign_key "educations", "universities"
  add_foreign_key "educations", "users"
  add_foreign_key "industry_relationships", "industries", column: "source_id"
  add_foreign_key "industry_relationships", "industries", column: "target_id"
  add_foreign_key "swipes", "users", column: "from_id"
  add_foreign_key "swipes", "users", column: "to_id"
  add_foreign_key "user_gender_interests", "genders"
  add_foreign_key "user_gender_interests", "users"
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
end
