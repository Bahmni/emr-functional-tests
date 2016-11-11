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

  def wait_for_erploading_to_complete
      wait_for_element_with_css_to_be_visible('.oe_view_manager')
      wait_until { !page.find('.oe_loading').visible? }
      sleep 1
  end

  def wait_for_element_with_xpath_to_be_visible(locator)
    wait_until { page.find(:xpath,locator).visible? }
  end

  def wait_for_element_with_css_to_be_visible(locator)
    wait_until { page.find(:css,locator).visible? }
  end

  def wait_for_element_with_css_with_text(locator,text)
    wait_until { page.find("#{locator}",:text=>text).visible? }
  end

  def wait_for_retro_widget_to_load
    wait_until { page.find('.retro-date-widget-panel').visible? }
  end

  def wait_for_autocomplete_to_be_populated
    wait_until {page.find('.ui-autocomplete', :visible => true ) }
  end

  def create_drug_details_string(drug)
    sos = "SOS" if drug[:sos]
    dose = drug[:dose] if drug.has_key? :dose
  else
    if drug.has_key? :morning_dose
      dose = [drug[:morning_dose], drug[:noon_dose], drug[:night_dose]].join('-')
    end
    drug_details = [dose, drug[:dose_unit]].reject { |s| s.nil? || s.empty? }.join(' ').concat(", ")
    drug_details.concat([drug[:frequency], drug[:instructions], sos, drug[:drug_route]].reject { |s| s.nil? || s.empty? }.join(', ')).concat(" - ")
    drug_details.concat([drug[:duration], drug[:duration_unit]].reject { |s| s.nil? || s.empty? }.join(' '))
    drug_details = [drug[:drug_name], drug_details].reject { |s| s.nil? || s.empty? }.join(' ')
    drug_details
  end

  def find_section(name)
    find('.dashboard-section h2', :text => name).parent
  end

  def wait_for_loader_to_be_hidden
    wait_until  {! page.find('#loader').visible? }
  end

end
