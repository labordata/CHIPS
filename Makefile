chips.db : c_master.csv c_formal1.csv c_formal2.csv c_formal3.csv	\
           c_formal4.csv c_trailer.csv c_consolid.csv c_names.csv	\
           c_address.csv r_address.csv r_names.csv r_master.csv		\
           r_formal1.csv tbl.r.formal2 tbl.rc.elect tbl.ud.elect	\
           tbl.r.blocking tbl.r.consolid allegations regions
	csvs-to-sqlite $^ $@

c_master.csv : raw/c_master.header TBL.C.MASTER
	cat $^ > $@

c_%.csv : raw/c_%.header tbl.c.%
	cat $^ > $@

r_%.csv : raw/r_%.header tbl.r.%
	cat $^ > $@


TBL.C.MASTER : TBL.C.MASTER.zip
	unzip $<

TBL.C.MASTER.zip :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890193/content/arcmedia/electronic-records/rg-025/chips/TBL.C.MASTER.zip?download=true"

tbl.c.formal1 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890195/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL1?download=true"

tbl.c.formal2 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890196/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL2?download=true"

tbl.c.formal3 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890197/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL3?download=true"

tbl.c.formal4 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890198/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL4?download=true"

tbl.c.trailer :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890199/content/arcmedia/electronic-records/rg-025/chips/TBL.C.TRAILER?download=true"

tbl.c.consolid :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890200/content/arcmedia/electronic-records/rg-025/chips/TBL.C.CONSOLID?download=true"

tbl.c.names :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890201/content/arcmedia/electronic-records/rg-025/chips/TBL.C.NAMES?download=true"

tbl.c.address :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890202/content/arcmedia/electronic-records/rg-025/chips/TBL.C.ADDRESS?download=true"

tbl.r.address :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890204/content/arcmedia/electronic-records/rg-025/chips/TBL.R.ADDRESS?download=true"

tbl.r.names :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890205/content/arcmedia/electronic-records/rg-025/chips/TBL.R.NAMES?download=true"

tbl.r.master :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890206/content/arcmedia/electronic-records/rg-025/chips/TBL.R.MASTER?download=true"

tbl.r.formal1 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890207/content/arcmedia/electronic-records/rg-025/chips/TBL.R.FORMAL1?download=true"

tbl.r.formal2 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890208/content/arcmedia/electronic-records/rg-025/chips/TBL.R.FORMAL2?download=true"

tbl.rc.elect :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890210/content/arcmedia/electronic-records/rg-025/chips/TBL.RC.ELECT?download=true"

tbl.ud.elect :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890211/content/arcmedia/electronic-records/rg-025/chips/TBL.UD.ELECT?download=true"

tbl.r.blocking :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890212/content/arcmedia/electronic-records/rg-025/chips/TBL.R.BLOCKING?download=true"

tbl.r.consolid :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890213/content/arcmedia/electronic-records/rg-025/chips/TBL.R.CONSOLID?download=true"

allegations :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/977174/content/arcmedia/electronic-records/rg-025/chips/ALLEGATIONS?download=true"

regions :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/977175/content/arcmedia/electronic-records/rg-025/chips/REGIONS?download=true"

