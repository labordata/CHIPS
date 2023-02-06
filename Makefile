BASE_URL=https://s3.amazonaws.com/NARAprodstorage/opastorage/live/1/8902/890201/content/arcmedia/electronic-records/rg-025/chips/

chips.db : c_master.csv c_formal1.csv c_formal2.csv c_formal3.csv	\
           c_formal4.csv c_trailer.csv c_consolid.csv c_names.csv	\
           c_address.csv r_address.csv r_names.csv r_master.csv		\
           r_formal1.csv r_formal2.csv rc_elect.csv ud_elect.csv	\
           r_blocking.csv r_consolid.csv allegations.csv regions.csv raw/l_*.csv
	csvs-to-sqlite $^ $@
	sqlite3 $@ < scripts/trimify.sql > table_trim.sql && \
             sqlite3 $@ < table_trim.sql > trim.sql && \
             sqlite3 $@ < trim.sql
	sqlite3 $@ < scripts/nullify.sql > table_nullify.sql && \
             sqlite3 $@ < table_nullify.sql > null.sql && \
             sqlite3 $@ < null.sql
	sqlite-utils add-column $@ r_master case_number text
	sqlite-utils $@ "update r_master set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils transform $@ r_master -o case_number --pk case_number
	sqlite-utils add-column $@ r_names case_number text
	sqlite-utils $@ "update r_names set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ r_names case_number r_master case_number
	sqlite-utils transform $@ r_names -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ r_address case_number text
	sqlite-utils $@ "update r_address set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ r_address case_number r_master case_number
	sqlite-utils transform $@ r_address -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ r_blocking case_number text
	sqlite-utils $@ "update r_blocking set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ r_blocking case_number r_master case_number
	sqlite-utils transform $@ r_blocking -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ r_consolid case_number text
	sqlite-utils $@ "update r_consolid set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ r_consolid case_number r_master case_number
	sqlite-utils transform $@ r_consolid -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ r_formal1 case_number text
	sqlite-utils $@ "update r_formal1 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ r_formal1 case_number r_master case_number
	sqlite-utils transform $@ r_formal1 -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ r_formal2 case_number text
	sqlite-utils $@ "update r_formal2 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ r_formal2 case_number r_master case_number
	sqlite-utils transform $@ r_formal2 -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ rc_elect case_number text
	sqlite-utils $@ "update rc_elect set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ rc_elect case_number r_master case_number
	sqlite-utils transform $@ rc_elect -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ ud_elect case_number text
	sqlite-utils $@ "update ud_elect set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ ud_elect case_number r_master case_number
	sqlite-utils transform $@ ud_elect -o case_number --drop region --drop ctype --drop docket
	sqlite-utils convert $@ r_master file_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master close_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_notice_hearing_issued 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_hearing_opened 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_hearing_closed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master chips_close_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_agree_approv 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_appea_recd 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_action_on_appeal 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_hearing2_closed_108 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master date_hearing2_open_108 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_master number_emp 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ r_master proposed_no_emp 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ r_master joint_petitioner 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_master joint_recogn_union 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_master chips_amended_code 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_master picket_8b7c 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_master proceeding_control 'None if value == "-" else value'
	sqlite-utils convert $@ r_master consol_type 'None if value == "-" else value'
	sqlite-utils transform $@ r_master --type number_emp integer --type proposed_no_emp integer --type joint_petitioner integer --type joint_recogn_union integer --type chips_amended_code integer --type picket_8b7c integer --type state integer --type petitioner integer --type recogn_union integer
	sqlite-utils add-column $@ r_master blocking_case_number text
	sqlite-utils $@ "update r_master set blocking_case_number = substr('00' || trim(blocking_reg, '-'), -2, 2) || '-' || blocking_type || '-' || substr('000000' || blocking_docket, -6, 6) || COALESCE('-' || substr('000' || blocking_suffix, -3, 3), '') where blocking_reg is not null"
	sqlite-utils add-column $@ r_master consol_case_number text
	sqlite-utils $@ "update r_master set consol_case_number = substr('00' || trim(consol_case_reg, '-'), -2, 2) || '-' || consol_case_type || '-' || substr('000000' || consol_case_docket, -6, 6) || COALESCE('-' || substr('000' || consol_case_suffix, -3, 3), '') where consol_case_reg is not null"
	sqlite-utils add-column $@ r_master sub_consol_case_number text
	sqlite-utils $@ "update r_master set sub_consol_case_number = substr('00' || trim(sub_consol_reg, '-'), -2, 2) || '-' || sub_consol_type || '-' || substr('000000' || sub_consol_docket, -6, 6) || COALESCE('-' || substr('000' || sub_consol_suffix, -3, 3), '') where sub_consol_reg is not null"
	sqlite-utils add-column $@ r_master transfer_case_number text
	sqlite-utils $@ "update r_master set transfer_case_number = substr('00' || trim(transfer_ref, '-'), -2, 2) || '-' || transfer_type || '-' || substr('000000' || substr(transfer_docket, 0, instr(transfer_docket, '.')), -6, 6) || COALESCE('-' || substr('000' || transfer_suffix, -3, 3), '') where transfer_ref is not null"
	sqlite-utils transform $@ r_master --drop blocking_reg --drop blocking_type --drop blocking_docket --drop blocking_suffix --drop consol_case_reg --drop consol_case_type --drop consol_case_docket --drop consol_case_suffix --drop sub_consol_reg --drop sub_consol_type --drop sub_consol_docket --drop sub_consol_suffix --drop reg_8b7c --drop type_8b7c --drop docket_8b7c --drop suffix_8b7c --drop concurrent_reg --drop concurrent_type --drop concurrent_docket --drop concurrent_suffix --drop transfer_ref --drop transfer_type --drop transfer_docket --drop transfer_suffix
	sqlite-utils add-foreign-key $@ r_master region regions region_num
	sqlite-utils transform $@ regions --pk region_num
	sqlite-utils convert $@ rc_elect election_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ rc_elect date_election_held 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ rc_elect date_elect_certified 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ rc_elect expedited 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect join_union_won 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect joint_union_lost_1 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect joint_union_lost_2 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect joint_union_lost_3 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect joint_union_lost_4 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect control 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect challenges_determinative 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect mail_ballot 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect runoff_necessary 'int(value == "Y") if value else None'
	sqlite-utils convert $@ rc_elect impounded 'int(value == "Y") if value else None'
	sqlite-utils transform $@ rc_elect --type expedited integer --type join_union_won integer --type joint_union_lost_1 integer --type joint_union_lost_2 integer --type joint_union_lost_3 integer --type joint_union_lost_4 integer --type control integer --type challenges_determinative integer --type mail_ballot integer --type runoff_necessary integer --type impounded integer
	sqlite-utils convert $@ ud_elect election_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ ud_elect date_election_held 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ ud_elect date_election_certified 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ ud_elect expedited 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect control 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect mail_ballot 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect impounded 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect cout 'int(value == "Y") if value else None'
	sqlite-utils transform $@ ud_elect --type expedited integer --type control integer --type cout integer --type mail_ballot integer --type impounded integer
	sqlite-utils convert $@ r_formal2 rf2_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_election_held 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_obj_chall_filed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_hearing_ordered 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_rps_no_hearing_held 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_hearing_closed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_hearing_opened 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_rpt_on_obj_chall 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_certification 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_review_waivered 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_exception_filed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_ruling_on_exc 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_reg_for_review 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_ruling_on_req 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_board_dec 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_obj_chall_resolved 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 date_bd_dec_on_rev 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal2 first_election_rpt 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_formal2 previously_reported 'int(value == "Y") if value else None'
	sqlite-utils transform $@ r_formal2 --type first_election_rpt integer --type previoulsy_reported integer
	sqlite-utils convert $@ r_formal1 rf1_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal1 date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal1 date_hearing_close 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal1 date_dec_issued 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal1 date_waiver 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal1 date_req_review 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal1 date_ruling_reg 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_formal1 date_board_dec_req 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_consolid consolidation_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ r_consolid date_severed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils add-column $@ r_blocking blocking_case_number text
	sqlite-utils $@ "update r_blocking set blocking_case_number = substr('00' || block_region, -2, 2) || '-' || block_type || '-' || substr('000000' || block_docket, -6, 6) || COALESCE('-' || substr('000' || block_suffix, -3, 3), '')"
	sqlite-utils convert $@ r_blocking block_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils transform $@ r_blocking --drop block_region --drop block_type --drop block_docket --drop block_suffix
	sqlite-utils add-column $@ c_master case_number text
	sqlite-utils $@ "update c_master set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils transform $@ c_master -o case_number --pk case_number
	sqlite-utils add-column $@ c_names case_number text
	sqlite-utils $@ "update c_names set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_names case_number c_master case_number
	sqlite-utils transform $@ c_names -o case_number --drop region --drop ctype --drop docket --drop suffix
	sqlite-utils add-column $@ c_address case_number text
	sqlite-utils $@ "update c_address set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_address case_number c_master case_number
	sqlite-utils transform $@ c_address -o case_number --drop region --drop ctype --drop docket --drop suffix
	sqlite-utils add-column $@ c_consolid case_number text
	sqlite-utils $@ "update c_consolid set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_consolid case_number c_master case_number
	sqlite-utils transform $@ c_consolid -o case_number --drop region --drop ctype --drop docket --drop suffix
	sqlite-utils add-column $@ c_formal1 case_number text
	sqlite-utils $@ "update c_formal1 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_formal1 case_number c_master case_number
	sqlite-utils transform $@ c_formal1 -o case_number --drop region --drop ctype --drop docket --drop suffix
	sqlite-utils add-column $@ c_formal2 case_number text
	sqlite-utils $@ "update c_formal2 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_formal2 case_number c_master case_number
	sqlite-utils transform $@ c_formal2 -o case_number --drop region --drop ctype --drop docket --drop suffix
	sqlite-utils add-column $@ c_formal3 case_number text
	sqlite-utils $@ "update c_formal3 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_formal3 case_number c_master case_number
	sqlite-utils transform $@ c_formal3 -o case_number --drop region --drop ctype --drop docket --drop suffix
	sqlite-utils add-column $@ c_formal4 case_number text
	sqlite-utils $@ "update c_formal4 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_formal4 case_number c_master case_number
	sqlite-utils transform $@ c_formal4 -o case_number --drop region --drop ctype --drop docket --drop suffix
	sqlite-utils add-column $@ c_trailer case_number text
	sqlite-utils $@ "update c_trailer set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6) || COALESCE('-' || substr('000' || suffix, -3, 3), '')"
	sqlite-utils add-foreign-key $@ c_trailer case_number c_master case_number
	sqlite-utils transform $@ c_trailer -o case_number --drop region --drop ctype --drop docket --drop suffix

	sqlite-utils add-foreign-key $@ r_blocking blocking_case_number c_master case_number
	sqlite-utils convert $@ c_master file_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master close_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_ro_disp 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_collyer_began 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_collyer_end 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_re_advice_received 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_action_on_advice 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_appeal_received 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master date_action_on_appeal 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master chips_close_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_master number_employed 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_master number_discrim 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_master number_of_charges 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_master joint_complainant 'int(value == "Y") if value else None'
	sqlite-utils convert $@ c_master joint_respondent 'int(value == "Y") if value else None'
	sqlite-utils add-column $@ c_master key_case_number text
	sqlite-utils $@ "update c_master set key_case_number = substr('00' || trim(key_case_reg, '-'), -2, 2) || '-' || key_case_type || '-' || substr('000000' || key_case_docket, -6, 6) || COALESCE('-' || substr('000' || key_case_suffix, -3, 3), '') where key_case_reg is not null"
	sqlite-utils add-column $@ c_master sub_key_case_number text
	sqlite-utils $@ "update c_master set sub_key_case_number = substr('00' || trim(sub_key_case_reg, '-'), -2, 2) || '-' || sub_key_case_type || '-' || substr('000000' || sub_key_case_docket, -6, 6) || COALESCE('-' || substr('000' || sub_key_case_suffix, -3, 3), '') where sub_key_case_reg is not null"
	sqlite-utils add-column $@ c_master transferred_case_number text
	sqlite-utils $@ "update c_master set transferred_case_number = substr('00' || trim(transferred_case_reg, '-'), -2, 2) || '-' || transferred_case_type || '-' || substr('000000' || transferred_case_docket, -6, 6) || COALESCE('-' || substr('000' || transferred_case_suffix, -3, 3), '') where transferred_case_reg is not null"
	sqlite-utils transform $@ c_master --drop key_case_reg --drop key_case_type --drop key_case_docket --drop key_case_suffix --drop sub_key_case_reg --drop sub_key_case_type --drop sub_key_case_docket --drop sub_key_case_suffix --drop transferred_case_reg --drop transferred_case_type --drop transferred_case_docket --drop transferred_case_suffix  --type number_employed integer --type number_discrim integer --type number_of_charges integer --type joint_complainant integer --type joint_respondent integer
	sqlite-utils convert $@ c_formal1 cf1_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal1 date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal1 date_complaint_issued 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal1 date_ro_disp 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal1 date_hearing_opened 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal1 date_hearing_closed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal1 date_disp_issued_recd 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal1 number_discrim 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal1 number_discrim_reinst_ca 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal1 number_rec_back_pay_uni_emp_cb 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal1 number_rec_back_pay_only_ca 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal1 number_discrim_restor_cb 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal1 number_discrim_preferd 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal1 chips_amended_code 'int(value == "Y") if value else None'
	sqlite-utils add-column $@ c_formal1 consol_case_number text
	sqlite-utils $@ "update c_formal1 set consol_case_number = substr('00' || trim(consol_case_reg, '-'), -2, 2) || '-' || consol_case_type || '-' || substr('000000' || consol_case_docket, -6, 6) || COALESCE('-' || substr('000' || consol_case_suffix, -3, 3), '') where consol_case_reg is not null"
	sqlite-utils add-column $@ c_formal1 sub_consol_case_number text
	sqlite-utils $@ "update c_formal1 set sub_consol_case_number = substr('00' || trim(sub_consol_case_reg, '-'), -2, 2) || '-' || sub_consol_case_type || '-' || substr('000000' || sub_consol_case_docket, -6, 6) || COALESCE('-' || substr('000' || sub_consol_case_suffix, -3, 3), '') where sub_consol_case_reg is not null"
	sqlite-utils transform $@ c_formal1 --drop consol_case_reg --drop consol_case_type --drop consol_case_docket --drop consol_case_suffix --drop sub_consol_case_reg --drop sub_consol_case_type --drop sub_consol_case_docket --drop sub_consol_case_suffix --type number_discrim integer --type number_discrim_reinst_ca integer --type number_rec_back_pay_uni_emp_cb integer --type number_rec_back_pay_only_ca integer --type number_discrim_retor_cb integer --type number_discrim_preferd integer --type chips_amended integer
	sqlite-utils convert $@ c_formal2 cf2_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal2 date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal2 date_transfer_board 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal2 date_decision_issued 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal2 number_discrim_reinstated_ca 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal2 number_receive_back_pay_uni_emp_cb 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal2 number_receive_back_pay_only_ca 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal2 number_discrim_restored_cb 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal2 number_discrim_preferred 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal2 number_discrim_dismissed 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_formal3 cf3_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal3 date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal3 date_ref_app_ct 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal3 date_brief_filed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal3 date_ca_decree 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal3 date_pet_answ_filed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal3 date_ref_pet_answ 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal3 date_ca_opinion 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 cf4_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_referred_scb 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_recom_writ_cert 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_pret_writ_cert_filed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_sc_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_supreme_court_argue 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_supreme_court_dec 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_back_pay_specs 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_hearing_closed 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_administrative_law_judge_dec_issued 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_board_suppl_decision 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_ref_acb 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_formal4 date_suppl_ca_decree 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_consolid consolidation 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils add-column $@ c_consolid key_consol_case_number text
	sqlite-utils $@ "update c_consolid set key_consol_case_number = substr('00' || trim(key_consol_case_reg, '-'), -2, 2) || '-' || key_consol_case_type || '-' || substr('000000' || key_consol_case_docket, -6, 6) || COALESCE('-' || substr('000' || key_consol_case_suffix, -3, 3), '') where key_consol_case_reg is not null"
	sqlite-utils add-column $@ c_consolid sub_consol_case_number text
	sqlite-utils $@ "update c_consolid set sub_consol_case_number = substr('00' || trim(sub_consol_case_reg, '-'), -2, 2) || '-' || sub_consol_case_type || '-' || substr('000000' || sub_consol_case_docket, -6, 6) || COALESCE('-' || substr('000' || sub_consol_case_suffix, -3, 3), '') where sub_consol_case_reg is not null"
	sqlite-utils transform $@ c_consolid --drop key_consol_case_reg --drop key_consol_case_type --drop key_consol_case_docket --drop key_consol_case_suffix --drop sub_consol_case_reg --drop sub_consol_case_type --drop sub_consol_case_docket --drop sub_consol_case_suffix
	sqlite-utils convert $@ c_trailer trailer_date 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_trailer date_last_action 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_trailer date_end_picket 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_trailer date_end_work_stop 'date = r.parsedate(value); return date if date < "2001" else ("19" + date[2:])'
	sqlite-utils convert $@ c_trailer number_reinstated 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_w_reinstated 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_d_reinstated 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_p_list 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_restored 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_withdrawn_employment 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_rcu_employed 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_made_whole 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_receiving_back_pay 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer total_amt 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer amt_pd_co 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer amt_pd_un 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer total_comp 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer total_pd_co 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_employs_picket 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_employes_stop 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ c_trailer number_to_be_reinst 'int(value) if value.isdigit() else None'
	sqlite-utils add-column $@ c_trailer related_key_case_number text
	sqlite-utils $@ "update c_trailer set related_key_case_number = substr('00' || trim(related_key_case_reg, '-'), -2, 2) || '-' || related_key_case_type || '-' || substr('000000' || related_key_case_docket, -6, 6) || COALESCE('-' || substr('000' || related_key_case_suffix, -3, 3), '') where related_key_case_reg is not null"
	sqlite-utils convert $@ c_trailer approval_requested 'int(value == "Y") if value else None'
	sqlite-utils transform $@ c_trailer --type number_reinstated integer --type number_w_reinstated integer --type number_d_reinstated integer --type number_p_list integer --type number_restored integer --type number_withdrawn_employment integer --type number_rcu_employed integer --type number_made_whole integer --type number_receiving_back_pay integer --type total_amt integer --type amt_pd_co integer --type amt_pd_un integer --type total_comp integer --type total_pd_co integer --type number_employs_picket integer --type number_employes_stop integer --type number_to_be_reinst integer --type approval_requested integer --drop related_key_case_reg --drop related_key_case_type --drop related_key_case_docket --drop related_key_case_suffix
	sqlite-utils transform $@ l_unit_codes --pk code
	sqlite-utils transform $@ l_state_codes --pk code
	sqlite-utils transform $@ l_union_codes_and_names --pk code
	sqlite-utils add-column $@ r_master petitioner_type text
	sqlite-utils add-column $@ r_master recogn_union_type text
	sqlite-utils $@ 'update r_master set petitioner_type = substring(petitioner, 1, 1) where length(petitioner) = 4'
	sqlite-utils $@ 'update r_master set petitioner = cast(substring(petitioner, 2, 3) as integer) where length(petitioner) = 4'
	sqlite-utils $@ 'update r_master set petitioner = null where petitioner = 0'
	sqlite-utils $@ 'update r_master set recogn_union_type = substring(recogn_union, 1, 1) where length(recogn_union) = 4'
	sqlite-utils $@ 'update r_master set recogn_union = cast(substring(recogn_union, 2, 3) as integer) where length(recogn_union) = 4'
	sqlite-utils $@ 'update r_master set recogn_union = null where recogn_union = 0'
	sqlite-utils $@ "update r_master set recogn_union_type = null where recogn_union_type = '0'"
	sqlite-utils $@ "update r_master set proposed_no_emp = null where proposed_no_emp = 0"
	sqlite-utils transform $@ r_master -o case_number -o region -o ctype -o docket -o file_date -o close_date -o date_last_action -o industry -o state -o county -o petitioner_type -o petitioner -o joint_petitioner -o local_number -o recogn_union_type -o recogn_union -o joint_recogn_union -o unit -o number_emp -o proposed_no_emp -o picket_8b7c -o status -o machine_control -o proceeding_control -o date_appeal -o ruling_code -o consol_code -o date_notice_hearing_issued -o date_hearing_opened -o date_hearing_closed -o hearing_control -o code_date_closed -o stage_closed -o method_closed -o reason_close -o hearing_held_code -o dec_made_code -o date_agree_approv -o date_appea_recd -o date_action_on_appeal -o chips_amended_code -o date_hearing2_closed_108 -o date_hearing2_open_108 -o blocking_case_code -o consol_sever -o case_stage_action -o consol_type -o chips_close_flag -o chips_close_date -o filed_calendar_year -o filed_fiscal_year -o closed_calendar_year -o closed_fiscal_year -o blocking_case_number -o consol_case_number -o sub_consol_case_number -o transfer_case_number
	sqlite-utils add-foreign-keys $@ r_master state l_state_codes code r_master unit l_unit_codes code r_master petitioner l_union_codes_and_names code r_master recogn_union l_union_codes_and_names code
	sqlite-utils transform $@ l_type_elections --pk code
	sqlite-utils transform $@ l_elect_union_type --type code text --pk code
	sqlite-utils transform $@ l_elect_conclusive --pk code
	sqlite-utils transform $@ l_elect_incumbent_union --pk code
	sqlite-utils transform $@ l_elect_method_of_disposition --type code text --pk code
	sqlite-utils transform $@ l_elect_stage_of_closing --pk code
	sqlite-utils transform $@ l_elect_participating_union --pk code
	sqlite-utils add-foreign-keys $@ rc_elect unit l_unit_codes code rc_elect type_election l_type_elections code
	sqlite-utils add-column $@ rc_elect union_won_intl_type text
	sqlite-utils add-column $@ rc_elect union_lost_intl_1_type text
	sqlite-utils add-column $@ rc_elect union_lost_intl_2_type text
	sqlite-utils add-column $@ rc_elect union_lost_intl_3_type text
	sqlite-utils add-column $@ rc_elect union_lost_intl_4_type text
	sqlite-utils $@ 'update rc_elect set union_won_intl_type = substring(union_won_intl, 1, 1) where length(union_won_intl) = 4'
	sqlite-utils $@ 'update rc_elect set union_won_intl = cast(substring(union_won_intl, 2, 3) as integer) where length(union_won_intl) = 4'
	sqlite-utils $@ 'update rc_elect set union_won_intl = null where union_won_intl = 0'
	sqlite-utils $@ "update rc_elect set union_won_intl_type = null where union_won_intl_type = '0'"
	sqlite-utils $@ 'update rc_elect set union_lost_intl_1_type = substring(union_lost_intl_1, 1, 1) where length(union_lost_intl_1) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_1 = cast(substring(union_lost_intl_1, 2, 3) as integer) where length(union_lost_intl_1) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_1 = null where union_lost_intl_1 = 0'
	sqlite-utils $@ "update rc_elect set union_lost_intl_1_type = null where union_lost_intl_1_type = '0'"
	sqlite-utils $@ 'update rc_elect set union_lost_intl_2_type = substring(union_lost_intl_2, 1, 1) where length(union_lost_intl_2) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_2 = cast(substring(union_lost_intl_2, 2, 3) as integer) where length(union_lost_intl_2) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_2 = null where union_lost_intl_2 = 0'
	sqlite-utils $@ "update rc_elect set union_lost_intl_2_type = null where union_lost_intl_2_type = '0'"
	sqlite-utils $@ 'update rc_elect set union_lost_intl_3_type = substring(union_lost_intl_3, 1, 1) where length(union_lost_intl_3) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_3 = cast(substring(union_lost_intl_3, 2, 3) as integer) where length(union_lost_intl_3) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_3 = null where union_lost_intl_3 = 0'
	sqlite-utils $@ "update rc_elect set union_lost_intl_3_type = null where union_lost_intl_3_type = '0'"
	sqlite-utils $@ 'update rc_elect set union_lost_intl_4_type = substring(union_lost_intl_4, 1, 1) where length(union_lost_intl_4) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_4 = cast(substring(union_lost_intl_4, 2, 3) as integer) where length(union_lost_intl_4) = 4'
	sqlite-utils $@ 'update rc_elect set union_lost_intl_4 = null where union_lost_intl_4 = 0'
	sqlite-utils $@ "update rc_elect set union_lost_intl_4_type = null where union_lost_intl_4_type = '0'"
	sqlite-utils add-column $@ rc_elect cross_pet_case_number text
	sqlite-utils $@ "update rc_elect set cross_pet_case_number = substr('00' || trim(cross_pet_reg, '-'), -2, 2) || '-' || cross_pet_type || '-' || substr('000000' || cross_pet_docket, -6, 6) || COALESCE('-' || substr('000' || cross_pet_suffix, -3, 3), '') where cross_pet_reg is not null"
	sqlite-utils transform $@ rc_elect --drop cross_pet_reg --drop cross_pet_type --drop cross_pet_docket --drop cross_pet_suffix
	sqlite-utils transform $@ rc_elect -o case_number -o suffix -o election_date -o unit -o description_election -o expedited -o date_election_held -o type_election -o no_elig -o join_union_won -o union_won_votes -o union_won_intl_type -o union_won_intl -o joint_union_lost_1 -o union_lost_votes_1 -o union_lost_intl_1_type -o union_lost_intl_1 -o joint_union_lost_2 -o union_lost_votes_2 -o union_lost_intl_2_type -o union_lost_intl_2 -o joint_union_lost_3 -o union_lost_votes_3 -o union_lost_intl_3_type -o union_lost_intl_3 -o joint_union_lost_4 -o union_lost_votes_4 -o union_lost_intl_4_type -o union_lost_intl_4 -o votes_against_union -o challenges -o void_votes -o elect_vote_control -o control -o conclusive -o challenges_determinative -o patric_union -o incumb_union -o mail_ballot -o union_control -o cross_petition -o runoff_necessary -o cross_pet_case_number -o rerun_runoff_number -o impounded -o date_elect_certified -o stage -o method
	sqlite-utils $@ 'update rc_elect set joint_union_lost_2 = null, union_lost_votes_2 = null where union_lost_intl_2_type is null and union_lost_intl_2 is null'
	sqlite-utils $@ 'update rc_elect set joint_union_lost_3 = null, union_lost_votes_3 = null where union_lost_intl_3_type is null and union_lost_intl_3 is null'
	sqlite-utils $@ 'update rc_elect set joint_union_lost_4 = null, union_lost_votes_4 = null where union_lost_intl_4_type is null and union_lost_intl_4 is null' 
	sqlite-utils add-foreign-keys $@ rc_elect union_won_intl_type l_elect_union_type code rc_elect union_won_intl l_union_codes_and_names code rc_elect union_lost_intl_1_type l_elect_union_type code rc_elect union_lost_intl_1 l_union_codes_and_names code rc_elect union_lost_intl_2_type l_elect_union_type code rc_elect union_lost_intl_2 l_union_codes_and_names code rc_elect union_lost_intl_3_type l_elect_union_type code rc_elect union_lost_intl_3 l_union_codes_and_names code rc_elect union_lost_intl_4_type l_elect_union_type code rc_elect union_lost_intl_4 l_union_codes_and_names code rc_elect conclusive l_elect_conclusive code rc_elect incumb_union l_elect_incumbent_union code rc_elect method l_elect_method_of_disposition code rc_elect stage l_elect_stage_of_closing code rc_elect patric_union l_elect_participating_union code
	sqlite-utils transform $@ l_transaction_codes --pk trans
	sqlite-utils transform $@ r_formal2 --type transaction text --type party_filing_ob integer
	sqlite-utils add-foreign-keys $@ r_formal1 unit l_unit_codes code 
	sqlite-utils add-foreign-keys $@ r_formal2 transaction l_transaction_codes trans r_formal2 basis_election l_type_elections code r_formal2 party_filing_ob l_party_filing_objection code
	echo 'vacuum' | sqlite3 $@

c_master.csv : raw/c_master.header TBL.C.MASTER
	cat $^ > $@

c_%.csv : raw/c_%.header tbl.c.%
	cat $^ > $@

r_%.csv : raw/r_%.header tbl.r.%
	cat $^ > $@

rc_elect.csv : raw/rc_elect.header tbl.rc.elect
	cat $^ > $@

ud_elect.csv : raw/ud_elect.header tbl.ud.elect
	cat $^ > $@

allegations.csv : raw/allegations.header allegations
	cat $^ > $@

regions.csv : raw/regions.header regions
	cat $^ > $@

TBL.C.MASTER : TBL.C.MASTER.zip
	unzip $<

TBL.C.MASTER.zip :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/93/8901/890193/content/arcmedia/electronic-records/rg-025/chips/TBL.C.MASTER.zip"

tbl.c.formal1 :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/95/8901/890195/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL1"

tbl.c.formal2 :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/96/8901/890196/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL2"

tbl.c.formal3 :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/97/8901/890197/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL3"

tbl.c.formal4 :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/98/8901/890198/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL4"

tbl.c.trailer :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/99/8901/890199/content/arcmedia/electronic-records/rg-025/chips/TBL.C.TRAILER"

tbl.c.consolid :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/0/8902/890200/content/arcmedia/electronic-records/rg-025/chips/TBL.C.CONSOLID"

tbl.c.names :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/1/8902/890201/content/arcmedia/electronic-records/rg-025/chips/TBL.C.NAMES"

tbl.c.address :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/2/8902/890202/content/arcmedia/electronic-records/rg-025/chips/TBL.C.ADDRESS"

tbl.r.address :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/4/8902/890204/content/arcmedia/electronic-records/rg-025/chips/TBL.R.ADDRESS"

tbl.r.names :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/5/8902/890205/content/arcmedia/electronic-records/rg-025/chips/TBL.R.NAMES"

tbl.r.master :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/6/8902/890206/content/arcmedia/electronic-records/rg-025/chips/TBL.R.MASTER"

tbl.r.formal1 :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/7/8902/890207/content/arcmedia/electronic-records/rg-025/chips/TBL.R.FORMAL1"

tbl.r.formal2 :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/8/8902/890208/content/arcmedia/electronic-records/rg-025/chips/TBL.R.FORMAL2"

tbl.rc.elect :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/10/8902/890210/content/arcmedia/electronic-records/rg-025/chips/TBL.RC.ELECT"

tbl.ud.elect :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/11/8902/890211/content/arcmedia/electronic-records/rg-025/chips/TBL.UD.ELECT"

tbl.r.blocking :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/12/8902/890212/content/arcmedia/electronic-records/rg-025/chips/TBL.R.BLOCKING"

tbl.r.consolid :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/13/8902/890213/content/arcmedia/electronic-records/rg-025/chips/TBL.R.CONSOLID"

allegations :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/74/9771/977174/content/arcmedia/electronic-records/rg-025/chips/ALLEGATIONS"

regions :
	wget -O $@ "https://s3.amazonaws.com/NARAprodstorage/opastorage/live/75/9771/977175/content/arcmedia/electronic-records/rg-025/chips/REGIONS"

