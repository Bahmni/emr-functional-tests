class App 
	include Capybara::DSL
	include RSpec::Matchers
	include CapybaraDslExtensions

	def self.create(name, spec)
		app_class_full_name = name.to_s.classify + '::' + 'App'
		app_class_full_name.constantize.new(spec)
	end

	def initialize(spec)
		@spec = spec
	end

	def method_missing(method, *args, &block)
		method_name = method.to_s
		if method_name.end_with? "_page"
			class_name = method_name.classify
			module_name = self.class.name.deconstantize
			full_name = module_name + "::" + class_name
			full_name.constantize.new
		elsif @spec.respond_to? method
    		@spec.send method, *args, &block
		else
			super
		end
	end  
end