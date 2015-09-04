module AppsAwareness
    def go_to_app(name, &block)
        visit '/bahmni/home'
        page.find("a", :text => name, :visible => :true).click
        App.create(name, self).instance_eval(&block)
    end

    def log_in_to_app(name, credentials, &block)
        Capybara.reset_sessions!
        login credentials
        go_to_app name, &block
    end

    def login(credentials)
        visit '/bahmni/home'
        loginApp = App.create("home", self)
        loginApp.login(credentials)
    end

    def log_in_as_different_user(name, &block)
        Capybara.reset_sessions!
        different_user = {:username => "automation", :password => "Admin123", :location => "OPD-1"}
        login(different_user)
        go_to_app name, &block
    end
end