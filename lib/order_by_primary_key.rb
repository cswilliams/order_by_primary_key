raise "order_by_primary_key plugin is not supported on this version of Rails!" unless ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR == 1

Dir.glob(File.expand_path(File.dirname(__FILE__) + "/activerecord-3.1.x/**/*.rb")).each do |patch|
  require patch
end

class ActiveRecord::Base

  def self.default_scopes
    primary_key_scope = { order: "#{self.table_name}.#{self.primary_key}" }
    @default_scopes ||= []
    @default_scopes << primary_key_scope unless @default_scopes.include? primary_key_scope
    @default_scopes
  end

  def self.default_scope(scope = {})
    scope = Proc.new if block_given?
    def_scopes = self.default_scopes
    if def_scopes.length > 0
      primary_key_scope = def_scopes.pop
      self.default_scopes = def_scopes + [scope] + [primary_key_scope]
    else
      self.default_scopes = def_scopes + [scope]
    end
  end

end