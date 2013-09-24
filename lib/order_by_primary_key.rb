raise "order_by_primary_key plugin is not supported on this version of Rails!" unless ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR == 0

Dir.glob(File.expand_path(File.dirname(__FILE__) + "/activerecord-3.0.x/**/*.rb")).each do |patch|
  require patch
end


class ActiveRecord::Base

  def self.default_scoping
    @default_scoping ||= []
    if @default_scoping.empty?
      primary_key_scope = construct_finder_arel({ order: "#{self.table_name}.#{self.primary_key}" }, @default_scoping.pop)
      @default_scoping << primary_key_scope
    end
    @default_scoping
  end

  def self.default_scope(options = {})
    reset_scoped_methods
    self.default_scoping << construct_finder_arel(options, self.default_scoping.pop)

    primary_key_scope = "#{self.table_name}.#{self.primary_key}"
    self.default_scoping.each do |relation|
      if relation.order_values.size > 1 && relation.order_values.include?(primary_key_scope)
        relation.order_values.delete(primary_key_scope)
        relation.order_values = relation.order_values + [primary_key_scope]
      end
    end
  end

end