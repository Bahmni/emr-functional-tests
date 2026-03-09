/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

class Clinical::DispositionPage < Page
  include Clinical::ConsultationHeader

  def provide_disposition(disposition_details)
    go_to_tab("Disposition")
    select(disposition_details[:disposition], :from => "dispositionAction")
    fill_in "dispositionNotes", :with => disposition_details[:notes] if disposition_details.has_key? :notes
    save
  end
end
