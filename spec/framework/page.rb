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

  def verify_drug_details(section, *drugs)
    table = page.find(section)
    drugs.each do |drug|
      drug_details = create_drug_details_string(drug)
      expect(table).to have_content(drug_details)
    end
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

  def verify_disposition_details(disposition_details)
    disposition_section = page.find('#disposition')
    expect(disposition_section).to have_content(disposition_details[:disposition])
    expect(disposition_section).to have_content(disposition_details[:notes])
  end
end