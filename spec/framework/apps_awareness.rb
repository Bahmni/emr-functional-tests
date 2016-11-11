module AppsAwareness
    include Capybara::DSL
    include RSpec::Matchers
    include CapybaraDslExtensions
    def go_to_app(name, online = true, &block)
        visit '/bahmni/home' if online
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

    def log_in_to_erp(&block)
        Capybara.reset_sessions!
        visit (Settings.root_url.gsub("https://","http://") + ':8069')
        loginApp = App.create("erp", self)
        loginApp.login
        App.create("erp", self).instance_eval(&block)
    end

    def log_in_to_elis(&block)
         Capybara.reset_sessions!
        visit '/openelis'
        loginApp = App.create("eli", self)
        loginApp.login
        App.create("eli", self).instance_eval(&block)
    end

    def offline_first_login(credentials)
        visit '/index.html'
        fill_in "Please Enter IP", :with => '172.18.2.44'
        click_on 'Enter'
        page.accept_alert
        loginApp = App.create("home", self)
        loginApp.login(credentials)
        Capybara.default_wait_time = 800
        wait_until { page.find('.secondary-button') }
        click_on("OK")
        Capybara.default_wait_time = 30
    end

    def offline_login(name, credentials, &block)
        visit '/index.html'
        loginApp = App.create("home", self)
        loginApp.login(credentials)
        go_to_app name,false, &block
    end

    def log_in_as_different_user(name, &block)
        Capybara.reset_sessions!
        different_user = {:username => "automation", :password => "Admin123", :location => "OPD-1"}
        login(different_user)
        go_to_app name, &block
    end
end
