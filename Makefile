BASE_URL=https://s3.amazonaws.com/NARAprodstorage/opastorage/live/1/8902/890201/content/arcmedia/electronic-records/rg-025/chips/

chipsfoo.db : c_master.csv c_formal1.csv c_formal2.csv c_formal3.csv	\
           c_formal4.csv c_trailer.csv c_consolid.csv c_names.csv	\
           c_address.csv r_address.csv r_names.csv r_master.csv		\
           r_formal1.csv r_formal2.csv rc_elect.csv ud_elect.csv	\
           r_blocking.csv r_consolid.csv allegations.csv regions.csv
	csvs-to-sqlite $^ $@
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
	sqlite-utils convert $@ r_master file_date 'r.parsedate(value)'
	sqlite-utils convert $@ r_master close_date 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_last_action 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_notice_hearing_issued 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_hearing_opened 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_hearing_closed 'r.parsedate(value)'
	sqlite-utils convert $@ r_master chips_close_date 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_agree_approv 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_appea_recd 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_action_on_appeal 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_hearing2_closed_108 'r.parsedate(value)'
	sqlite-utils convert $@ r_master date_hearing2_open_108 'r.parsedate(value)'
	sqlite-utils convert $@ r_master number_emp 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ r_master proposed_no_emp 'int(value) if value.isdigit() else None'
	sqlite-utils convert $@ r_master joint_petitioner 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_master joint_recogn_union 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_master chips_amended_code 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_master picket_8b7c 'int(value == "Y") if value else None'
	sqlite-utils transform $@ r_master --type number_emp integer --type proposed_no_emp integer --type joint_petitioner integer --type joint_recogn_union integer --type chips_amended_code integer --type picket_8b7c integer
	sqlite-utils convert $@ r_master proceeding_control 'None if value == "-" else value'
	sqlite-utils convert $@ r_master consol_type 'None if value == "-" else value'
	sqlite-utils add-foreign-key $@ r_master region regions region_num
	sqlite-utils transform $@ regions --pk region_num
	sqlite-utils convert $@ rc_elect election_date 'r.parsedate(value)'
	sqlite-utils convert $@ rc_elect date_election_held 'r.parsedate(value)'
	sqlite-utils convert $@ rc_elect date_elect_certified 'r.parsedate(value)'
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
	sqlite-utils convert $@ ud_elect election_date 'r.parsedate(value)'
	sqlite-utils convert $@ ud_elect date_election_held 'r.parsedate(value)'
	sqlite-utils convert $@ ud_elect date_election_certified 'r.parsedate(value)'
	sqlite-utils convert $@ ud_elect expedited 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect control 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect mail_ballot 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect impounded 'int(value == "Y") if value else None'
	sqlite-utils convert $@ ud_elect cout 'int(value == "Y") if value else None'
	sqlite-utils transform $@ ud_elect --type expedited integer --type control integer --type cout integer --type mail_ballot integer --type impounded integer
	sqlite-utils convert $@ r_formal2 rf2_date 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_last_action 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_election_held 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_obj_chall_filed 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_hearing_ordered 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_rps_no_hearing_held 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_hearing_closed 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_hearing_opened 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_rpt_on_obj_chall 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_certification 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_review_waivered 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_exception_filed 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_ruling_on_exc 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_reg_for_review 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_ruling_on_req 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_board_dec 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_obj_chall_resolved 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 date_bd_dec_on_rev 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal2 first_election_rpt 'int(value == "Y") if value else None'
	sqlite-utils convert $@ r_formal2 previously_reported 'int(value == "Y") if value else None'
	sqlite-utils transform $@ r_formal2 --type first_election_rpt integer --type previoulsy_reported integer
	sqlite-utils convert $@ r_formal1 rf1_date 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal1 date_last_action 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal1 date_hearing_close 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal1 date_dec_issued 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal1 date_waiver 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal1 date_req_review 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal1 date_ruling_reg 'r.parsedate(value)'
	sqlite-utils convert $@ r_formal1 date_board_dec_req 'r.parsedate(value)'
	sqlite-utils convert $@ r_consolid consolidation_date 'r.parsedate(value)'
	sqlite-utils convert $@ r_consolid date_severed 'r.parsedate(value)'
	sqlite-utils add-column $@ r_blocking blocking_case_number text
	sqlite-utils $@ "update r_blocking set blocking_case_number = substr('00' || block_region, -2, 2) || '-' || block_type || '-' || substr('000000' || block_docket, -6, 6)"
	sqlite-utils convert $@ r_blocking block_date 'r.parsedate(value)'
	sqlite-utils transform $@ r_blocking --drop block_region --drop block_type --drop block_docket
	#sqlite-utils add-foreign-key $@ r_blocking blocking_case_number c_master case_number


chips.db : back.db
	cp $< $@
	sqlite-utils add-column $@ c_master case_number text
	sqlite-utils $@ "update c_master set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils transform $@ c_master -o case_number --pk case_number
	sqlite-utils add-column $@ c_names case_number text
	sqlite-utils $@ "update c_names set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ c_names case_number c_master case_number
	sqlite-utils transform $@ c_names -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ c_address case_number text
	sqlite-utils $@ "update c_address set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ c_address case_number r_master case_number
	sqlite-utils transform $@ c_address -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ c_consolid case_number text
	sqlite-utils $@ "update c_consolid set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ c_consolid case_number r_master case_number
	sqlite-utils transform $@ c_consolid -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ c_formal1 case_number text
	sqlite-utils $@ "update c_formal1 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ c_formal1 case_number r_master case_number
	sqlite-utils transform $@ c_formal1 -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ c_formal2 case_number text
	sqlite-utils $@ "update c_formal2 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ c_formal2 case_number r_master case_number
	sqlite-utils transform $@ c_formal2 -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ c_formal3 case_number text
	sqlite-utils $@ "update c_formal3 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ c_formal3 case_number r_master case_number
	sqlite-utils transform $@ c_formal3 -o case_number --drop region --drop ctype --drop docket
	sqlite-utils add-column $@ c_formal4 case_number text
	sqlite-utils $@ "update c_formal4 set case_number = substr('00' || region, -2, 2) || '-' || ctype || '-' || substr('000000' || docket, -6, 6)"
	sqlite-utils add-foreign-key $@ c_formal4 case_number r_master case_number
	sqlite-utils transform $@ c_formal4 -o case_number --drop region --drop ctype --drop docket


foo:

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

