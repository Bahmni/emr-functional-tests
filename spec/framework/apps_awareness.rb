module AppsAwareness
    def go_to_app(name, &block)
        visit "/bahmni/#{name}"
        App.create(name, self).instance_eval(&block)
    end

    def log_in_to_app(name, credentials, &block)
        Capybara.reset_sessions!
        login credentials
        go_to_app name, &block
    end

    def login(credentials)
        go_to_app(:home) { login credentials }
    end
end