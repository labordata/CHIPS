chips.db : c_master.csv c_formal1.csv TBL.C.FORMAL2 TBL.C.FORMAL3	\
           TBL.C.FORMAL4 TBL.C.TRAILER TBL.C.CONSOLID TBL.C.NAMES	\
           TBL.C.ADDRESS TBL.R.ADDRESS TBL.R.NAMES TBL.R.MASTER		\
           TBL.R.FORMAL1 TBL.R.FORMAL2 TBL.RC.ELECT TBL.UD.ELECT	\
           TBL.R.BLOCKING TBL.R.CONSOLID ALLEGATIONS REGIONS
	csvs-to-sqlite $^ $@

c_master.csv : TBL.C.MASTER
	cat raw/c_master.header $^ > $@

c_formal1.csv :TBL.C.FORMAL1
	cat raw/c_formal1.header $^ > $@

TBL.C.MASTER : TBL.C.MASTER.zip
	unzip $<

TBL.C.MASTER.zip :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890193/content/arcmedia/electronic-records/rg-025/chips/TBL.C.MASTER.zip?download=true"

TBL.C.FORMAL1 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890195/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL1?download=true"

TBL.C.FORMAL2 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890196/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL2?download=true"

TBL.C.FORMAL3 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890197/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL3?download=true"

TBL.C.FORMAL4 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890198/content/arcmedia/electronic-records/rg-025/chips/TBL.C.FORMAL4?download=true"

TBL.C.TRAILER :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890199/content/arcmedia/electronic-records/rg-025/chips/TBL.C.TRAILER?download=true"

TBL.C.CONSOLID :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890200/content/arcmedia/electronic-records/rg-025/chips/TBL.C.CONSOLID?download=true"

TBL.C.NAMES :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890201/content/arcmedia/electronic-records/rg-025/chips/TBL.C.NAMES?download=true"

TBL.C.ADDRESS :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890202/content/arcmedia/electronic-records/rg-025/chips/TBL.C.ADDRESS?download=true"

TBL.R.ADDRESS :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890204/content/arcmedia/electronic-records/rg-025/chips/TBL.R.ADDRESS?download=true"

TBL.R.NAMES :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890205/content/arcmedia/electronic-records/rg-025/chips/TBL.R.NAMES?download=true"

TBL.R.MASTER :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890206/content/arcmedia/electronic-records/rg-025/chips/TBL.R.MASTER?download=true"

TBL.R.FORMAL1 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890207/content/arcmedia/electronic-records/rg-025/chips/TBL.R.FORMAL1?download=true"

TBL.R.FORMAL2 :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890208/content/arcmedia/electronic-records/rg-025/chips/TBL.R.FORMAL2?download=true"

TBL.RC.ELECT :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890210/content/arcmedia/electronic-records/rg-025/chips/TBL.RC.ELECT?download=true"

TBL.UD.ELECT :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890211/content/arcmedia/electronic-records/rg-025/chips/TBL.UD.ELECT?download=true"

TBL.R.BLOCKING :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890212/content/arcmedia/electronic-records/rg-025/chips/TBL.R.BLOCKING?download=true"

TBL.R.CONSOLID :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/890213/content/arcmedia/electronic-records/rg-025/chips/TBL.R.CONSOLID?download=true"

ALLEGATIONS :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/977174/content/arcmedia/electronic-records/rg-025/chips/ALLEGATIONS?download=true"

REGIONS :
	wget -O $@ "https://catalog.archives.gov/OpaAPI/media/977175/content/arcmedia/electronic-records/rg-025/chips/REGIONS?download=true"

