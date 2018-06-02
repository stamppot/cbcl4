SET FOREIGN_KEY_CHECKS=0;

START TRANSACTION;

-- INSERT INTO `surveys` VALUES (11,'Oplysningsskema 18 år','INFO','Oplysningsskema (Ungeskema)','16-18','youth','f23737',99,'info18','INFO');

delete from question_cells where question_id >= 1100 and question_id <= 1107;
delete from questions where id >= 1100 and id <= 1107;

INSERT INTO `questions` VALUES (1100,11,1,0,2,NULL);
INSERT INTO `question_cells` VALUES (2750,1100,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Du er indkaldt til undersøgelse.\nVi vil bede dig om at udfylde oplysningsskemaet forud for dit første besøg i ambulatoriet.',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2751,1100,'ListItem',1,2,"8",NULL,'listitem::::Dags dato:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2752,1100,'ListItemComment',2,2,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2753,1100,'ListItem',1,3,"8",NULL,'listitem::::Fulde navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2754,1100,'ListItemComment',2,3,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2755,1100,'ListItem',1,4,"8",NULL,'listitem::::Fødselsdag:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2756,1100,'ListItemComment',2,4,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2757,1100,'ListItem',1,5,"8",NULL,'listitem::::Dit telefonnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2758,1100,'ListItemComment',2,5,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2760,1100,'Placeholder',1,6,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2761,1100,'SectionSubtitle',1,7,NULL,NULL,'sectionsubtitle::::Oplysninger om pårørende:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2762,1100,'ListItem',1,8,"8",NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2763,1100,'ListItemComment',2,8,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2764,1100,'ListItem',1,9,"8",NULL,'listitem::::Familieforhold: (ex. mor, far, bonusforældre)',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2765,1100,'ListItemComment',2,9,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2766,1100,'ListItem',1,10,"8",NULL,'listitem::::Telefonnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2767,1100,'ListItemComment',2,10,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (2421,1000,'Placeholder',1,13,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2422,1000,'SectionSubtitle',1,14,NULL,NULL,'sectionsubtitle::::Oplysninger om far:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2423,1000,'ListItem',1,15,"8",NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2424,1000,'ListItemComment',2,15,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2425,1000,'ListItem',1,16,"8",NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2426,1000,'ListItemComment',2,16,"8",NULL,'itemunit::::år',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2427,1000,'ListItem',1,17,"8",NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2428,1000,'ListItemComment',2,17,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2429,1000,'ListItem',1,18,"8",NULL,'listitem::::Postnummer og by:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2430,1000,'ListItemComment',2,18,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2431,1000,'ListItem',1,19,"8",NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2432,1000,'ListItemComment',2,19,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2433,1000,'ListItem',1,20,"8",NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2434,1000,'ListItemComment',2,20,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (2435,1000,'Placeholder',1,22,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2436,1000,'SectionSubtitle',1,23,NULL,NULL,'sectionsubtitle::::Oplysninger om evt. bonusfar/bonusmor på barnets folkeregisterbopæl:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2437,1000,'ListItem',1,24,"8",NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2438,1000,'ListItemComment',2,24,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2439,1000,'ListItem',1,25,"8",NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2440,1000,'ListItemComment',2,25,"8",NULL,'itemunit::::år',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2441,1000,'ListItem',1,26,"8",NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2442,1000,'ListItemComment',2,26,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2443,1000,'ListItem',1,27,"8",NULL,'listitem::::Postnummer og by:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2444,1000,'ListItemComment',2,27,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (2445,1000,'ListItem',1,28,"8",NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2446,1000,'ListItemComment',2,28,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2447,1000,'ListItem',1,29,"8",NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2448,1000,'ListItemComment',2,29,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2449,1000,'Placeholder',1,30,"8",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2450,1000,'ListItem',1,31,"8",NULL,'listitem::::Evt barnets/den unges eget tlf.nr.:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2451,1000,'ListItemComment',2,31,"8",NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

-- INSERT INTO `questions` VALUES (1002,11,2,0,2,NULL);
-- INSERT INTO `question_cells` VALUES (2452,1002,'ListItem',1,1,"8",NULL,'listitem::::Lever biologiske forældre sammen?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2453,1002,'Rating',2,1,"1",NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- ay\n',1, 11,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2454,1002,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvis forældrene er skilte:','--- \n:targets: \n- :target: ay\n  :state: onstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2455,1002,'ListItem',1,3,"8",NULL,'listitem::::Hvem har forældremyndigheden:','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2456,1002,'ListItemComment',2,3,"6",NULL,'listitem::::','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2457,1002,'ListItemComment',1,4,"8;10",NULL,'listitem::::Forhold omkring samvær###textbox::::','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1101,11,2,0,3,NULL);
INSERT INTO `question_cells` VALUES (2771,1101,'SectionSubtitle',1,1,NULL,NULL,'sectionsubtitle::::Vedr. henvisningen:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2772,1101,'ListItem',1,2,"8",NULL,'listitem::::På hvis initiativ er henvisningen sket?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2773,1101,'Rating',2,2,"5",NULL,'radio::1::Forældre###radio::2::Institution/skole###radio::3::Egen læge###radio::4::Kommune/PPR###radio::5::Andre',NULL,1,15,NULL,NULL);
INSERT INTO `question_cells` VALUES (2774,1101,'ListItemComment',3,2,"4;8",NULL,'listitem::::Hvis andre, hvem?###textbox::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2775,1101,'ListItem',1,3,"8",NULL,'listitem::::Kort beskrivelse af det forløb der har medført henvisning til undersøgelse',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2776,1101,'TextBox',2,3,"10",NULL,'textbox::::',NULL,0,NULL,NULL,NULL);

-- Note 2
INSERT INTO `question_cells` VALUES (2780,1101,'Placeholder',1,4,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2781,1101,'SectionSubtitle',1,4,NULL,NULL,'sectionsubtitle::::Kontakt til forskningsenheden',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2782,1101,'ListItem',1,5,NULL,NULL,'listitem::::Må forskningsenheden kontakte dig?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2783,1101,'Rating',2,5,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- ac\n',1, 11,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2784,1101,'Rating',1,6,"6",NULL,'radio::1::Mors email###radio::2::Fars email###','--- \n:targets: \n- :target: ac\n  :state: offstate\n',1,14,NULL,NULL);
INSERT INTO `question_cells` VALUES (2785,1101,'ListItemComment',2,6,"3;8",NULL,'listitem::::Din egen email###listitem::::','--- \n:targets: \n- :target: ac\n  :state: offstate\n',1, NULL,NULL,NULL);

-- Note 1 - TODO: make kind of block
INSERT INTO `question_cells` VALUES (2790,1101,'Placeholder',1,7,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2791,1101,'SectionSubtitle',1,8,NULL,NULL,'information::::Har du inden for de sidste 6 mdr., været henvist og dermed udfyldt nedenstående spørgsmål, bedes du se bort fra udfyldelse af resten af skemaet.<p/>Hvis der er tilkommet ændringer i oplysningerne bedes disse tilføjet.',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1102,11,3,0,2,NULL);
INSERT INTO `question_cells` VALUES (2794,1102,'ListItem',1,1,"7",NULL,'listitem::::Er du allergisk over for noget?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2795,1102,'Rating',2,1,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- a\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2796,1102,'ListItemComment',3,1,"2;11",NULL,'listitem::::Hvis ja, for hvad?###textbox::::','--- \n:targets: \n- :target: a\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1103,11,4,0,3,NULL);
INSERT INTO `question_cells` VALUES (2833,1103,'Questiontext',1,1,NULL,NULL,'questiontext::::Er der nogle i din familie (1. leds slægtninge) der har psykiske og fysiske vanskeligheder?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2834,1103,'ListItem',1,2,NULL,NULL,'listitem::::Mor',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2835,1103,'Rating',2,2,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- u\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2836,1103,'ListItemComment',3,2,"8",NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom###textbox::::','--- \n:targets: \n- :target: u\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2837,1103,'ListItem',1,3,NULL,NULL,'listitem::::Far',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2838,1103,'Rating',2,3,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- v\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2839,1103,'ListItemComment',3,3,"8",NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom###textbox::::','--- \n:targets: \n- :target: v\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2840,1103,'ListItem',1,4,NULL,NULL,'listitem::::Søskende',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2841,1103,'Rating',2,4,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- w\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2842,1103,'ListItemComment',3,4,"8",NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom###textbox::::','--- \n:targets: \n- :target: w\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (241103004,'ListItemComment',1,6,NULL,NULL,'listitem::::Hvis ja, beskriv###textbox::::','--- \n:targets: \n- :target: w\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2843,1103,'ListItem',1,5,NULL,NULL,'listitem::::Er der nogen i din familie, der har vanskeligheder der ligner dine?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2844,1103,'Rating',2,5,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- x\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2845,1103,'ListItemComment',3,5,"3;8",NULL,'listitem::::Hvis ja, beskriv###textbox::::','--- \n:targets: \n- :target: x\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2846,1103,'ListItem',1,6,NULL,NULL,'listitem::::Er der nogen i din familie, som har et alkohol eller stofmisbrug',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2847,1103,'Rating',2,6,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- b\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2848,1103,'ListItemComment',3,6,"3;8",NULL,'listitem::::Hvis ja, hvilket?###textbox::::','--- \n:targets: \n- :target: b\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2849,1103,'ListItem',1,7,NULL,NULL,'listitem::::Er der nogen i din familie, som har begået selvmord?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2850,1103,'Rating',2,7,"2",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- ab\n',0,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2851,1103,'ListItemComment',3,7,"3;8",NULL,'listitem::::Hvis ja, uddyb###textbox::::','--- \n:targets: \n- :target: ab\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2469,1002,'TextBox',2,6,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1104,11,5,0,3,NULL);
INSERT INTO `question_cells` VALUES (2860,1104,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Sundhedsoplysninger',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2861,1104,'SectionSubtitle',1,2,NULL,NULL,'sectionsubtitle::::Graviditet og fødsel:',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2862,1104,'ListItem',1,3,NULL,NULL,'listitem::::Var der sygdom hos din mor under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2863,1104,'Rating',2,3,"1",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- c\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2864,1104,'ListItemComment',3,3,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilken###textbox::::','--- \n:targets: \n- :target: c\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `question_cells` VALUES (2866,1104,'ListItem',1,5,NULL,NULL,'listitem::::Tog din mor medicin under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2867,1104,'Rating',2,5,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- d\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2868,1104,'ListItemComment',3,5,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilken###textbox::::','--- \n:targets: \n- :target: d\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2869,1104,'ListItem',1,7,NULL,NULL,'listitem::::Var der komplikationer i graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2870,1104,'Rating',2,7,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- e\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2871,1104,'ListItemComment',3,7,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: e\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2872,1104,'ListItem',1,9,NULL,NULL,'listitem::::Var der komplikationer under fødslen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2873,1104,'Rating',2,9,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- f\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2874,1104,'ListItemComment',4,9,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: f\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2875,1104,'ListItem',1,11,NULL,NULL,'listitem::::Røg din mor tobak under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2876,1104,'Rating',2,11,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- g\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2877,1104,'ListItemComment',3,11,"4;10",NULL,'listitem::::Hvis ja, ca. hvor meget?###textbox::::','--- \n:targets: \n- :target: g\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2878,1104,'ListItem',1,13,NULL,NULL,'listitem::::Drak din mor alkohol under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2879,1104,'Rating',2,13,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- h\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2880,1104,'ListItemComment',3,13,"4;10",NULL,'listitem::::Hvis ja, ca. hvor meget?###textbox::::','--- \n:targets: \n- :target: h\n  :state: offstate\n',0,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3021,1104,'ListItem',1,15,NULL,NULL,'listitem::::Hvornår er barnet født?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3022,1104,'SelectOption',2,15,"8",7,'option::1::Ektremt tidligt født (før 28. svangerskabsuge)###option::2::Meget tidligt født (28. - 32. svangerskabsuge)###radio::3::Moderat tidligt født (33. - 36. svangerskabsuge)###option::4::Til termin (37. - 42. svangerskabsuge)###option::5::Overbåren (efter 42. svangerskabsuge)',NULL,1,16,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3023,1104,'Questiontext',1,16,NULL,NULL,'questiontext::::Barnets mål og vægt ved fødslen',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3024,1104,'Placeholder',1,17,"7",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3025,1104,'ListItem',2,17,"5",NULL,'listitem::::længde',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3026,1104,'ListItemComment',3,17,NULL,NULL,'itemunit::::cm',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3027,1104,'Placeholder',1,18,"7",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3028,1104,'ListItem',2,18,"5",NULL,'listitem::::vægt',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3029,1104,'ListItemComment',3,18,NULL,NULL,'itemunit::::gram',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2881,1104,'ListItem',1,19,NULL,NULL,'listitem::::Har du medfødte sygdomme?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2882,1104,'Rating',2,19,1,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- i\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2883,1104,'ListItemComment',3,19,"4;10",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: i\n  :state: offstate\n',0,NULL,NULL,NULL);


-- INSERT INTO `questions` VALUES (1105,11,7,0,4,NULL);
-- INSERT INTO `question_cells` VALUES (3040,1105,'SectionSubtitle',1,1,NULL,NULL,'sectionsubtitle::::Tidlig barndom:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3041,1105,'ListItem',1,2,"8",NULL,'listitem::::Var der komplikationer i spædbarnsperioden?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3042,1105,'Rating',2,2,"1",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- j\n',1,11,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3043,1105,'ListItemComment',3,2,"4;12",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: j\n  :state: offstate\n',0,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3046,1105,'ListItem',1,3,"8",NULL,'listitem::::Var der kontakt til sundhedsplejerske?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3047,1105,'Rating',2,3,"1",NULL,'radio::0::Nej###radio::1::Ja',NULL,1,11,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3048,1105,'ListItem',1,4,"8",NULL,'listitem::::Blev barnet ammet?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3049,1105,'Rating',2,4,"1",NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- k\n',1,11,NULL,NULL);
-- -- INSERT INTO `question_cells` VALUE30(251105007,'Placeholder',1,5,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3051,1105,'ListItemComment',1,5,"8",NULL,'listitem::::Udelukkende amning (ca. antal uger)###itemunit::::uger','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
-- -- INSERT INTO `question_cells` VALUE30(251105007,'Placeholder',1,6,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3053,1105,'ListItemComment',1,6,"8",NULL,'listitem::::Delvis amning (ca. antal uger)###itemunit::::uger','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3061,1105,'ListItem',1,9,"12",NULL,'listitem::::Hvordan var kontakten med barnet i spædbarnsperioden (øjenkontakt, smil, pludren, kunne barnet trøstes, brød det sig om kropskontakt m.v.)',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3062,1105,'TextBox',2,9,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3063,1105,'Questiontext',1,11,NULL,NULL,'questiontext::::Hvornår kunne barnet:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3064,1105,'Placeholder',1,11,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3065,1105,'ListItem',2,11,"4",NULL,'listitem::::Sidde',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3066,1105,'ListItemComment',3,11,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3067,1105,'Placeholder',1,12,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3068,1105,'ListItem',2,12,"4",NULL,'listitem::::Kravle',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3069,1105,'ListItemComment',3,12,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3070,1105,'Placeholder',1,13,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3071,1105,'ListItem',2,13,"4",NULL,'listitem::::Gå',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3072,1105,'ListItemComment',3,13,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3073,1105,'Placeholder',1,14,"5",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3074,1105,'ListItem',2,14,"4",NULL,'listitem::::Sige enkelte ord',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3075,1105,'ListItemComment',3,14,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3076,1105,'ListItem',1,15,"9",NULL,'listitem::::Hvornår var barnet renligt?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3077,1105,'ListItemComment',2,15,"4",NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3078,1105,'ListItem',1,24,"9",NULL,'listitem::::Er barnet vådligger?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3079,1105,'Rating',2,24,"1",NULL,'radio::0::Nej###radio::1::Ja',NULL,1,11,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3080,1105,'ListItem',1,25,"9",NULL,'listitem::::Er der "uheld" om dagen?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3081,1105,'Rating',2,25,"1",NULL,'radio::0::Nej###radio::1::Ja',NULL,1,11,NULL,NULL);


INSERT INTO `questions` VALUES (1106,11,6,0,3,NULL);
-- INSERT INTO `question_cells` VALUES (3090,1106,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Oplysninger vedrørende netværk',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3091,1106,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvem bor i samme husstand som barnet?',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3092,1106,'ListItem',2,2,"6",NULL,'listitem::::Fornavn:',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3093,1106,'ListItem',3,2,"6",NULL,'listitem::::Familieforhold til barnet:\n(ex: mor, far søskende, bonusmor, bonusfar, bonussøskende)',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3094,1106,'Placeholder',1,3,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3095,1106,'ListItemComment',2,3,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3096,1106,'ListItemComment',3,3,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3097,1106,'Placeholder',1,4,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3098,1106,'ListItemComment',2,4,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3099,1106,'ListItemComment',3,4,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3100,1106,'Placeholder',1,5,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3101,1106,'ListItemComment',2,5,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3102,1106,'ListItemComment',3,5,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3103,1106,'Placeholder',1,6,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3104,1106,'ListItemComment',2,6,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3105,1106,'ListItemComment',3,6,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3106,1106,'Placeholder',1,7,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3107,1106,'ListItemComment',2,7,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3108,1106,'ListItemComment',3,7,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3109,1106,'Placeholder',1,8,"6",NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3110,1106,'Information',1,9,NULL,NULL,'information::::Ved skilsmisse:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3111,1106,'Questiontext',1,11,NULL,NULL,'questiontext::::Hvem bor i den anden forældres husstand?',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3112,1106,'ListItem',2,11,"6",NULL,'listitem::::Fornavn:',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3113,1106,'ListItem',3,11,"6",NULL,'listitem::::Familieforhold til barnet:\n(ex: mor, far søskende, bonusmor, bonusfar, bonussøskende)',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3114,1106,'Placeholder',1,11,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3115,1106,'ListItemComment',2,11,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3116,1106,'ListItemComment',3,11,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3117,1106,'Placeholder',1,12,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3118,1106,'ListItemComment',2,12,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3119,1106,'ListItemComment',3,12,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3120,1106,'Placeholder',1,13,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3121,1106,'ListItemComment',2,13,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3122,1106,'ListItemComment',3,13,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3123,1106,'Placeholder',1,14,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3124,1106,'ListItemComment',2,14,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3125,1106,'ListItemComment',3,14,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3126,1106,'Placeholder',1,15,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3127,1106,'ListItemComment',2,15,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3128,1106,'ListItemComment',3,15,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3129,1106,'Placeholder',1,16,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3130,1106,'ListItemComment',2,16,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3131,1106,'ListItemComment',3,16,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3132,1106,'Placeholder',1,17,"6",NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3133,1106,'ListItemComment',2,17,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3134,1106,'ListItemComment',3,17,"6",NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3135,1106,'ListItem',1,18,"8",NULL,'listitem::::Blev barnet passet udenfor hjemmet før skolestart?',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3136,1106,'Rating',2,18,1,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- l\n',1,11,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3137,1106,'ListItemComment',1,19,NULL,NULL,'listitem::::Vuggestue (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- -- INSERT INTO `question_cells` VALUE31(261106005,'ListItemComment',2,12,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3138,1106,'ListItemComment',1,20,NULL,NULL,'listitem::::Dagpleje  (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- -- INSERT INTO `question_cells` VALUE31(261106005,'ListItemComment',2,13,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3139,1106,'ListItemComment',1,21,NULL,NULL,'listitem::::Børnehave (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- -- INSERT INTO `question_cells` VALUE31(261106005,'ListItemComment',2,14,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2890,1106,'ListItem',1,22,"8",NULL,'listitem::::Går du i skole eller andet?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2891,1106,'Rating',2,22,NULL,NULL,'radio::0::Nej###radio::1::Ja###radio::2::Andet','--- \n:switch: \n- m\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2892,1106,'ListItemComment',1,23,NULL,NULL,'listitem::::Din skole (navn og adresse)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUE289261106005,'ListItemComment',2,12,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2893,1106,'ListItemComment',1,24,NULL,NULL,'listitem::::Klasselærer/kontaktperson###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUE289261106005,'ListItemComment',2,13,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2894,1106,'ListItemComment',1,25,NULL,NULL,'listitem::::SFO (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUE289261106005,'ListItemComment',2,14,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2895,1106,'ListItemComment',1,26,NULL,NULL,'listitem::::Eventuelle tidligere skoler, du har gået på (navn samt adresse og evt. årstal)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2896,1106,'ListItemComment',1,27,NULL,NULL,'listitem::::Evt. midlertidig opholdsadresse (døgninstitution o.lign.):###textbox::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUE289261106005,'TextBox',2,16,NULL,NULL,'###textbox::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2897,1106,'Placeholder',1,28,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2898,1106,'SectionSubtitle',1,29,NULL,NULL,'sectionsubtitle::::PPR - Pædagogisk-Psykologisk-Rådgivning:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2899,1106,'ListItem',1,30,NULL,NULL,'listitem::::Har du haft kontakt til PPR?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2900,1106,'Rating',2,30,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- n\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2901,1106,'ListItemComment',3,30,"6;9",NULL,'listitem::::I hvilken forbindelse (navn og adresse på psykolog:):###textbox::::','--- \n:targets: \n- :target: n\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2902,1106,'SectionSubtitle',1,32,NULL,NULL,'sectionsubtitle::::Socialforvaltning:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2903,1106,'ListItem',1,33,NULL,NULL,'listitem::::Har du haft kontakt til socialforvaltning?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2904,1106,'Rating',2,33,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- o\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2905,1106,'ListItemComment',3,33,"6;9",NULL,'listitem::::I hvilken forbindelse (navn og adresse på sagsbehandler):###textbox::::','--- \n:targets: \n- :target: o\n  :state: offstate\n',1,NULL,NULL,NULL);

-- INSERT INTO `question_cells` VALUES (3156,1106,'SectionSubtitle',1,35,NULL,NULL,'sectionsubtitle::::Fysioterapi/Ergoterapi:',NULL,0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3157,1106,'ListItem',1,36,NULL,NULL,'listitem::1::Er barnet tidligere undersøgt/behandlet af fysioterapeut/ergoterapeut (navn og adresse):',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3158,1106,'Rating',2,36,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- p\n',1,11,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (3159,1106,'ListItemComment',3,36,"6;9",NULL,'listitem::::I hvilken forbindelse (navn og adresse):###textbox::::','--- \n:targets: \n- :target: p\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2906,1106,'ListItem',1,38,NULL,NULL,'listitem::::Andre:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2907,1106,'Rating',2,38,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- z\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2908,1106,'ListItemComment',3,38,"6;9",NULL,'listitem::::I hvilken forbindelse:###textbox::::','--- \n:targets: \n- :target: z\n  :state: offstate\n',1,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1107,11,7,0,3,NULL);
INSERT INTO `question_cells` VALUES (2913,1107,'SectionSubtitle',1,1,NULL,NULL,'placeholder::::Øvrige sundhedsoplysninger:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2914,1107,'ListItem',1,2,NULL,NULL,'listitem::::Har du haft fysiske sygdomme / handicaps?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2915,1107,'Rating',2,2,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- q\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2916,1107,'ListItemComment',3,2,"4;12",NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: q\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2917,1107,'ListItem',1,4,NULL,NULL,'listitem::::Har du nogensinde været indlagt på sygehus?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2918,1107,'Rating',2,4,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- r\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2919,1107,'ListItemComment',3,4,"6;10",NULL,'listitem::::Hvis ja, for hvilke sygdomme og hvor (afdeling/hospital)###textbox::::','--- \n:targets: \n- :target: r\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2920,1107,'ListItem',1,5,NULL,NULL,'listitem::::Er du vaccineret efter det almindelige børnevaccinationsprogram?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2921,1107,'Rating',2,5,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- s\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2922,1107,'ListItemComment',3,5,"6;10",NULL,'listitem::::Beskriv eventuelle undtagelser###textbox::::','--- \n:targets: \n- :target: s\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2923,1107,'ListItem',1,6,NULL,NULL,'listitem::::Får du medicin?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2924,1107,'Rating',2,6,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- t\n',1,11,NULL,NULL);
INSERT INTO `question_cells` VALUES (2925,1107,'Placeholder',1,7,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2930,1107,'ListItemComment',1,8,NULL,NULL,'listitem::::Hvilken medicin###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2931,1107,'ListItemComment',2,8,NULL,NULL,'listitem::::For hvad?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2932,1107,'ListItemComment',3,8,NULL,NULL,'listitem::::Hvornår?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUE293261107006,'Placeholder',1,11,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2934,1107,'ListItemComment',1,9,NULL,NULL,'listitem::::Hvilken medicin?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2935,1107,'ListItemComment',2,9,NULL,NULL,'listitem::::For hvad?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2936,1107,'ListItemComment',3,9,NULL,NULL,'listitem::::Hvornår?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);


-- DELETE from `choices` where `id` IN (14, 15, 16, 17); 
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`) VALUES (14, 'email_mor_far', '1::Mors email;;2::Fars email', '1::Mors email;;2::Fars email');
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`) VALUES (15, 'henv_5', '1::Forældre;;2::Institution/skole;;3::Egen læge;;4::Kommune/PPR;;5::Andre', '1::Forældre;;2::Institution/skole;;3::Egen læge;;4::Kommune/PPR;;5::Andre');
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`) VALUES (16, 'foedt_5', '1::Ekstremt tidligt født (før 28. svangerskabsuge);;2::Meget tidligt født (28. - 32. svangerskabsuge);;3::Moderat tidligt født (33. - 36. svangerskabsuge);;4::Til termin (37. - 42. svangerskabsuge);;5::Overbåren (efter 42. svangerskabsuge)', '1::Ekstremt tidligt født (før 28. svangerskabsuge);;2::Meget tidligt født (28. - 32. svangerskabsuge);;3::Moderat tidligt født (33. - 36. svangerskabsuge);;4::Til termin (37. - 42. svangerskabsuge);;5::Overbåren (efter 42. svangerskabsuge)');
-- INSERT INTO `choices` (`id`, `name`, `full`, `options`)VALUES (17, 'yn_2', 'Nej, Ja', '0::Nej;;1::Ja');

DELETE from `choices` where `id` IN (18); 
INSERT INTO `choices` (`id`, `name`, `full`, `options`) VALUES (18, 'henv_5_18', '1::Forældre;;2::Institution/skole;;3::Egen læge;;4::Kommune/PPR;;5::Andre', '1::Forældre;;2::Institution/skole;;3::Egen læge;;4::Kommune;;5::Andre');

COMMIT;
SET FOREIGN_KEY_CHECKS=1;