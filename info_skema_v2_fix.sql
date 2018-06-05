



SET FOREIGN_KEY_CHECKS=0;

START TRANSACTION;

INSERT INTO `surveys` VALUES (210,'Oplysningsskema','INFO','Oplysningsskema (Forældreskema) (v2)','1.5-16','parent','f23737',99,'info','INFO');

delete from questions where id >= 11000 and id <= 11010;
delete from question_cells where question_id >= 11000 and question_id <= 11010;

INSERT INTO `questions` VALUES (11000,210,1,0,2,NULL);
INSERT INTO `question_cells` VALUES (12400,11000,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Kære forældre,<p/>Jeres barn er indkaldt til undersøgelse.\nVi vil bede jer om at udfylde oplysningsskemaet forud for jeres første besøg i ambulatoriet.',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12401,11000,'ListItem',1,2,"8",NULL,'listitem::::Dags dato:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12402,11000,'ListItemComment',2,2,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12403,11000,'ListItem',1,3,"8",NULL,'listitem::::Barnets fulde navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12404,11000,'ListItemComment',2,3,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12405,11000,'ListItem',1,4,"8",NULL,'listitem::::Barnets fødselsdag:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12406,11000,'ListItemComment',2,4,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12407,11000,'Placeholder',1,5,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12408,11000,'SectionSubtitle',1,6,NULL,NULL,'sectionsubtitle::::Oplysninger om mor:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12409,11000,'ListItem',1,7,"8",NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12410,11000,'ListItemComment',2,7,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12411,11000,'ListItem',1,8,"8",NULL,'listitem::::Alder',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12412,11000,'ListItemComment',2,8,"8",NULL,'itemunit::::år',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12413,11000,'ListItem',1,9,"8",NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12414,11000,'ListItemComment',2,9,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12415,11000,'ListItem',1,10,"8",NULL,'listitem::::Postnummer og by:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12416,11000,'ListItemComment',2,10,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12417,11000,'ListItem',1,11,"8",NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12418,11000,'ListItemComment',2,11,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12419,11000,'ListItem',1,12,"8",NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12420,11000,'ListItemComment',2,12,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12421,11000,'Placeholder',1,13,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12422,11000,'SectionSubtitle',1,14,NULL,NULL,'sectionsubtitle::::Oplysninger om far:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12423,11000,'ListItem',1,15,"8",NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12424,11000,'ListItemComment',2,15,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12425,11000,'ListItem',1,16,"8",NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12426,11000,'ListItemComment',2,16,"8",NULL,'itemunit::::år',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12427,11000,'ListItem',1,17,"8",NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12428,11000,'ListItemComment',2,17,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12429,11000,'ListItem',1,18,"8",NULL,'listitem::::Postnummer og by:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12430,11000,'ListItemComment',2,18,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12431,11000,'ListItem',1,19,"8",NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12432,11000,'ListItemComment',2,19,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12433,11000,'ListItem',1,20,"8",NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12434,11000,'ListItemComment',2,20,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12435,11000,'Placeholder',1,22,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12436,11000,'SectionSubtitle',1,23,NULL,NULL,'sectionsubtitle::::Oplysninger om evt. bonusfar/bonusmor på barnets folkeregisterbopæl:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12437,11000,'ListItem',1,24,"8",NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12438,11000,'ListItemComment',2,24,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12439,11000,'ListItem',1,25,"8",NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12440,11000,'ListItemComment',2,25,"8",NULL,'itemunit::::år',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12441,11000,'ListItem',1,26,"8",NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12442,11000,'ListItemComment',2,26,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12443,11000,'ListItem',1,27,"8",NULL,'listitem::::Postnummer og by:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12444,11000,'ListItemComment',2,27,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12445,11000,'ListItem',1,28,"8",NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12446,11000,'ListItemComment',2,28,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12447,11000,'ListItem',1,29,"8",NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12448,11000,'ListItemComment',2,29,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12449,11000,'Placeholder',1,30,"8",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12450,11000,'ListItem',1,31,"8",NULL,'listitem::::Evt barnets/den unges eget tlf.nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12451,11000,'ListItemComment',2,31,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (11002,210,2,0,2,NULL);
INSERT INTO `question_cells` VALUES (2452,11002,'ListItem',1,1,"8",NULL,'listitem::::Lever biologiske forældre sammen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2453,11002,'Rating',2,1,"1",NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- ay\n',1, 11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2454,11002,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvis forældrene er skilte:','--- \n:targets: \n- :target: ay\n  :state: onstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2455,11002,'ListItem',1,3,"8",NULL,'listitem::::Hvem har forældremyndigheden:','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2456,11002,'ListItemComment',2,3,"6",NULL,'listitem::::','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2457,11002,'ListItemComment',1,4,"8;10",NULL,'listitem::::Forhold omkring samvær###textbox::::','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2458,11002,'TextBox',2,4,NULL,NULL,'textbox::::','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (11003,210,3,0,3,NULL);
INSERT INTO `question_cells` VALUES (2690,11003,'SectionSubtitle',1,1,NULL,NULL,'sectionsubtitle::::Vedr. henvisningen:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2691,11003,'ListItem',1,2,"8",NULL,'listitem::::På hvis initiativ er henvisningen sket?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2692,11003,'Rating',2,2,"5",NULL,'radio::1::Forældre###radio::2::Institution/skole###radio::3::Egen læge###radio::4::Kommune/PPR###radio::5::Andre',NULL,1,15,NULL,NULL);
INSERT INTO `question_cells` VALUES (2693,11003,'ListItemComment',3,2,"4;8",NULL,'listitem::::Hvis andre, hvem?###textbox::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2694,11003,'ListItem',1,3,"8",NULL,'listitem::::Kort beskrivelse af det forløb der har medført henvisning til børnepsykiatrisk undersøgelse',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2695,11003,'TextBox',2,3,"10",NULL,'textbox::::',NULL,0,NULL,NULL,NULL);


INSERT INTO `question_cells` VALUES (2700,11003,'Placeholder',1,10,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2701,11003,'SectionSubtitle',1,11,NULL,NULL,'sectionsubtitle::::Kontakt til forskningsenheden',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2702,11003,'ListItem',1,12,NULL,NULL,'listitem::::Må forskningsenheden kontakte dig?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2703,11003,'Rating',2,12,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- ac\n',1, 11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2704,11003,'Rating',1,13,"6",NULL,'radio::1::Mors email###radio::2::Fars email###','--- \n:targets: \n- :target: ac\n  :state: offstate\n',1,14,NULL,NULL);
INSERT INTO `question_cells` VALUES (2705,11003,'ListItemComment',2,13,"3;8",NULL,'listitem::::Email###listitem::::','--- \n:targets: \n- :target: ac\n  :state: offstate\n',1, NULL,NULL,NULL);


INSERT INTO `questions` VALUES (11010,210,5,0,2,NULL);
INSERT INTO `question_cells` VALUES (12469,11010,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Har barnet, indenfor de sidste 6 mdr., været henvist og dermed udfyldt nedenstående spørgsmål, bedes I se bort fra udfyldelse af resten af skemaet.<p/>Hvis der er tilkommet ændringer i oplysningerne bedes disse tilføjet,',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (11004,210,4,0,2,NULL);
INSERT INTO `question_cells` VALUES (12470,11004,'ListItem',1,1,"7",NULL,'listitem::::Er barnet allergisk over for noget?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12471,11004,'Rating',2,1,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- a\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12472,11004,'ListItemComment',3,1,"2;11",NULL,'listitem::::Hvis ja, for hvad?###textbox::::','--- \n:targets: \n- :target: a\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (11005,210,5,0,3,NULL);
INSERT INTO `question_cells` VALUES (12473,11005,'Questiontext',1,1,NULL,NULL,'questiontext::::Er der nogle i barnets familie (1. leds slægtninge) der har psykiske og fysiske vanskeligheder?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12474,11005,'ListItem',1,2,NULL,NULL,'listitem::::Mor',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12475,11005,'Rating',2,2,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- u\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12476,11005,'ListItemComment',3,2,"8",NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom###textbox::::','--- \n:targets: \n- :target: u\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12477,11005,'ListItem',1,3,NULL,NULL,'listitem::::Far',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12478,11005,'Rating',2,3,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- v\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12479,11005,'ListItemComment',3,3,"8",NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom###textbox::::','--- \n:targets: \n- :target: v\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12480,11005,'ListItem',1,4,NULL,NULL,'listitem::::Søskende',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12481,11005,'Rating',2,4,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- w\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12482,11005,'ListItemComment',3,4,"8",NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom###textbox::::','--- \n:targets: \n- :target: w\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2470,5004,'ListItemComment',1,6,NULL,NULL,'listitem::::Hvis ja, beskriv###textbox::::','--- \n:targets: \n- :target: w\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12483,11005,'ListItem',1,5,NULL,NULL,'listitem::::Er der nogen i barnets familie, der har vanskeligheder der ligner barnets?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12484,11005,'Rating',2,5,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- x\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12485,11005,'ListItemComment',3,5,"3;8",NULL,'listitem::::Hvis ja, beskriv###textbox::::','--- \n:targets: \n- :target: x\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12486,11005,'ListItem',1,6,NULL,NULL,'listitem::::Er der nogen i barnets familie, som har et alkohol eller stofmisbrug',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12487,11005,'Rating',2,6,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- b\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12488,11005,'ListItemComment',3,6,"3;8",NULL,'listitem::::Hvis ja, hvilket?###textbox::::','--- \n:targets: \n- :target: b\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12489,11005,'ListItem',1,7,NULL,NULL,'listitem::::Er der nogen i barnets familie, som har begået selvmord?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12490,11005,'Rating',2,7,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- ab\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12491,11005,'ListItemComment',3,7,"3;8",NULL,'listitem::::Hvis ja, uddyb###textbox::::','--- \n:targets: \n- :target: ab\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2469,11002,'TextBox',2,6,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (11006,210,6,0,3,NULL);
INSERT INTO `question_cells` VALUES (12500,11006,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Sundhedsoplysninger',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12501,11006,'SectionSubtitle',1,2,NULL,NULL,'sectionsubtitle::::Graviditet og fødsel:',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12502,11006,'ListItem',1,3,NULL,NULL,'listitem::::Var der sygdom hos barnets mor under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12503,11006,'Rating',2,3,"1",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- c\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12504,11006,'ListItemComment',3,3,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilken###textbox::::','--- \n:targets: \n- :target: c\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `question_cells` VALUES (12506,11006,'ListItem',1,5,NULL,NULL,'listitem::::Tog moderen medicin under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12507,11006,'Rating',2,5,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- d\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12508,11006,'ListItemComment',3,5,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilken###textbox::::','--- \n:targets: \n- :target: d\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12509,11006,'ListItem',1,7,NULL,NULL,'listitem::::Var der komplikationer i graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12510,11006,'Rating',2,7,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- e\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12511,11006,'ListItemComment',3,7,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: e\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12512,11006,'ListItem',1,9,NULL,NULL,'listitem::::Var der komplikationer under fødslen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12513,11006,'Rating',2,9,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- f\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12514,11006,'ListItemComment',4,9,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: f\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12515,11006,'ListItem',1,11,NULL,NULL,'listitem::::Røg moderen tobak under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12516,11006,'Rating',2,11,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- g\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12517,11006,'ListItemComment',3,11,"4;10",NULL,'listitem::::Hvis ja, ca. hvor meget?###textbox::::','--- \n:targets: \n- :target: g\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12518,11006,'ListItem',1,13,NULL,NULL,'listitem::::Drak moderen alkohol under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12519,11006,'Rating',2,13,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- h\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12520,11006,'ListItemComment',3,13,"4;10",NULL,'listitem::::Hvis ja, ca. hvor meget?###textbox::::','--- \n:targets: \n- :target: h\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12521,11006,'ListItem',1,15,NULL,NULL,'listitem::::Hvornår er barnet født?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12522,11006,'SelectOption',2,15,"8",7,'option::1::Ektremt tidligt født (før 28. svangerskabsuge)###option::2::Meget tidligt født (28. - 32. svangerskabsuge)###radio::3::Moderat tidligt født (33. - 36. svangerskabsuge)###option::4::Til termin (37. - 42. svangerskabsuge)###option::5::Overbåren (efter 42. svangerskabsuge)',NULL,1,16,NULL,NULL);

INSERT INTO `question_cells` VALUES (12523,11006,'Questiontext',1,16,NULL,NULL,'questiontext::::Barnets mål og vægt ved fødslen',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12524,11006,'Placeholder',1,17,"7",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12525,11006,'ListItem',2,17,"5",NULL,'listitem::::længde',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12526,11006,'ListItemComment',3,17,NULL,NULL,'itemunit::::cm',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12527,11006,'Placeholder',1,18,"7",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12528,11006,'ListItem',2,18,"5",NULL,'listitem::::vægt',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12529,11006,'ListItemComment',3,18,NULL,NULL,'itemunit::::gram',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12530,11006,'ListItem',1,19,NULL,NULL,'listitem::::Har barnet medfødte sygdomme?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12531,11006,'Rating',2,19,1,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- i\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12532,11006,'ListItemComment',3,19,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: i\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (11007,210,7,0,4,NULL);
INSERT INTO `question_cells` VALUES (12540,11007,'SectionSubtitle',1,1,NULL,NULL,'sectionsubtitle::::Tidlig barndom:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12541,11007,'ListItem',1,2,"8",NULL,'listitem::::Var der komplikationer i spædbarnsperioden?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12542,11007,'Rating',2,2,"1",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- j\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12543,11007,'ListItemComment',3,2,"4;12",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: j\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12546,11007,'ListItem',1,3,"8",NULL,'listitem::::Var der kontakt til sundhedsplejerske?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12547,11007,'Rating',2,3,"1",NULL,'radio::0::Nej###radio::1::Ja',NULL,1,11,NULL,NULL);

INSERT INTO `question_cells` VALUES (12548,11007,'ListItem',1,4,"8",NULL,'listitem::::Blev barnet ammet?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12549,11007,'Rating',2,4,"1",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- k\n',1,11,NULL,NULL);
-- INSERT INTO `question_cells` VALUE1S (2550,11007,'Placeholder',1,5,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12551,11007,'ListItemComment',1,5,"8",NULL,'listitem::::Udelukkende amning (ca. antal uger)###itemunit::::uger','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUE1S (2552,11007,'Placeholder',1,6,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12553,11007,'ListItemComment',1,6,"8",NULL,'listitem::::Delvis amning (ca. antal uger)###itemunit::::uger','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12561,11007,'ListItem',1,9,"12",NULL,'listitem::::Hvordan var kontakten med barnet i spædbarnsperioden (øjenkontakt, smil, pludren, kunne barnet trøstes, brød det sig om kropskontakt m.v.)',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12562,11007,'TextBox',2,9,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12563,11007,'Questiontext',1,10,NULL,NULL,'questiontext::::Hvornår kunne barnet:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12564,11007,'Placeholder',1,11,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12565,11007,'ListItem',2,11,"4",NULL,'listitem::::Sidde',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12566,11007,'ListItemComment',3,11,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12567,11007,'Placeholder',1,12,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12568,11007,'ListItem',2,12,"4",NULL,'listitem::::Kravle',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12569,11007,'ListItemComment',3,12,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12570,11007,'Placeholder',1,13,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12571,11007,'ListItem',2,13,"4",NULL,'listitem::::Gå',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12572,11007,'ListItemComment',3,13,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12573,11007,'Placeholder',1,14,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12574,11007,'ListItem',2,14,"4",NULL,'listitem::::Sige enkelte ord',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12575,11007,'ListItemComment',3,14,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12576,11007,'ListItem',1,15,"9",NULL,'listitem::::Hvornår var barnet renligt?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12577,11007,'ListItemComment',2,15,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12578,11007,'ListItem',1,24,"9",NULL,'listitem::::Er barnet vådligger?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12579,11007,'Rating',2,24,"1",NULL,'radio::0::Nej###radio::1::Ja',NULL,1,11,NULL,NULL);

INSERT INTO `question_cells` VALUES (12580,11007,'ListItem',1,25,"9",NULL,'listitem::::Er der "uheld" om dagen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12581,11007,'Rating',2,25,"1",NULL,'radio::0::Nej###radio::1::Ja',NULL,1,11,NULL,NULL);


INSERT INTO `questions` VALUES (11008,210,8,0,3,NULL);
INSERT INTO `question_cells` VALUES (12590,11008,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Oplysninger vedrørende netværk',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12591,11008,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvem bor i samme husstand som barnet?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12592,11008,'ListItem',2,2,"6",NULL,'listitem::::Fornavn:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12593,11008,'ListItem',3,2,"6",NULL,'listitem::::Familieforhold til barnet:\n(ex: mor, far søskende, bonusmor, bonusfar, bonussøskende)',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12594,11008,'Placeholder',1,3,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12595,11008,'ListItemComment',2,3,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12596,11008,'ListItemComment',3,3,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12597,11008,'Placeholder',1,4,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12598,11008,'ListItemComment',2,4,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12599,11008,'ListItemComment',3,4,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12600,11008,'Placeholder',1,5,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12601,11008,'ListItemComment',2,5,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12602,11008,'ListItemComment',3,5,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12603,11008,'Placeholder',1,6,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12604,11008,'ListItemComment',2,6,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12605,11008,'ListItemComment',3,6,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12606,11008,'Placeholder',1,7,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12607,11008,'ListItemComment',2,7,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12608,11008,'ListItemComment',3,7,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12609,11008,'Placeholder',1,8,"6",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12610,11008,'Information',1,9,NULL,NULL,'information::::Ved skilsmisse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12611,11008,'Questiontext',1,10,NULL,NULL,'questiontext::::Hvem bor i den anden forældres husstand?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12612,11008,'ListItem',2,10,"6",NULL,'listitem::::Fornavn:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12613,11008,'ListItem',3,10,"6",NULL,'listitem::::Familieforhold til barnet:\n(ex: mor, far søskende, bonusmor, bonusfar, bonussøskende)',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12614,11008,'Placeholder',1,11,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12615,11008,'ListItemComment',2,11,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12616,11008,'ListItemComment',3,11,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12617,11008,'Placeholder',1,12,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12618,11008,'ListItemComment',2,12,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12619,11008,'ListItemComment',3,12,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12620,11008,'Placeholder',1,13,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12621,11008,'ListItemComment',2,13,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12622,11008,'ListItemComment',3,13,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12623,11008,'Placeholder',1,14,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12624,11008,'ListItemComment',2,14,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12625,11008,'ListItemComment',3,14,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12626,11008,'Placeholder',1,15,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12627,11008,'ListItemComment',2,15,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12628,11008,'ListItemComment',3,15,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12629,11008,'Placeholder',1,16,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12630,11008,'ListItemComment',2,16,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12631,11008,'ListItemComment',3,16,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12632,11008,'Placeholder',1,17,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12633,11008,'ListItemComment',2,17,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12634,11008,'ListItemComment',3,17,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12635,11008,'ListItem',1,18,"8",NULL,'listitem::::Blev barnet passet udenfor hjemmet før skolestart?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12636,11008,'Rating',2,18,1,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- l\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12637,11008,'ListItemComment',1,19,NULL,NULL,'listitem::::Vuggestue (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2607,8005,'ListItemComment',2,12,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12638,11008,'ListItemComment',1,20,NULL,NULL,'listitem::::Dagpleje  (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2609,8005,'ListItemComment',2,13,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12639,11008,'ListItemComment',1,21,NULL,NULL,'listitem::::Børnehave (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2611,8005,'ListItemComment',2,14,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12640,11008,'ListItem',1,22,"8",NULL,'listitem::::Går barnet i skole?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12641,11008,'Rating',2,22,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- m\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12642,11008,'ListItemComment',1,23,NULL,NULL,'listitem::::Barnets skole (navn og adresse)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12643,11008,'ListItemComment',1,24,NULL,NULL,'listitem::::Klasselærer/kontaktperson###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12644,11008,'ListItemComment',1,25,NULL,NULL,'listitem::::SFO (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12645,11008,'ListItemComment',1,26,NULL,NULL,'listitem::::Eventuelle tidligere skoler, barnet har gået på (navn samt adresse og evt. årstal)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12646,11008,'ListItemComment',1,27,NULL,NULL,'listitem::::Evt. midlertidig opholdsadresse for barnet (efterskole, døgninstitution o.lign.):###textbox::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2621,8005,'TextBox',2,16,NULL,NULL,'###textbox::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (1647,11008,'Placeholder',1,28,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1648,11008,'SectionSubtitle',1,29,NULL,NULL,'sectionsubtitle::::PPR - Pædagogisk-Psykologisk-Rådgivning:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1649,11008,'ListItem',1,30,NULL,NULL,'listitem::::Har I / barnet haft kontakt til PPR',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1650,11008,'Rating',2,30,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- n\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (1651,11008,'ListItemComment',3,30,"6;9",NULL,'listitem::::I hvilken forbindelse (navn og adresse på psykolog:):###textbox::::','--- \n:targets: \n- :target: n\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (1652,11008,'SectionSubtitle',1,32,NULL,NULL,'sectionsubtitle::::Socialforvaltning:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1653,11008,'ListItem',1,33,NULL,NULL,'listitem::::Har I / barnet haft kontakt til socialforvaltning',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1654,11008,'Rating',2,33,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- o\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (1655,11008,'ListItemComment',3,33,"6;9",NULL,'listitem::::I hvilken forbindelse (navn og adresse på sagsbehandler):###textbox::::','--- \n:targets: \n- :target: o\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (1656,11008,'SectionSubtitle',1,35,NULL,NULL,'sectionsubtitle::::Fysioterapi/Ergoterapi:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1657,11008,'ListItem',1,36,NULL,NULL,'listitem::1::Er barnet tidligere undersøgt/behandlet af fysioterapeut/ergoterapeut (navn og adresse):',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1658,11008,'Rating',2,36,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- p\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (1659,11008,'ListItemComment',3,36,"6;9",NULL,'listitem::::I hvilken forbindelse (navn og adresse):###textbox::::','--- \n:targets: \n- :target: p\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1660,11008,'ListItem',1,38,NULL,NULL,'listitem::::Andre:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (1661,11008,'Rating',2,38,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- z\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (1662,11008,'ListItemComment',3,38,"6;9",NULL,'listitem::::I hvilken forbindelse:###textbox::::','--- \n:targets: \n- :target: z\n  :state: offstate\n',1,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (11009,210,9,0,3,NULL);
INSERT INTO `question_cells` VALUES (12663,11009,'SectionSubtitle',1,1,NULL,NULL,'placeholder::::Øvrige sundhedsoplysninger:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12664,11009,'ListItem',1,2,NULL,NULL,'listitem::::Har barnet haft fysiske sygdomme / handicaps?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12665,11009,'Rating',2,2,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- q\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12666,11009,'ListItemComment',3,2,"4;12",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: q\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12667,11009,'ListItem',1,4,NULL,NULL,'listitem::::Har barnet nogensinde været indlagt på sygehus?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12668,11009,'Rating',2,4,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- r\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12669,11009,'ListItemComment',3,4,"6;10",NULL,'listitem::::Hvis ja, for hvilke sygdomme og hvor (afdeling/hospital)###textbox::::','--- \n:targets: \n- :target: r\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12670,11009,'ListItem',1,5,NULL,NULL,'listitem::::Er barnet vaccineret efter det almindelige børnevaccinationsprogram?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12671,11009,'Rating',2,5,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- s\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12672,11009,'ListItemComment',3,5,"6;10",NULL,'listitem::::Beskriv eventuelle undtagelser###textbox::::','--- \n:targets: \n- :target: s\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12673,11009,'ListItem',1,6,NULL,NULL,'listitem::::Får barnet medicin?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12674,11009,'Rating',2,6,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- t\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (12675,11009,'Placeholder',1,7,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (12680,11009,'ListItemComment',1,8,NULL,NULL,'listitem::::Hvilken medicin###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12681,11009,'ListItemComment',2,8,NULL,NULL,'listitem::::For hvad?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12682,11009,'ListItemComment',3,8,NULL,NULL,'listitem::::Hvornår?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12684,11009,'ListItemComment',1,9,NULL,NULL,'listitem::::Hvilken medicin?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12685,11009,'ListItemComment',2,9,NULL,NULL,'listitem::::For hvad?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (12686,11009,'ListItemComment',3,9,NULL,NULL,'listitem::::Hvornår?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);


-- INSERT INTO `question_cells` VALUES (2700,11009,'Placeholder',1,10,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2701,11009,'SectionSubtitle',1,11,NULL,NULL,'sectionsubtitle::::Kontakt til forskningsenheden',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2702,11009,'ListItem',1,12,NULL,NULL,'listitem::::Må forskningsenheden kontakte dig?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2703,11009,'Rating',2,12,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- ac\n',1, 11,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2704,11009,'Rating',1,13,"6",NULL,'radio::1::Mors email###radio::2::Fars email###','--- \n:targets: \n- :target: ac\n  :state: offstate\n',1,14,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2705,11009,'ListItem',2,13,"3;8",NULL,'listitem::::Email###listitem::::','--- \n:targets: \n- :target: ac\n  :state: offstate\n',1, NULL,NULL,NULL);

-- DELETE from `choices` where `id` IN (14, 15, 16, 17); 
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`) VALUES (14, 'email_mor_far', '1::Mors email;;2::Fars email', '1::Mors email;;2::Fars email');
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`) VALUES (15, 'henv_5', '1::Forældre;;2::Institution/skole;;3::Egen læge;;4::Kommune/PPR;;5::Andre', '1::Forældre;;2::Institution/skole;;3::Egen læge;;4::Kommune/PPR;;5::Andre');
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`) VALUES (16, 'foedt_5', '1::Ekstremt tidligt født (før 28. svangerskabsuge);;2::Meget tidligt født (28. - 32. svangerskabsuge);;3::Moderat tidligt født (33. - 36. svangerskabsuge);;4::Til termin (37. - 42. svangerskabsuge);;5::Overbåren (efter 42. svangerskabsuge)', '1::Ekstremt tidligt født (før 28. svangerskabsuge);;2::Meget tidligt født (28. - 32. svangerskabsuge);;3::Moderat tidligt født (33. - 36. svangerskabsuge);;4::Til termin (37. - 42. svangerskabsuge);;5::Overbåren (efter 42. svangerskabsuge)');
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`)VALUES (17, 'yn_2', 'Nej, Ja', '0::Nej;;1::Ja');

COMMIT;
SET FOREIGN_KEY_CHECKS=1;