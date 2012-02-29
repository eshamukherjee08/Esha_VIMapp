module ApplicationHelper
  # def link_to_remove_field(name, b)
  #    b.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
  # end
  # 
  # def link_to_add_field(name, f, association)  
  #   new_object = f.object.class.reflect_on_association(association).klass.new  
  #   field = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
  #     render :partial => "batch_fields", :locals => {:builder => builder}  
  #   end  
  #   link_to_function(name, "add_field(this, \"#{association}\", \"#{escape_javascript(field)}\")" )  
  # end
  
  # def link_to_add_field(form_builder)
  #   link_to_function 'add_field' do |page|
  #     form_builder.fields_for :batches, Batch.new, :child_index => 'NEW_RECORD' do |f|
  #       html = render(:partial => 'batch_fields', :locals => { :builder => f })
  #       page << "$('batches').insertAfter({ bottom: '#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()) });"
  #     end
  #   end
  # end
  # 
end
