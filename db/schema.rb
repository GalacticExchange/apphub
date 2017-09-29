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

ActiveRecord::Schema.define(version: 20170518143051) do

  create_table "cms_languages", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "title",     limit: 250
    t.string  "lang",      limit: 4
    t.boolean "enabled",               default: true,              null: false, unsigned: true
    t.string  "charset",   limit: 15,  default: "utf8_unicode_ci", null: false
    t.string  "locale",                                            null: false
    t.string  "lang_html", limit: 10,                              null: false
    t.integer "pos",                                               null: false
    t.string  "countries",                                         null: false
    t.index ["lang"], name: "idxLang", unique: true, using: :btree
  end

  create_table "cms_mediafiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "media_type"
    t.string   "path"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "cms_pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci PACK_KEYS=0" do |t|
    t.string   "title",                                       null: false
    t.string   "name"
    t.string   "url"
    t.integer  "url_parts_count",   limit: 1, default: 0,     null: false, unsigned: true
    t.integer  "url_vars_count",    limit: 1, default: 0,     null: false, unsigned: true
    t.string   "parsed_url"
    t.integer  "parent_id",                   default: 0,     null: false
    t.string   "view_path"
    t.boolean  "is_translated",               default: false, null: false, unsigned: true
    t.integer  "status",                      default: 0,     null: false
    t.integer  "pos",                         default: 0,     null: false
    t.string   "redir_url"
    t.integer  "template_id"
    t.integer  "layout_id"
    t.integer  "owner"
    t.boolean  "is_folder",                   default: false, null: false, unsigned: true
    t.string   "controller_action"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "enabled",           limit: 1, default: 1,     null: false, unsigned: true
    t.index ["name"], name: "index_cms_pages_on_name", using: :btree
    t.index ["parent_id"], name: "parent_id", using: :btree
    t.index ["status"], name: "status", using: :btree
    t.index ["url"], name: "url", using: :btree
  end

  create_table "cms_pages_translation", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci PACK_KEYS=0" do |t|
    t.integer "item_id",                         default: 0, null: false, unsigned: true
    t.integer "page_id"
    t.string  "lang",              limit: 5,                 null: false
    t.string  "meta_title"
    t.text    "meta_description",  limit: 65535
    t.string  "meta_keywords"
    t.string  "template_filename"
    t.index ["item_id"], name: "item_id", using: :btree
    t.index ["lang"], name: "lang", using: :btree
    t.index ["template_filename"], name: "template", using: :btree
  end

  create_table "cms_resource_categories", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", limit: 250
  end

  create_table "cms_resource_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "cms_resource_id",               null: false
    t.string   "locale",                        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "content",         limit: 65535
    t.index ["cms_resource_id"], name: "index_cms_resource_translations_on_cms_resource_id", using: :btree
    t.index ["locale"], name: "index_cms_resource_translations_on_locale", using: :btree
  end

  create_table "cms_resources", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "name",        limit: 100
    t.string  "description", limit: 250
    t.integer "category_id"
    t.string  "def_value",               default: "",   null: false
    t.boolean "enabled",                 default: true, null: false, unsigned: true
  end

  create_table "cms_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci PACK_KEYS=0" do |t|
    t.string   "title",                                   null: false
    t.string   "name"
    t.string   "basename",                                null: false
    t.string   "basepath",                                null: false
    t.string   "basedirpath",                             null: false
    t.integer  "type_id",       limit: 1
    t.string   "tpl_format"
    t.integer  "pos"
    t.boolean  "is_translated",           default: false, null: false, unsigned: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "is_folder",               default: false, null: false
    t.boolean  "enabled",                 default: true,  null: false, unsigned: true
    t.string   "ancestry"
    t.index ["ancestry"], name: "ancestry", using: :btree
    t.index ["basepath"], name: "basepath", using: :btree
    t.index ["pos"], name: "pos", using: :btree
  end

  create_table "cms_templates_translation", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "item_id",           null: false, unsigned: true
    t.string  "lang",    limit: 5, null: false
    t.index ["item_id", "lang"], name: "item_id", unique: true, using: :btree
  end

  create_table "cms_templatetypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "name"
    t.string  "title"
    t.integer "pos",   null: false
  end

  create_table "cms_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_optimacms_cms_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_optimacms_cms_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "compose_apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text     "compose_file",              limit: 65535
    t.text     "dockerfiles_json",          limit: 65535
    t.text     "metadata_json",             limit: 65535
    t.string   "clair_report_file_name"
    t.string   "clair_report_content_type"
    t.integer  "clair_report_file_size"
    t.datetime "clair_report_updated_at"
    t.integer  "store_application_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["store_application_id"], name: "index_compose_apps_on_store_application_id", using: :btree
  end

  create_table "compose_apps_containers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "compose_app_id"
    t.integer "container_id"
    t.index ["compose_app_id"], name: "index_compose_apps_containers_on_compose_app_id", using: :btree
    t.index ["container_id"], name: "index_compose_apps_containers_on_container_id", using: :btree
  end

  create_table "containers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "github_user"
    t.string   "repo"
    t.string   "url_path"
    t.text     "launch_options",           limit: 65535
    t.text     "metadata_json",            limit: 65535
    t.string   "file_name"
    t.string   "name"
    t.text     "dockerfile",               limit: 65535
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.float    "size",                     limit: 24
    t.float    "ram",                      limit: 24
    t.integer  "status"
    t.string   "readme_file_file_name"
    t.string   "readme_file_content_type"
    t.integer  "readme_file_file_size"
    t.datetime "readme_file_updated_at"
    t.integer  "source_type"
    t.string   "short_description"
    t.text     "nmap_services",            limit: 65535
    t.integer  "store_application_id"
    t.string   "os_whole_name"
    t.integer  "os_short_name"
    t.string   "report_file_file_name"
    t.string   "report_file_content_type"
    t.integer  "report_file_file_size"
    t.datetime "report_file_updated_at"
    t.index ["store_application_id"], name: "index_containers_on_store_application_id", using: :btree
  end

  create_table "containers_tmp", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "id",                                    default: 0,      null: false
    t.string   "github_user",                                                         collation: "utf8mb4_unicode_ci"
    t.string   "repo",                                                                collation: "utf8mb4_unicode_ci"
    t.string   "url_path",                                                            collation: "utf8mb4_unicode_ci"
    t.text     "launch_options",     limit: 4294967295,                               collation: "utf8mb4_unicode_ci"
    t.text     "raw_launch_options", limit: 4294967295,                               collation: "utf8mb4_unicode_ci"
    t.string   "file_name",                                                           collation: "utf8mb4_unicode_ci"
    t.text     "clair_report",       limit: 4294967295,                               collation: "utf8mb4_unicode_ci"
    t.text     "readme",             limit: 4294967295,                               collation: "utf8mb4_unicode_ci"
    t.string   "security_rating",                       default: "None",              collation: "utf8mb4_unicode_ci"
    t.string   "download_link",                                                       collation: "utf8mb4_unicode_ci"
    t.string   "name",                                                                collation: "utf8mb4_unicode_ci"
    t.text     "dockerfile",         limit: 4294967295,                               collation: "utf8mb4_unicode_ci"
    t.text     "image_report",       limit: 4294967295,                               collation: "utf8mb4_unicode_ci"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "operating_system",                                                    collation: "utf8mb4_unicode_ci"
    t.float    "size",               limit: 24
    t.float    "ram",                limit: 24
  end

  create_table "operating_systems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "container_id"
    t.integer  "short_name",   limit: 1
    t.string   "whole_name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["container_id"], name: "index_operating_systems_on_container_id", using: :btree
  end

  create_table "optimacms_articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "title"
    t.text     "text",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "optimacms_cms_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_optimacms_cms_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_optimacms_cms_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.text     "os",               limit: 65535
    t.decimal  "min_size",                       precision: 10
    t.decimal  "max_size",                       precision: 10
    t.decimal  "min_ram",                        precision: 10
    t.decimal  "max_ram",                        precision: 10
    t.string   "security_rating"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "github_user"
    t.string   "order_by"
    t.string   "status"
    t.string   "source_type"
    t.string   "application_type"
  end

  create_table "security_ratings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "rating",                   limit: 1
    t.string   "report_file_name"
    t.string   "report_content_type"
    t.integer  "report_file_size"
    t.datetime "report_updated_at"
    t.integer  "container_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "report_json_file_name"
    t.string   "report_json_content_type"
    t.integer  "report_json_file_size"
    t.datetime "report_json_updated_at"
    t.index ["container_id"], name: "index_security_ratings_on_container_id", using: :btree
  end

  create_table "store_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "github_user"
    t.string   "repo"
    t.string   "url_path"
    t.string   "name"
    t.string   "short_description"
    t.integer  "clair_rating",                           default: 0
    t.integer  "source_type"
    t.integer  "application_type"
    t.integer  "status",                                 default: 0
    t.float    "size",                     limit: 24
    t.float    "ram",                      limit: 24
    t.text     "services_json",            limit: 65535
    t.string   "readme_file_file_name"
    t.string   "readme_file_content_type"
    t.integer  "readme_file_file_size"
    t.datetime "readme_file_updated_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "version_hash"
    t.text     "containers_json",          limit: 65535
    t.index ["github_user", "url_path"], name: "index_store_applications_on_github_user_and_url_path", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "item_type",  limit: 191,        null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "containers", "store_applications"
  add_foreign_key "security_ratings", "containers"
end
