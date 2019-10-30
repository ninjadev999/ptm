# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_25_195045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_public_sites", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "public_site_id"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_public_sites_on_account_id"
    t.index ["public_site_id"], name: "index_account_public_sites_on_public_site_id"
  end

  create_table "account_social_sites", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "social_site_id"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_social_sites_on_account_id"
    t.index ["social_site_id"], name: "index_account_social_sites_on_social_site_id"
  end

  create_table "account_users", force: :cascade do |t|
    t.integer "account_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "user_id"], name: "index_account_users_on_account_id_and_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "admin_id"
    t.string "stripe_customer_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "interviewer", default: false
    t.integer "max_units", default: 1, null: false
    t.text "description"
    t.string "time_zone"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.boolean "wants_help_finding_interviewees", default: false
    t.integer "max_resolution", default: 1
    t.integer "audio_visual_download_options", default: 1
    t.integer "audio_download_formats", default: 0
    t.bigint "downloads_per_episode"
    t.bigint "social_media_followers"
    t.index ["admin_id"], name: "index_accounts_on_admin_id"
    t.index ["stripe_customer_id"], name: "index_accounts_on_stripe_customer_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id"
    t.string "easypost_address_id"
    t.string "name"
    t.string "street1"
    t.string "street2"
    t.string "street3"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "phone"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["easypost_address_id"], name: "index_addresses_on_easypost_address_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "average_caches", force: :cascade do |t|
    t.bigint "rater_id"
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "avg", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_type", "rateable_id"], name: "index_average_caches_on_rateable_type_and_rateable_id"
    t.index ["rater_id"], name: "index_average_caches_on_rater_id"
  end

  create_table "bundles", force: :cascade do |t|
    t.string "name"
    t.integer "price_in_cents"
    t.integer "number_of_interviews"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compositions", force: :cascade do |t|
    t.integer "interview_id"
    t.jsonb "twilio_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "last_4"
    t.string "kind"
    t.integer "exp_mo"
    t.integer "exp_year"
    t.string "stripe_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_credit_cards_on_owner_id_and_owner_type"
    t.index ["stripe_card_id"], name: "index_credit_cards_on_stripe_card_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.integer "account_id"
    t.string "twilio_sid"
    t.string "code"
    t.datetime "starts_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "twilio_data", default: {}
    t.integer "duration_in_seconds"
    t.integer "size_in_bytes"
    t.integer "state", default: -1
    t.text "read_ahead"
    t.datetime "read_ahead_opened_at"
    t.datetime "completed_at"
    t.datetime "accepted_at"
    t.boolean "needs_hardware", default: false
    t.boolean "free", default: false
    t.integer "addon_seats", default: 0
    t.text "ideal_guest_desc"
    t.text "ideal_listener_action"
    t.integer "category_id"
    t.boolean "posting", default: false, null: false
    t.integer "max_resolution", default: 1
    t.integer "audio_visual_download_options", default: 1
    t.integer "audio_download_formats", default: 0
    t.integer "prep_stage", default: 1
    t.integer "guest_id"
    t.string "type", null: false
    t.index ["account_id"], name: "index_interviews_on_account_id"
    t.index ["code"], name: "index_interviews_on_code", unique: true
    t.index ["state"], name: "index_interviews_on_state"
    t.index ["twilio_sid"], name: "index_interviews_on_twilio_sid", unique: true
  end

  create_table "invites", force: :cascade do |t|
    t.integer "interview_id"
    t.string "name"
    t.string "email"
    t.string "confirmation_status", default: "invited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "code"
    t.integer "status", default: 10
    t.integer "account_id"
    t.integer "guest_id"
    t.datetime "ready_at"
    t.index ["interview_id"], name: "index_invites_on_interview_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "account_id"
    t.string "stripe_invoice_id"
    t.jsonb "stripe_data"
    t.datetime "issued_at"
    t.datetime "due_date"
    t.integer "status"
    t.string "number"
    t.integer "total_in_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["account_id"], name: "index_invoices_on_account_id"
    t.index ["number"], name: "index_invoices_on_number"
    t.index ["status"], name: "index_invoices_on_status"
    t.index ["stripe_invoice_id"], name: "index_invoices_on_stripe_invoice_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "labels", force: :cascade do |t|
    t.integer "to_address_id"
    t.integer "from_address_id"
    t.string "tracking_number"
    t.string "label_url"
    t.string "easypost_postage_label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
    t.index ["easypost_postage_label_id"], name: "index_labels_on_easypost_postage_label_id"
    t.index ["from_address_id"], name: "index_labels_on_from_address_id"
    t.index ["order_id"], name: "index_labels_on_order_id"
    t.index ["to_address_id"], name: "index_labels_on_to_address_id"
    t.index ["tracking_number"], name: "index_labels_on_tracking_number"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "unit_id"
    t.integer "account_id"
    t.integer "user_id"
    t.integer "interviewee_id"
    t.integer "shipping_label_id"
    t.integer "return_label_id"
    t.integer "address_id"
    t.integer "credit_card_id"
    t.string "token"
    t.date "interview_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "aasm_state"
    t.datetime "canceled_at"
    t.string "name"
    t.string "company"
    t.index ["aasm_state"], name: "index_orders_on_aasm_state"
    t.index ["account_id"], name: "index_orders_on_account_id"
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["email"], name: "index_orders_on_email"
    t.index ["interviewee_id"], name: "index_orders_on_interviewee_id"
    t.index ["return_label_id"], name: "index_orders_on_return_label_id"
    t.index ["shipping_label_id"], name: "index_orders_on_shipping_label_id"
    t.index ["token"], name: "index_orders_on_token"
    t.index ["unit_id"], name: "index_orders_on_unit_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "overall_averages", force: :cascade do |t|
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "overall_avg", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_type", "rateable_id"], name: "index_overall_averages_on_rateable_type_and_rateable_id"
  end

  create_table "plans", force: :cascade do |t|
    t.integer "amount_in_cents"
    t.string "interval"
    t.integer "interval_count"
    t.string "nickname"
    t.integer "trial_period_days"
    t.string "stripe_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.index ["stripe_plan_id"], name: "index_plans_on_stripe_plan_id"
  end

  create_table "podcast_invites", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "user_id"
    t.integer "host_id"
    t.string "name"
    t.string "email"
    t.string "confirmation_status", default: "invited"
    t.integer "status", default: 10
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_podcast_invites_on_account_id"
    t.index ["user_id"], name: "index_podcast_invites_on_user_id"
  end

  create_table "profile_social_sites", force: :cascade do |t|
    t.bigint "profile_id"
    t.bigint "social_site_id"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_profile_social_sites_on_profile_id"
    t.index ["social_site_id"], name: "index_profile_social_sites_on_social_site_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.text "bio"
    t.bigint "user_id"
    t.string "primary_industry"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "public_sites", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "rater_id"
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "stars", null: false
    t.string "dimension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
    t.index ["rateable_type", "rateable_id"], name: "index_rates_on_rateable_type_and_rateable_id"
    t.index ["rater_id"], name: "index_rates_on_rater_id"
  end

  create_table "rating_caches", force: :cascade do |t|
    t.string "cacheable_type"
    t.bigint "cacheable_id"
    t.float "avg", null: false
    t.integer "qty", null: false
    t.string "dimension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"
    t.index ["cacheable_type", "cacheable_id"], name: "index_rating_caches_on_cacheable_type_and_cacheable_id"
  end

  create_table "recordings", force: :cascade do |t|
    t.string "twilio_sid"
    t.integer "interview_id"
    t.jsonb "twilio_data"
    t.integer "size_in_bytes"
    t.integer "duration_in_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["interview_id"], name: "index_recordings_on_interview_id"
    t.index ["twilio_sid"], name: "index_recordings_on_twilio_sid"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "twilio_sid"
    t.string "name"
    t.integer "user_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "uuid"
    t.index ["code"], name: "index_rooms_on_code"
    t.index ["status"], name: "index_rooms_on_status"
    t.index ["twilio_sid"], name: "index_rooms_on_twilio_sid"
    t.index ["user_id"], name: "index_rooms_on_user_id"
    t.index ["uuid"], name: "index_rooms_on_uuid"
  end

  create_table "social_sites", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_events", force: :cascade do |t|
    t.string "stripe_event_id"
    t.string "kind"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_stripe_events_on_kind"
    t.index ["stripe_event_id"], name: "index_stripe_events_on_stripe_event_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "account_id"
    t.string "stripe_subscription_id"
    t.integer "plan_id"
    t.string "status"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "current_period_end"
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["account_id"], name: "index_subscriptions_on_account_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["status"], name: "index_subscriptions_on_status"
    t.index ["stripe_subscription_id"], name: "index_subscriptions_on_stripe_subscription_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "track_sids", force: :cascade do |t|
    t.integer "interview_id"
    t.string "track_sid"
    t.integer "track_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["track_sid"], name: "index_track_sids_on_track_sid"
  end

  create_table "units", force: :cascade do |t|
    t.string "make"
    t.string "model"
    t.string "serial"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.string "first_name"
    t.string "last_name"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "single_itv_purchased", default: 0
    t.string "username"
    t.boolean "guest", default: false, null: false
    t.boolean "host", default: true, null: false
    t.integer "bundle_itv_purchased", default: 0, null: false
    t.string "provider"
    t.string "uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "account_public_sites", "accounts"
  add_foreign_key "account_public_sites", "public_sites"
  add_foreign_key "account_social_sites", "accounts"
  add_foreign_key "account_social_sites", "social_sites"
  add_foreign_key "profile_social_sites", "profiles"
  add_foreign_key "profile_social_sites", "social_sites"
  add_foreign_key "profiles", "users"
end
