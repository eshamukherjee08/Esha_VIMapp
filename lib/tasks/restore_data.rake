namespace :category do
  
  task :restore_data => :environment do
    Event.all.each do |element|
      element.category = (CATEGORY.index(element.category) + 1) # stores 1,2,3 instead of 0,1,2
    end
  end
end