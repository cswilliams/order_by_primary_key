#This adds an ORDER BY for eager loading joins
#e.g.
#o = Order.find(:all, :include => :line_items, :conditions => "line_items.rental_period = '90'")
#o.line_items will now be ordered correctly
module ActiveRecord
  module FinderMethods
    def apply_join_dependency(relation, join_dependency)      
    
       for association in join_dependency.join_associations
         relation = association.join_relation(relation)
         association.klass.default_scoping.each do |default_scope_relation|
           relation.order_values += default_scope_relation.order_values
         end
       end

       limitable_reflections = using_limitable_reflections?(join_dependency.reflections)
    
       if !limitable_reflections && relation.limit_value
         limited_id_condition = construct_limited_ids_condition(relation.except(:select))
         relation = relation.where(limited_id_condition)
       end
    
       relation = relation.except(:limit, :offset) unless limitable_reflections
    
       relation
     end
  end
end