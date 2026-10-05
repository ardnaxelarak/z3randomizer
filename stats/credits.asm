encoder creditsBigHi = "../data/creditscharmapbighi.txt"
encoder creditsBigLo = "../data/creditscharmapbiglo.txt"
encoder creditsSmall_red = "../data/creditscharmapsmall_red.txt"
encoder creditsSmall_green = "../data/creditscharmapsmall_green.txt"
encoder creditsSmall_yellow = "../data/creditscharmapsmall_yellow.txt"

;===================================================================================================
; LEAVE THIS HERE FOR PHP WRITES
;===================================================================================================
encoder creditsBigHi
YourSpriteCreditsHi:
         db 2, 55
|A38002| db "                            "

encoder creditsBigLo
YourSpriteCreditsLo:
         db 2, 55
|A38020| db "                            "

encoder creditsBigHi
CollectionRateHi:
db 2, 55
db "COLLECTION RATE        "
print "Collection Rate High Start: ", pc
warnpc $A38055
db " /216"

encoder creditsBigLo
CollectionRateLo:
db 2, 55
db "COLLECTION RATE        "
print "Collection Rate Low Start: ", pc
warnpc $A38073
db " /216"

!FEATURE_PATREON_SUPPORTERS ?= 0

encoder creditsBigHi
PatronCredit1Hi:
         db 2, 55
|A3807A| db "                            "

encoder creditsBigLo
PatronCredit1Lo:
         db 2, 55
|A38098| db "                            "

encoder creditsBigHi
PatronCredit2Hi:
         db 2, 55
|A380B6| db "                            "

encoder creditsBigLo
PatronCredit2Lo:
         db 2, 55
|A380D4| db "                            "

encoder creditsBigHi
PatronCredit3Hi:
         db 2, 55
|A380F2| db "                            "

encoder creditsBigLo
PatronCredit3Lo:
         db 2, 55
|A38110| db "                            "

;===================================================================================================

piling CreditsLineTable :: 800
fill word size 800 :: CreditsLineBlank

;===================================================================================================

;---------------------------------------------------------------------------------------------------

macro smallcredits(text, color)
	encoder creditsSmall_{color}

	{?}_line:
		db (32-.text.size)/2
		db 2*(.text.size)-1
	.text
		db "{text}"
	^..size

	pile CreditsLineTable :: dw {?}_line
endmacro

;---------------------------------------------------------------------------------------------------
macro bigcredits(text)
	encoder creditsBigHi

	{?}_line_top:
		db (32-.text.size)/2
		db 2*(.text.size)-1
	.text
		db "{text}"
	^..size

	pile CreditsLineTable :: dw {?}_line_top

	encoder creditsBigLo
	{?}_line_bottom:
		db (32-.text.size)/2
		db 2*(.text.size)-1
	.text
		db "{text}"
	^..size

	pile CreditsLineTable :: dw {?}_line_bottom
endmacro

;---------------------------------------------------------------------------------------------------

macro bigcreditsleft(text)
	encoder creditsBigHi

	{?}_line_top:
		db 2
		db 2*(.text.size)-1
	.text
		db "{text}"
	^..size

	pile CreditsLineTable :: dw {?}_line_top

	encoder creditsBigLo
	{?}_line_bottom:
		db 2
		db 2*(.text.size)-1
	.text
		db "{text}"
	^..size

	pile CreditsLineTable :: dw {?}_line_bottom
endmacro

;---------------------------------------------------------------------------------------------------

macro emptyline()
	pile CreditsLineTable :: dw CreditsEmptyLine
endmacro

macro blankline()
	pile CreditsLineTable :: dw CreditsLineBlank
endmacro

macro addarbline(addr)
	pile CreditsLineTable :: dw {addr}
endmacro

;===================================================================================================

CreditsEmptyLine:
	db $00, $01, $9F

CreditsLineBlank:
	db $FF

;---------------------------------------------------------------------------------------------------

%emptyline()
%smallcredits("ORIGINAL GAME STAFF", "yellow")

%blankline()
%blankline()

%smallcredits("EXECUTIVE PRODUCER", "green")

%blankline()

%bigcredits("HIROSHI YAMAUCHI")

%blankline()
%blankline()

%smallcredits("PRODUCER", "yellow")

%blankline()

%bigcredits("SHIGERU MIYAMOTO")

%blankline()
%blankline()

%smallcredits("DIRECTOR", "red")

%blankline()

%bigcredits("TAKASHI TEZUKA")

%blankline()
%blankline()

%smallcredits("SCRIPT WRITER", "green")

%blankline()

%bigcredits("KENSUKE TANABE")

%blankline()
%blankline()

%smallcredits("ASSISTANT DIRECTORS", "yellow")

%blankline()

%bigcredits("YASUHISA YAMAMURA")

%blankline()

%bigcredits("YOICHI YAMADA")

%blankline()
%blankline()

%smallcredits("SCREEN GRAPHICS DESIGNERS", "green")

%emptyline()
%emptyline()

%smallcredits("OBJECT DESIGNERS", "yellow")

%blankline()

%bigcredits("SOICHIRO TOMITA")

%blankline()

%bigcredits("TAKAYA IMAMURA")

%blankline()
%blankline()

%smallcredits("BACK GROUND DESIGNERS", "yellow")

%blankline()

%bigcredits("MASANAO ARIMOTO")

%blankline()

%bigcredits("TSUYOSHI WATANABE")

%blankline()
%blankline()

%smallcredits("PROGRAM DIRECTOR", "red")

%blankline()

%bigcredits("TOSHIHIKO NAKAGO")

%blankline()
%blankline()

%smallcredits("MAIN PROGRAMMER", "yellow")

%blankline()

%bigcredits("YASUNARI SOEJIMA")

%blankline()
%blankline()

%smallcredits("OBJECT PROGRAMMER", "green")

%blankline()

%bigcredits("KAZUAKI MORITA")

%blankline()
%blankline()

%smallcredits("PROGRAMMERS", "yellow")

%blankline()

%bigcredits("TATSUO NISHIYAMA")

%blankline()

%bigcredits("YUICHI YAMAMOTO")

%blankline()

%bigcredits("YOSHIHIRO NOMOTO")

%blankline()

%bigcredits("EIJI NOTO")

%blankline()

%bigcredits("SATORU TAKAHATA")

%blankline()

%bigcredits("TOSHIO IWAWAKI")

%blankline()

%bigcredits("SHIGEHIRO KASAMATSU")

%blankline()

%bigcredits("YASUNARI NISHIDA")

%blankline()
%blankline()

%smallcredits("SOUND COMPOSER", "red")

%blankline()

%bigcredits("KOJI KONDO")

%blankline()
%blankline()

%smallcredits("COORDINATORS", "green")

%blankline()

%bigcredits("KEIZO KATO")

%blankline()

%bigcredits("TAKAO SHIMIZU")

%blankline()
%blankline()

%smallcredits("PRINTED ART WORK", "yellow")

%blankline()

%bigcredits("YOICHI KOTABE")

%blankline()

%bigcredits("HIDEKI FUJII")

%blankline()

%bigcredits("YOSHIAKI KOIZUMI")

%blankline()

%bigcredits("YASUHIRO SAKAI")

%blankline()

%bigcredits("TOMOAKI KUROUME")

%blankline()
%blankline()

%smallcredits("SPECIAL THANKS TO", "red")

%blankline()

%bigcredits("NOBUO OKAJIMA")

%blankline()

%bigcredits("YASUNORI TAKETANI")

%blankline()

%bigcredits("KIYOSHI KODA")

%blankline()

%bigcredits("TAKAMITSU KUZUHARA")

%blankline()

%bigcredits("HIRONOBU KAKUI")

%blankline()

%bigcredits("SHIGEKI YAMASHIRO")

%blankline()

%emptyline()
%emptyline()
%emptyline()
%emptyline()

;---------------------------------------------------------------------------------------------------

%smallcredits("RANDOMIZER CONTRIBUTORS", "red")

%blankline()
%blankline()

%smallcredits("ITEM RANDOMIZER", "yellow")

%blankline()

%bigcredits("KATDEVSGAMES         VEETORP")

%blankline()

%bigcredits("CHRISTOSOWEN       DESSYREQT")

%blankline()

%bigcredits("SMALLHACKER           SYNACK")

%blankline()
%blankline()

%smallcredits("ENTRANCE RANDOMIZER", "green")

%blankline()

%bigcredits("AMAZINGAMPHAROS   LLCOOLDAVE")

%blankline()

%bigcredits("KEVINCATHCART    CASSIDYMOEN")

%blankline()
%blankline()

%smallcredits("ENEMY RANDOMIZER", "yellow")

%blankline()

%bigcredits("ZARBY89              SOSUKE3")

%blankline()

%bigcredits("ENDEROFGAMES")

%blankline()
%blankline()

%smallcredits("DOOR RANDOMIZER", "green")

%blankline()

%bigcredits("AERINON            COMPILING")

%blankline()
%blankline()

%smallcredits("OVERWORLD RANDOMIZER", "yellow")

%blankline()

%bigcredits("CODEMANN8            CATOBAT")

%blankline()
%blankline()

%smallcredits("FESTIVE RANDOMIZER", "green")

%blankline()

%bigcredits("KAN                    TOTAL")

%blankline()

%bigcredits("CATOBAT            DINSAPHIR")

%blankline()
%blankline()

%smallcredits("GWAAKIWI * DUNGEON MAPS", "yellow")

%blankline()

%bigcredits("KARAFRUIT")

%blankline()
%blankline()

%smallcredits("SPRITE DEVELOPMENT", "green")

%blankline()

%bigcredits("MATRETHEWEY    FISH_WAFFLE64")

%blankline()

%bigcredits("IBAZLY     ACHY      ARTHEAU")

%blankline()

%bigcredits("GLAN                 TWROXAS")

%blankline()

%bigcredits("PLAGUEDONE         TARTHORON")

%blankline()
%blankline()

%smallcredits("YOUR SPRITE BY", "yellow")

%blankline()

%addarbline(YourSpriteCreditsHi)
%addarbline(YourSpriteCreditsLo)

%blankline()
%blankline()

%smallcredits("MSU SUPPORT", "green")

%blankline()

%bigcredits("QWERTYMODO")

%blankline()
%blankline()

%smallcredits("PALETTE SHUFFLER", "yellow")

%blankline()

%bigcredits("NELSON AKA SWR")

%blankline()
%blankline()

%smallcredits("WEBSITE LOGO", "green")

%blankline()

%bigcredits("PLEASURE")

%blankline()
%blankline()

if !FEATURE_PATREON_SUPPORTERS
	%smallcredits("PATREON SUPPORTERS", "yellow")

	%addarbline(PatronCredit1Hi)
	%addarbline(PatronCredit1Lo)

	%blankline()
	%addarbline(PatronCredit2Hi)
	%addarbline(PatronCredit2Lo)

	%blankline()
	%addarbline(PatronCredit3Hi)
	%addarbline(PatronCredit3Lo)

	%blankline()
	%blankline()
endif

%smallcredits("SPECIAL THANKS", "red")

%blankline()

%bigcredits("SUPERSKUJ          EVILASH25")

%blankline()

%bigcredits("MYRAMONG             JOSHRTA")

%blankline()

%bigcredits("WALKINGEYE     MATHONNAPKINS")

%blankline()

%bigcredits("MICHAELK    FOUTON     BONTA")

%blankline()

%bigcredits("EMOSARU   PINKUS    YUZUHARA")

%blankline()

%bigcredits("SAKURATSUBASA")

%blankline()

%bigcredits("AND")

%blankline()

%bigcredits("THE ALTTP RANDOMIZER COMMUNITY")

%blankline()
%blankline()

%smallcredits("COMMUNITY DISCORD", "green")

%blankline()

%bigcredits("HTTPS://ALTTPR.COM/DISCORD")

%emptyline()
%emptyline()

if !FEATURE_PATREON_SUPPORTERS == 0
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
	%emptyline()
endif

;===================================================================================================

printf "Credits line table size: {0} | Expected: 606", CreditsLineTable:size

if CreditsLineTable:size > 606
	error "Too many credits lines. CreditsLineTable:size > 606."
endif

if CreditsLineTable:size < 606
	error "Too few credits lines. CreditsLineTable:size < 606."
endif

;===================================================================================================

%smallcredits("THE IMPORTANT STUFF", "yellow")

%blankline()
%blankline()

%emptyline()
%smallcredits("TIME FOUND", "green")

%blankline()
%blankline()

%bigcreditsleft("FIRST SWORD")

%blankline()

%bigcreditsleft("PEGASUS BOOTS")

%blankline()

%bigcreditsleft("FLUTE")

%blankline()

%bigcreditsleft("MIRROR")

%blankline()
%blankline()

%emptyline()
%smallcredits("BOSS KILLS", "yellow")

%blankline()
%blankline()

%bigcreditsleft("SWORDLESS                /13")

%blankline()

%bigcreditsleft("FIGHTER'S SWORD          /13")

%blankline()

%bigcreditsleft("MASTER SWORD             /13")

%blankline()

%bigcreditsleft("TEMPERED SWORD           /13")

%blankline()

%bigcreditsleft("GOLD SWORD               /13")

%blankline()
%blankline()

%smallcredits("GAME STATS", "red")

%blankline()
%blankline()

%bigcreditsleft("DAMAGE TAKEN")

%blankline()

%bigcreditsleft("MAGIC USED")

%blankline()

%bigcreditsleft("BONKS")

%blankline()

%bigcreditsleft("SAVE AND QUITS")

%blankline()

%bigcreditsleft("DEATHS")

%blankline()

%bigcreditsleft("FAERIE REVIVALS")

%blankline()

%bigcreditsleft("TOTAL MENU TIME")

%blankline()

%bigcreditsleft("TOTAL MAP TIME")

%blankline()

%bigcreditsleft("TOTAL LAG TIME")

%blankline()


%blankline()
%blankline()


%blankline()
%blankline()


%blankline()

%emptyline()
%emptyline()
%addarbline(CollectionRateHi)
%addarbline(CollectionRateLo)

%blankline()

%bigcreditsleft("TOTAL TIME")

%blankline()

%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()
%emptyline()

;---------------------------------------------------------------------------------------------------
