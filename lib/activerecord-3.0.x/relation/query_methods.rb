#This fixes the precendence of multiple order by conditions for *most* types of queries. By default rails gets this backwards.
#Eg. Customer.order(:id).order(:email) incorrectly generates the following:
# SELECT `customers`.* FROM `customers` ORDER BY id, email
#with this patch, the precendence is reversed, so in the above example it would be:
# SELECT `customers`.* FROM `customers` ORDER BY email, id
#https://github.com/rails/rails/pull/2008
module ActiveRecord
  module QueryMethods

    def order(*args)
      relation = clone
      relation.order_values = args.flatten + relation.order_values unless args.blank?
      relation
    end

    def joins(*args)
      relation = clone

      args.flatten!
      relation.joins_values += args unless args.blank?

      apply_order_default_scopes(relation, *args)
    end

    private

    def apply_order_default_scopes(relation, *args)
      return relation if args.empty?

      all_joins_reflections = relation.reflect_on_all_associations
      args.each do |item|
        arg_reflection = get_reflection_by_name all_joins_reflections, item
        next unless arg_reflection

        arg_reflection.klass.default_scoping.each do |scope|
          relation.order_values += scope.is_a?(Hash) ? apply_finder_options(scope).order_values : scope.order_values
        end
      end

      relation
    end

    def get_reflection_by_name(reflections, name)
      return nil if name.class != Symbol
      reflection_index = reflections.rindex { |ref| ref.name.to_s == name.to_s }
      return nil unless reflection_index
      reflections[reflection_index]
    end

  end
end