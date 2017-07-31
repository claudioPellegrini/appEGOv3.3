class Producto < ApplicationRecord
	has_many :tiene_productos
	has_many :menus, through: :tiene_productos
	belongs_to :tipo, optional: true
	has_many :compra_productos
	has_many :compras, through: :compra_productos
	validates :nombre, presence: {message: "^Debe ingresar un nombre"}
	validates :descripcion, presence: {message: "^Debe ingresar una descripción"}
	validates :tipo_id, presence: {message: "^Debe seleccionar un tipo"}
	validates :cantidad, presence: {message: "^Debe ingresar cantidad"}
end
