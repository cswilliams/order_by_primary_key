#This adds an ORDER BY for eager loading joins
#e.g.
#o = Order.find(:all, :include => :line_items, :conditions => "line_items.rental_period = '90'")
#o.line_items will now be ordered correctly
module ActiveRecord
  module FinderMethods
    def apply_join_dependency(relation, join_dependency)
      join_dependency.join_associations.each do |association|
        relation = association.join_relation(relation)

        association.reflection.klass.default_scopes.each do |scope|
          relation.order_values += (scope.is_a?(Hash) ? apply_finder_options(scope) : scope).order_values
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