# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

@admin = Admin.find_or_initialize_by_email 'esha.dummy@gmail.com'
@admin.password = 'password'
@admin.password_confirmation = 'password'
@admin.skip_confirmation!
@admin.save!


Category.find_or_initialize_by_name 'Ruby On Rails Developer'
Category.find_or_initialize_by_name 'Android Developer'
Category.find_or_initialize_by_name 'Project Manager'