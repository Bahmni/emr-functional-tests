class App 
    include Capybara::DSL
    include RSpec::Matchers
    include CapybaraDslExtensions

    def self.create(name, context)
        app_class_full_name = name.to_s.classify + '::' + 'App'
        app_class_full_name.constantize.new(context)
    end

    def initialize(context)
        @context = context
    end

    def method_missing(method, *args, &block)
        method_name = method.to_s
        if method_name.end_with? "_page"
            class_name = method_name.classify
            module_name = self.class.name.deconstantize
            full_name = module_name + "::" + class_name
            full_name.constantize.new
        elsif @context.respond_to? method
            @context.send method, *args, &block
        else
            super
        end
    end  
end