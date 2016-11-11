class Erp::QuotationsPage < Page
       def verify_drugs_count_quotation(drugs)
           drugs_expected_count = drugs.size
           drugs_actual_count = page.all(:css ,'[data-field="product_id"]').size
           expect(drugs_actual_count).to eq(drugs_expected_count)
       end

       def confirm_sale
           click_on('Confirm Sale', :match => :first)
          wait_for_erploading_to_complete
       end

       def verify_drug_info(*drugs)
          for drug in drugs
            found = false
            page.all(:css ,'.oe_notebook_page .oe_list_content tbody tr[data-id]').each do |product_element|
               if product_element.find(:css, '[data-field="product_id"]').text.include? drug[:drug_name]
                   found = true
                   expect(product_element.find(:css, '[data-field="comments"]').text).to include(drug[:quantity])
                   expect(product_element.find(:css, '[data-field="comments"]').text).to include(drug[:quantity_units])
                  if drug.has_key? :quantity_in_erp
                    expect(product_element.find(:css, '[data-field="product_uom_qty"]').text.to_i).to eq(drug[:quantity_in_erp].to_i)
                  else
                    expect(product_element.find(:css, '[data-field="product_uom_qty"]').text.to_i).to eq(drug[:quantity].to_i)
                  end
               end
            end
            if found == false
              fail "Drug #{drug[:drug_name]} not found"
            end
          end
       end
end
