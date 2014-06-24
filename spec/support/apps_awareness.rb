module AppsAwareness
	def go_to_app(name, &block)
		visit "/bahmni/#{name}"
		App.create(name, self).instance_eval(&block)
	end

	def login(*args)
    	go_to_app(:home) { login *args }
	end
end