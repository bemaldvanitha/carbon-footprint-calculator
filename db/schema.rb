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

ActiveRecord::Schema[7.1].define(version: 2024_05_13_052841) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carbon_emissions", force: :cascade do |t|
    t.decimal "carbonEmission"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carbon_emissions_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certification_types", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credits_validators", force: :cascade do |t|
    t.string "name"
    t.string "organization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.decimal "amount"
    t.string "stripeId"
    t.boolean "isContinues"
    t.boolean "isSuccess"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_payments_on_project_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "project_design_validators", force: :cascade do |t|
    t.string "name"
    t.string "organization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_developers", force: :cascade do |t|
    t.string "name"
    t.string "organization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_images", force: :cascade do |t|
    t.string "image"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_images_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.bigint "category_id", null: false
    t.string "featuredImage"
    t.text "summary"
    t.text "howItWork"
    t.bigint "location_id", null: false
    t.integer "activeSince"
    t.bigint "certification_type_id", null: false
    t.bigint "project_developer_id", null: false
    t.bigint "project_design_validator_id", null: false
    t.bigint "credits_validator_id"
    t.bigint "{:foreign_key=>true, :null=>false}_id"
    t.string "readMore"
    t.integer "totalCarbonCredits"
    t.integer "allocatedCarbonCredits"
    t.decimal "offsetRate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_projects_on_category_id"
    t.index ["certification_type_id"], name: "index_projects_on_certification_type_id"
    t.index ["credits_validator_id"], name: "index_projects_on_credits_validator_id"
    t.index ["location_id"], name: "index_projects_on_location_id"
    t.index ["project_design_validator_id"], name: "index_projects_on_project_design_validator_id"
    t.index ["project_developer_id"], name: "index_projects_on_project_developer_id"
    t.index ["{:foreign_key=>true, :null=>false}_id"], name: "index_projects_on_{:foreign_key=>true, :null=>false}_id"
  end

  create_table "technical_documents", force: :cascade do |t|
    t.string "document"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_technical_documents_on_project_id"
  end

  create_table "temporary_users", force: :cascade do |t|
    t.string "ipAddress"
    t.decimal "carbonEmission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_types", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "phoneNumber"
    t.string "fullName"
    t.bigint "user_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_type_id"], name: "index_users_on_user_type_id"
  end

  add_foreign_key "carbon_emissions", "users"
  add_foreign_key "payments", "projects"
  add_foreign_key "payments", "users"
  add_foreign_key "project_images", "projects"
  add_foreign_key "projects", "categories"
  add_foreign_key "projects", "certification_types"
  add_foreign_key "projects", "locations"
  add_foreign_key "projects", "project_design_validators"
  add_foreign_key "projects", "project_developers"
  add_foreign_key "technical_documents", "projects"
  add_foreign_key "users", "user_types"
end
