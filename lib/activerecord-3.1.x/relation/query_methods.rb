#This fixes the precendence of multiple order by conditions for *most* types of queries. By default rails gets this backwards.
#Eg. Customer.order(:id).order(:email) incorrectly generates the following:
# SELECT `customers`.* FROM `customers` ORDER BY id, email
#with this patch, the precendence is reversed, so in the above example it would be:
# SELECT `customers`.* FROM `customers` ORDER BY email, id
#https://github.com/rails/rails/pull/2008
module ActiveRecord
  module QueryMethods
    def order(*args)
      return self if args.blank?
      
      relation = clone
      relation.order_values = args.concat relation.order_values
      relation
    end

    def joins(*args)
      return self if args.compact.blank?

      relation = clone
      args.flatten!
      relation.joins_values += args
      args.each do |item|
        if item.class == Symbol
          item.to_s.singularize.camelize.constantize.default_scopes.each do |scope|
            if scope.is_a?(Hash)
              relation.order_values +=  apply_finder_options(scope).order_values
            else
              relation.order_values +=  scope.order_values
            end
          end
        end
      end
      relation
    end
    
    
  end
end