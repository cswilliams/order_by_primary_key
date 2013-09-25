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
      relation.order_values = args.flatten + relation.order_values
      relation
    end

  end
end