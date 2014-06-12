module AppsAwareness
	def in_app(name)
		@current_app_name = name.to_s
		yield
		@current_app_name = nil
	end

	def go_to_app(name, &block)
		visit "/#{name}"
		in_app(name, &block)
	end

	def method_missing(method_name_symbol, *args, &block)
		method_name = method_name_symbol.to_s
		if(method_name.end_with?("_page") or method_name == "app")
			class_name = method_name.classify
			module_name = @current_app_name.nil? ? "" : @current_app_name.classify
			full_name = module_name + "::" + class_name
			full_name.constantize.new
		else
			super
		end
	end  
end