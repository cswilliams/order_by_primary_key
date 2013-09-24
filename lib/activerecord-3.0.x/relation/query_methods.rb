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
      args.each do |item|
        next if item.class != Symbol

        item.to_s.singularize.camelize.constantize.default_scoping.each do |scope|
          relation.order_values += scope.is_a?(Hash) ? apply_finder_options(scope).order_values : scope.order_values
        end
      end
      relation
    end

  end
end