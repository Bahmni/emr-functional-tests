class Erp::SalesPage < Page
    include Erp::ControlHeader
    
    def  get_quotation_for_patient(patient_name)
        select_section('Quotations')
        search_customer(patient_name)
        verify_quotation_created
        open_quotation
    end

    def select_section(left_section)
        go_to_header_section('Sales')
        go_to_left_section(left_section)
    end

    def search_customer(customer_name)
        wait_for_erploading_to_complete
        find('.oe_searchview_input', :match => :first).set(customer_name)
        wait_for_autocomplete_to_be_populated
        page.all('.ui-autocomplete .ui-corner-all')[1].click
        wait_for_erploading_to_complete
    end

    def verify_quotation_created
        result_size = page.all(:css,'[data-field="partner_id"]').size
        expect(result_size).not_to eq(0)
        puts result_size
    end

    def open_quotation
        find(:css , '[data-field="partner_id"]', :match => :first ).click
        wait_for_erploading_to_complete
    end
end
