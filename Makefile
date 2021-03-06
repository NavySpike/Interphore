ASSET_PATH := sourceAssets
EXTRA_DEFINES := 
GAME_NAME := Interphore

NEEDED_FONTS := "Espresso-Dolce 22" \
									"Espresso-Dolce 30" \
									"Espresso-Dolce 38" \
									"Espresso-Dolce 44" \
									"OpenSans-Regular 20" \
									"OpenSans-Regular 30" \
									"OpenSans-Regular 35" \
									"OpenSans-Regular 40" \
									"NunitoSans-Light 22" \
									"NunitoSans-Bold 22" \
									"NunitoSans-Italic 22" \
									"NunitoSans-Light 26" \
									"NunitoSans-Bold 26" \
									"NunitoSans-Italic 26" \
									"NunitoSans-Light 30" \
									"NunitoSans-Bold 30" \
									"NunitoSans-Italic 30" \

CPP_TOOLS := ..
CPP_TOOLS_WIN := ..

include ../other/Makefile.secret
GAME_WIDTH=1280
GAME_HEIGHT=720
SCREEN_ORIENTATION := landscape

all:
	$(MAKE) defaultAll

fast:
	cp sourceAssets/info/*.phore bin/assets/info
	cp sourceAssets/info/*.js bin/assets/info
	cp sourceAssets/shader/* bin/assets/shader
	make r

exportAssets:
	# bash $(CPP_TOOLS)/engine/buildSystem/exportAssets.sh ../writerExportedAssets/img assets/img

resetSite:
	cd $(PARAPHORE_COM_PATH) && \
		git fetch origin && \
		git reset --hard origin/master && \
		git pull

shipInterNewEarlyDir:
	$(MAKE) resetSite
	newDirName=$(PARAPHORE_COM_PATH)/interphore/early/`date | md5sum -- `; \
												newDirName=$${newDirName:0:-3}; \
												rm -rf $(PARAPHORE_COM_PATH)/interphore/early/*; \
												mkdir -p $$newDirName;
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/interphore/early"
	
	$(MAKE) shipInterEarly
	dirName=`ls -d $(PARAPHORE_COM_PATH)/interphore/early/*`; \
									echo New url is $$dirName;

shipInterNewDevDir:
	$(MAKE) resetSite
	newDirName=$(PARAPHORE_COM_PATH)/interphore/dev/`date | md5sum -- `; \
												newDirName=$${newDirName:0:-3}; \
												rm -rf $(PARAPHORE_COM_PATH)/interphore/dev/*; \
												mkdir -p $$newDirName;
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/interphore/dev"
	
	$(MAKE) shipInter
	dirName=`ls -d $(PARAPHORE_COM_PATH)/interphore/dev/*`; \
									echo New url is $$dirName;

shipInter:
	$(MAKE) resetSite
	
	cp res/currentMod.phore bin
	$(MAKE) boptflash EXTRA_DEFINES+="-D SEMI_DEV" SHIPPING=1
	$(MAKE) packWindows EXTRA_DEFINES+="-D SEMI_DEV" SHIPPING=1
	$(MAKE) bandroid EXTRA_DEFINES+="-D SEMI_DEV" SHIPPING=1
	dirName=`ls -d $(PARAPHORE_COM_PATH)/interphore/dev/*`; \
									cp $(PARAPHORE_COM_PATH)/interphore/index.html $$dirName/index.html; \
									cp bin/engine.swf $$dirName/interphore.swf; \
									cp bin/$(GAME_NAME).zip $$dirName/interphore.zip; \
									cp bin/engine.apk $$dirName/interphore.apk;
	
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/interphore/dev/"

shipInterEarly:
	$(MAKE) resetSite
	
	cp res/currentMod.phore bin
	$(MAKE) boptflash EXTRA_DEFINES+="-D SEMI_DEV" SHIPPING=1
	$(MAKE) packWindows EXTRA_DEFINES+="-D SEMI_DEV" SHIPPING=1
	$(MAKE) bandroid EXTRA_DEFINES+="-D SEMI_DEV" SHIPPING=1
	dirName=`ls -d $(PARAPHORE_COM_PATH)/interphore/early/*`; \
									cp $(PARAPHORE_COM_PATH)/interphore/index.html $$dirName/index.html; \
									cp bin/engine.swf $$dirName/interphore.swf; \
									cp bin/$(GAME_NAME).zip $$dirName/interphore.zip; \
									cp bin/engine.apk $$dirName/interphore.apk;
	
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/interphore/early/"

shipInterPublic:
	$(MAKE) resetSite
	
	cp res/currentMod.phore bin
	$(MAKE) boptflash SHIPPING=1
	$(MAKE) packWindows SHIPPING=1
	$(MAKE) bandroid SHIPPING=1
	dirName=`ls -d `; \
									cp bin/engine.swf $(PARAPHORE_COM_PATH)/interphore/interphore.swf; \
									cp bin/$(GAME_NAME).zip $(PARAPHORE_COM_PATH)/interphore/interphore.zip; \
									cp bin/engine.apk $(PARAPHORE_COM_PATH)/interphore/interphore.apk;
	
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/interphore"

shipDir:
	cd $(SHIP_DIR); \
		git add .; \
		git commit -m "inter up"; \
		git push; \
		newPrefix=`pwd | grep -o "paraphore.com.*"`; \
		newPrefix=$${newPrefix:14}; \
		s3cmd sync --delete-removed --acl-public --exclude '.git/*' . s3://paraphore.com/$$newPrefix/;

shipAll:
	cd $(PARAPHORE_COM_PATH); \
		git add .; \
		git commit -m "all up"; \
		git push; \
		s3cmd sync --delete-removed --acl-public --exclude '.git/*' . s3://paraphore.com/

shipCurrent:
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/paraphore/dev"
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/semiphore"
	$(MAKE) shipDir SHIP_DIR="$(PARAPHORE_COM_PATH)/interphore"

include $(CPP_TOOLS)/engine/buildSystem/Makefile.common
