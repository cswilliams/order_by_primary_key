if ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR == 0
  Dir.glob(File.expand_path(File.dirname(__FILE__) + "/activerecord-3.0.x/**/*.rb")).each do |patch| 
    require patch
  end
elsif ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR == 1
  Dir.glob(File.expand_path(File.dirname(__FILE__) + "/activerecord-3.1.x/**/*.rb")).each do |patch| 
    require patch
  end
else
  raise "order_by_primary_key plugin is not supported on this version of Rails!"
end

module OrderByPrimaryKeyEngine
  class Engine < Rails::Engine
    initializer "order_by_primary_key.add_default_scope_to_all_models", :after => "load_config_initializers" do
      model_classes = ActiveRecord::Base.connection.tables.collect{|t| t.classify.constantize rescue nil }.compact
      model_classes.each do |klass|
        if defined?(ORDER_BY_PRIMARY_KEY_SKIP_TABLES) && ORDER_BY_PRIMARY_KEY_SKIP_TABLES.include?(klass.to_s)
          next
        end
                
        klass.class_eval do
          a_scope = "#{self.table_name}.#{self.primary_key}"
          default_scope :order => a_scope
       
          #move the default scope to the end if there are other order by default scopes on this model already
          if ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR == 0
            klass.default_scoping.each do |relation|
              if relation.order_values.size > 1 && relation.order_values.include?(a_scope)
                relation.order_values.delete(a_scope)
                relation.order_values = relation.order_values + [a_scope]
              end
            end
          elsif ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR == 1
            if klass.default_scopes.size > 1
              primary_key_scope = klass.default_scopes.delete(:order => a_scope)
              klass.default_scopes = [primary_key_scope] + klass.default_scopes
            end
          end          
        end
      end
    end
  end
end