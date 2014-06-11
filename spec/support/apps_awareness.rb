# require 'active_support/inflector'

module AppsAwareness
	module ClassMethods
		
	end
	
	module InstanceMethods
		def on_app(name)
			@current_app_name = name
			yield
			@current_app_name = nil
		end

		def method_missing(method_name, *args, &block)
			if(method_name.to_s.end_with? "_page")
				class_name = method_name.to_s.classify
				full_name = @current_app_name.nil? ?  class_name :  @current_app_name.to_s.classify + "::" + class_name
				full_name.constantize.new
			else
				super
			end
  		end  
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end