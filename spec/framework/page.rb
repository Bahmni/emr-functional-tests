class Page 
    include Capybara::DSL
    include RSpec::Matchers
    include CapybaraDslExtensions

    def self.set_url(url)
        @@url = url
    end

    def open
        visit @@url
        self
    end

    def should_be_current_page
        url_template = Addressable::Template.new(@@url + '{?query_params*}')
        wait_until { !url_template.match(current_path_with_fragment).nil? }
    end

    def wait_for_overlay_to_be_hidden
        wait_until { !page.find('#overlay').visible? }
    end

    def open_side_panel
      find('button.toggle-patient').click
    end

    def navigate_to_visit_from_side_panel(visit_date)
      open_side_panel
      find("a", :text=>visit_date, :match => :prefer_exact).click
    end
end