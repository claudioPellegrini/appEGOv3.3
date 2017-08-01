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

ActiveRecord::Schema.define(version: 20170731164936) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bebidas", force: :cascade do |t|
    t.string   "nombre"
    t.string   "tipo"
    t.string   "tamanio"
    t.decimal  "precio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calificacions", force: :cascade do |t|
    t.integer  "compra_id"
    t.integer  "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compra_bebidas", force: :cascade do |t|
    t.integer  "compra_id"
    t.integer  "bebida_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cantidad"
    t.index ["bebida_id"], name: "index_compra_bebidas_on_bebida_id", using: :btree
    t.index ["compra_id"], name: "index_compra_bebidas_on_compra_id", using: :btree
  end

  create_table "compra_productos", force: :cascade do |t|
    t.integer  "compra_id"
    t.integer  "producto_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["compra_id"], name: "index_compra_productos_on_compra_id", using: :btree
    t.index ["producto_id"], name: "index_compra_productos_on_producto_id", using: :btree
  end

  create_table "compras", force: :cascade do |t|
    t.date     "fecha"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "cuenta_id"
    t.integer  "cuentum_id"
    t.integer  "valor_final_ticket"
    t.string   "estado"
    t.index ["cuenta_id"], name: "index_compras_on_cuenta_id", using: :btree
    t.index ["cuentum_id"], name: "index_compras_on_cuentum_id", using: :btree
  end

  create_table "cuenta", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "authentication_token",   limit: 30
    t.index ["authentication_token"], name: "index_cuenta_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_cuenta_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_cuenta_on_reset_password_token", unique: true, using: :btree
  end

  create_table "empresas", force: :cascade do |t|
    t.bigint   "rut"
    t.string   "nombre"
    t.string   "razon_social"
    t.bigint   "telefono"
    t.string   "direccion"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "franjas", force: :cascade do |t|
    t.datetime "fecha"
    t.decimal  "primera_hasta"
    t.decimal  "primera_precio"
    t.decimal  "segunda_hasta"
    t.decimal  "segunda_precio"
    t.decimal  "tercera_precio"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "fringes", force: :cascade do |t|
    t.datetime "fecha"
    t.decimal  "primera_hasta"
    t.decimal  "primera_precio"
    t.decimal  "segunda_hasta"
    t.decimal  "segunda_precio"
    t.decimal  "tercera_precio"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "menus", force: :cascade do |t|
    t.date     "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fecha"], name: "index_menus_on_fecha", unique: true, using: :btree
  end

  create_table "movimientos", force: :cascade do |t|
    t.integer  "id_bebida"
    t.datetime "fecha"
    t.integer  "cant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productos", force: :cascade do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "tipo_id"
    t.index ["tipo_id"], name: "index_productos_on_tipo_id", using: :btree
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "bebida_id"
    t.integer  "cant"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "factura_compra"
  end

  create_table "tiene_productos", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "producto_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["menu_id"], name: "index_tiene_productos_on_menu_id", using: :btree
    t.index ["producto_id"], name: "index_tiene_productos_on_producto_id", using: :btree
  end

  create_table "tipos", force: :cascade do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.integer  "ci"
    t.string   "nombres"
    t.string   "apellidos"
    t.string   "rol"
    t.boolean  "habilitado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "empresa_id"
    t.integer  "cuenta_id"
    t.integer  "salario"
    t.index ["ci"], name: "index_usuarios_on_ci", unique: true, using: :btree
    t.index ["empresa_id"], name: "index_usuarios_on_empresa_id", using: :btree
  end

  add_foreign_key "compra_bebidas", "bebidas"
  add_foreign_key "compra_bebidas", "compras"
  add_foreign_key "compra_productos", "compras"
  add_foreign_key "compra_productos", "productos"
  add_foreign_key "compras", "cuenta"
  add_foreign_key "compras", "cuenta", column: "cuenta_id"
  add_foreign_key "productos", "tipos"
  add_foreign_key "tiene_productos", "menus"
  add_foreign_key "tiene_productos", "productos"
  add_foreign_key "usuarios", "empresas"
end
