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

ActiveRecord::Schema[7.1].define(version: 2024_04_08_044153) do
  create_table "comments", force: :cascade do |t|
    t.text "Comm_Body"
    t.integer "feature_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_comments_on_feature_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "Feat_ExternalId"
    t.string "Feat_ExternalUrl"
    t.string "Feat_Title"
    t.string "Feat_Place"
    t.string "Feat_MagType"
    t.float "Feat_Mag"
    t.float "Feat_Latitude"
    t.float "Feat_Longitude"
    t.datetime "Feat_Time"
    t.boolean "Feat_Tsunami"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Feat_ExternalId"], name: "index_features_on_Feat_ExternalId"
    t.index ["Feat_ExternalUrl"], name: "index_features_on_Feat_ExternalUrl"
  end

  add_foreign_key "comments", "features"
end
