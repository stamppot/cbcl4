START TRANSACTION;

-- INSERT INTO `surveys` VALUES (10,'Oplysningsskema','INFO','Oplysningsskema (Forældreskema)','1.5-16','parent','f23737',99,'info','INFO');

delete from questions where id >= 1000 and id <= 1008;
delete from question_cells where question_id >= 1000 and question_id <= 1008;

INSERT INTO `questions` VALUES (1000,10,1,0,2,NULL);
INSERT INTO `question_cells` VALUES (2400,1000,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Kære forældre,<p/>Jeres barn er sammen med jer indkaldt til undersøgelse.\nVi vil bede jer om at udfylde oplysningsskemaet forud for jeres første besøg i ambulatoriet.',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2401,1000,'ListItem',1,2,NULL,NULL,'listitem::::Barnets navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2402,1000,'ListItemComment',2,2,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2403,1000,'ListItem',1,3,NULL,NULL,'listitem::::Barnets fødselsdag:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2404,1000,'ListItemComment',2,3,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2405,1000,'ListItem',1,4,NULL,NULL,'listitem::::Dato:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2406,1000,'ListItemComment',2,4,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2407,1000,'Placeholder',1,6,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2408,1000,'SectionSubtitle',1,7,NULL,NULL,'sectionsubtitle::::Oplysninger om mor:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2409,1000,'ListItem',1,8,NULL,NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2410,1000,'ListItemComment',2,8,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2411,1000,'ListItem',1,9,NULL,NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2412,1000,'ListItemComment',2,9,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2413,1000,'ListItem',1,10,NULL,NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2414,1000,'ListItemComment',2,10,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2415,1000,'ListItem',1,11,NULL,NULL,'listitem::::Postnummer og by:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2416,1000,'ListItemComment',2,11,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2417,1000,'ListItem',1,12,NULL,NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2418,1000,'ListItemComment',2,12,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2419,1000,'ListItem',1,13,NULL,NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2420,1000,'ListItemComment',2,13,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2421,1000,'Placeholder',1,14,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2422,1000,'SectionSubtitle',1,15,NULL,NULL,'sectionsubtitle::::Oplysninger om far:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2423,1000,'ListItem',1,16,NULL,NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2424,1000,'ListItemComment',2,16,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2425,1000,'ListItem',1,17,NULL,NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2426,1000,'ListItemComment',2,17,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2427,1000,'ListItem',1,18,NULL,NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2428,1000,'ListItemComment',2,18,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2429,1000,'ListItem',1,19,NULL,NULL,'listitem::::Postnummer og by:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2430,1000,'ListItemComment',2,19,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2431,1000,'ListItem',1,20,NULL,NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2432,1000,'ListItemComment',2,20,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2433,1000,'ListItem',1,21,NULL,NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2434,1000,'ListItemComment',2,21,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2435,1000,'Placeholder',1,22,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2436,1000,'SectionSubtitle',1,23,NULL,NULL,'sectionsubtitle::::Oplysninger om evt. bonusfar/bonusmor på folkeregisterbopæl:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2437,1000,'ListItem',1,24,NULL,NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2438,1000,'ListItemComment',2,24,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2439,1000,'ListItem',1,25,NULL,NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2440,1000,'ListItemComment',2,25,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2441,1000,'ListItem',1,26,NULL,NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2442,1000,'ListItemComment',2,26,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2443,1000,'ListItem',1,27,NULL,NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2444,1000,'ListItemComment',2,27,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2445,1000,'ListItem',1,28,NULL,NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2446,1000,'ListItemComment',2,28,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2447,1000,'Placeholder',1,29,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2448,1000,'ListItem',1,30,NULL,NULL,'listitem::::Evt barnets/den unges eget tlf.nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2449,1000,'ListItemComment',2,30,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2450,1000,'ListItem',1,31,NULL,NULL,'listitem::::Må forskningsenheden kontakte dig pr. telefon??',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2451,1000,'Rating',2,31,NULL,NULL,'radio::1::Ja###radio::0::Nej',NULL,1, NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2452,1000,'Placeholder',1,29,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1002,10,2,0,2,NULL);
INSERT INTO `question_cells` VALUES (2452,1002,'ListItem',1,1,NULL,NULL,'listitem::::Lever biologiske forældre sammen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2453,1002,'Rating',2,1,NULL,NULL,'radio::0::Ja###radio::1::Nej','--- \n:switch: \n- ay\n',1, NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2454,1002,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvis forældrene er skilte:','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2455,1002,'ListItem',1,3,NULL,NULL,'listitem::::Hvem har forældremyndigheden:','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2456,1002,'ListItemComment',2,3,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2457,1002,'ListItem',1,4,NULL,NULL,'listitem::::Forhold omkring samvær','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2458,1002,'TextBox',2,4,NULL,NULL,'textbox::::','--- \n:targets: \n- :target: ay\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1003,10,3,0,3,NULL);
INSERT INTO `question_cells` VALUES (2690,1003,'Questiontext',1,1,NULL,NULL,'questiontext::::På hvis initiativ er henvisningen sket?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2691,1003,'Rating',2,1,NULL,NULL,'radio::1::Forældre###radio::2::Institution/skole###radio::3::Egen læge###radio::4::Kommune/PPR###radio::5::Andre',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2692,1003,'ListItemComment',3,1,NULL,NULL,'listitem::::Hvis andre, hvem?###textbox::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2693,1003,'SectionSubtitle',1,1,NULL,NULL,'sectionsubtitle::::Vedr. henvisningen:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2694,1003,'Questiontext',1,4,NULL,NULL,'questiontext::::Kort beskrivelse af det forløb der har medført henvisning til børnepsykiatrisk undersøgelse',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2695,1003,'TextBox',2,4,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1004,10,4,0,2,NULL);
INSERT INTO `question_cells` VALUES (2470,1004,'ListItem',1,1,NULL,NULL,'listitem::::Er barnet allergisk over for noget?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2471,1004,'Rating',2,1,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- a\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2472,1004,'ListItemComment',3,1,NULL,NULL,'listitem::::Hvis ja, for hvad?###textbox::::','--- \n:targets: \n- :target: a\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2473,1004,'Questiontext',1,2,NULL,NULL,'questiontext::::Er der nogle i barnets familie (1. leds slægtninge) der har psykiske og fysiske vanskeligheder?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2474,1004,'ListItem',1,3,NULL,NULL,'listitem::::Mor',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2475,1004,'Rating',2,3,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- u\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2476,1004,'ListItemComment',3,3,NULL,NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom (mulighed for flere sygdomme)###textbox::::','--- \n:targets: \n- :target: u\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2477,1004,'ListItem',1,4,NULL,NULL,'listitem::::Far',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2478,1004,'Rating',2,4,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- v\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2479,1004,'ListItemComment',3,4,NULL,NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom (mulighed for flere sygdomme)###textbox::::','--- \n:targets: \n- :target: v\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2480,1004,'ListItem',1,5,NULL,NULL,'listitem::::Søskende',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2481,1004,'Rating',2,5,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- w\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2482,1004,'ListItemComment',3,5,NULL,NULL,'listitem::::Personens alder ved sygdomsstart - år, og hvilken sygdom (mulighed for flere sygdomme)###textbox::::','--- \n:targets: \n- :target: w\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2470,1004,'ListItemComment',1,6,NULL,NULL,'listitem::::Hvis ja, beskriv###textbox::::','--- \n:targets: \n- :target: w\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2483,1004,'ListItem',1,7,NULL,NULL,'listitem::::Er der nogen i barnets familie, der har vanskeligheder der ligner barnets?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2484,1004,'Rating',2,7,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- x\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2485,1004,'ListItemComment',3,7,NULL,NULL,'listitem::::Hvis ja, beskriv###textbox::::','--- \n:targets: \n- :target: x\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2486,1004,'ListItem',1,8,NULL,NULL,'listitem::::Er der nogen i barnets familie, som har et alkohol eller stofmisbrug',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2487,1004,'Rating',2,8,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- b\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2488,1004,'ListItemComment',3,8,NULL,NULL,'listitem::::Hvis ja, hvilket?###textbox::::','--- \n:targets: \n- :target: b\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2489,1004,'ListItem',1,9,NULL,NULL,'listitem::::Er der nogen i barnets familie, som har begået selvmord?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2490,1004,'Rating',2,9,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- ab\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2491,1004,'ListItemComment',3,9,NULL,NULL,'listitem::::Hvis ja, uddyb###textbox::::','--- \n:targets: \n- :target: ab\n  :state: offstate\n',0,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2469,1002,'TextBox',2,6,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1005,10,5,0,3,NULL);
INSERT INTO `question_cells` VALUES (2500,1005,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Sundhedsoplysninger',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2501,1005,'SectionSubtitle',1,2,NULL,NULL,'sectionsubtitle::::Graviditet og fødsel:',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2502,1005,'ListItem',1,3,NULL,NULL,'listitem::::Var der sygdom hos barnets mor under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2503,1005,'Rating',2,3,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- c\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2504,1005,'ListItemComment',3,3,NULL,NULL,'listitem::::Hvis ja, beskriv hvilken###textbox::::','--- \n:targets: \n- :target: c\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `question_cells` VALUES (2506,1005,'ListItem',1,5,NULL,NULL,'listitem::::Tog moderen medicin under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2507,1005,'Rating',2,5,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- d\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2508,1005,'ListItemComment',3,5,NULL,NULL,'listitem::::Hvis ja, beskriv hvilken###textbox::::','--- \n:targets: \n- :target: d\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2509,1005,'ListItem',1,7,NULL,NULL,'listitem::::Var der komplikationer i graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2510,1005,'Rating',2,7,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- e\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2511,1005,'ListItemComment',3,7,NULL,NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: e\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2512,1005,'ListItem',1,9,NULL,NULL,'listitem::::Var der komplikationer under fødslen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2513,1005,'Rating',2,9,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- f\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2514,1005,'ListItemComment',4,9,NULL,NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: f\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2515,1005,'ListItem',1,11,NULL,NULL,'listitem::::Røg moderen tobak under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2516,1005,'Rating',2,11,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- g\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2517,1005,'ListItemComment',3,11,NULL,NULL,'listitem::::Hvis ja, ca. hvor meget?###textbox::::','--- \n:targets: \n- :target: g\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2518,1005,'ListItem',1,13,NULL,NULL,'listitem::::Drak moderen alkohol under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2519,1005,'Rating',2,13,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- h\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2520,1005,'ListItemComment',3,13,NULL,NULL,'listitem::::Hvis ja, ca. hvor meget?###textbox::::','--- \n:targets: \n- :target: h\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2521,1005,'ListItem',1,15,NULL,NULL,'listitem::::Hvornår er barnet født?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2522,1005,'SelectOption',2,15,NULL,NULL,'option::1::Ektremt tidligt født (før 28. svangerskabsuge)###option::2::Meget tidligt født (28. - 32. svangerskabsuge)###radio::3::Moderat tidligt født (33. - 36. svangerskabsuge)###option::4::Til termin (37. - 42. svangerskabsuge)###option::5::Overbåren (efter 42. svangerskabsuge)',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2523,1005,'Questiontext',1,16,NULL,NULL,'questiontext::::Barnets mål og vægt ved fødslen',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2524,1005,'Placeholder',1,17,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2525,1005,'ListItem',2,17,NULL,NULL,'listitem::::længde',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2526,1005,'ListItemComment',3,17,NULL,NULL,'itemunit::::cm',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2527,1005,'Placeholder',1,18,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2528,1005,'ListItem',2,18,NULL,NULL,'listitem::::vægt',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2529,1005,'ListItemComment',3,18,NULL,NULL,'itemunit::::gram',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2530,1005,'ListItem',1,19,NULL,NULL,'listitem::::Har barnet medfødte sygdomme?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2531,1005,'Rating',2,19,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- i\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2532,1005,'ListItemComment',3,19,NULL,NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: i\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1006,10,6,0,4,NULL);
INSERT INTO `question_cells` VALUES (2540,1006,'SectionSubtitle',1,1,NULL,NULL,'sectionsubtitle::::Tidlig barndom:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2541,1006,'ListItem',1,2,NULL,NULL,'listitem::::Var der komplikationer i spædbarnsperioden?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2542,1006,'Rating',2,2,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- j\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2543,1006,'ListItemComment',3,2,NULL,NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: j\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2546,1006,'ListItem',1,3,NULL,NULL,'listitem::::Var der kontakt til sundhedsplejerske?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2547,1006,'Rating',2,3,NULL,NULL,'radio::0::Nej###radio::1::Ja',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2548,1006,'ListItem',1,4,NULL,NULL,'listitem::::Blev barnet ammet?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2549,1006,'Rating',2,4,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- k\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2550,1006,'ListItemComment',3,4,NULL,NULL,'listitem::::Udelukkende amning (ca. antal uger)###listitem::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2551,1006,'Placeholder',1,5,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2552,1006,'Placeholder',2,5,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2553,1006,'ListItemComment',4,4,NULL,NULL,'listitem::::Delvis amning (ca. antal uger)###listitem::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2561,1006,'ListItemComment',1,9,NULL,NULL,'listitem::::Hvordan var kontakten med barnet i spædbarnsperioden (øjenkontakt, smil, pludren, kunne barnet trøstes, brød det sig om kropskontakt m.v.)###textbox::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2562,1006,'Questiontext',1,10,NULL,NULL,'questiontext::::Hvornår kunne barnet:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2563,1006,'Placeholder',1,11,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2564,1006,'ListItem',2,11,NULL,NULL,'listitem::::Sidde',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2565,1006,'ListItemComment',3,11,NULL,NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2566,1006,'Placeholder',1,12,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2567,1006,'ListItem',2,12,NULL,NULL,'listitem::::Kravle',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2568,1006,'ListItemComment',3,12,NULL,NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2569,1006,'Placeholder',1,13,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2570,1006,'ListItem',2,13,NULL,NULL,'listitem::::Gå',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2571,1006,'ListItemComment',3,13,NULL,NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2572,1006,'Placeholder',1,14,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2573,1006,'ListItem',2,14,NULL,NULL,'listitem::::Sige enkelte ord',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2574,1006,'ListItemComment',3,14,NULL,NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2575,1006,'ListItem',1,15,NULL,NULL,'listitem::::Hvornår var barnet renligt?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2576,1006,'ListItemComment',2,15,NULL,NULL,'itemunit::::mdr',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2577,1006,'ListItem',1,24,NULL,NULL,'listitem::::Er barnet vådligger?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2578,1006,'Rating',2,24,NULL,NULL,'radio::0::Nej###radio::1::Ja',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2579,1006,'ListItem',1,25,NULL,NULL,'listitem::::Er der "uheld" om dagen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2580,1006,'Rating',2,25,NULL,NULL,'radio::0::Nej###radio::1::Ja',NULL,1,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1007,10,7,0,3,NULL);
INSERT INTO `question_cells` VALUES (2590,1007,'SectionTitle',1,1,NULL,NULL,'sectiontitle::::Oplysninger vedrørende netværk',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2591,1007,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvem bor i samme husstand som barnet?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2592,1007,'ListItem',2,2,NULL,NULL,'listitem::::Fornavn:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2593,1007,'ListItem',3,2,NULL,NULL,'listitem::::Familieforhold til barnet:\n(ex: mor, far søskende, bonusmor, bonusfor, bonussøskende)',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2594,1007,'Placeholder',1,3,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2595,1007,'ListItemComment',2,3,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2596,1007,'ListItemComment',3,3,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2597,1007,'Placeholder',1,4,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2598,1007,'ListItemComment',2,4,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2599,1007,'ListItemComment',3,4,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2600,1007,'Placeholder',1,5,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2601,1007,'ListItemComment',2,5,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2602,1007,'ListItemComment',3,5,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2603,1007,'Placeholder',1,6,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2604,1007,'ListItemComment',2,6,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2605,1007,'ListItemComment',3,6,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2606,1007,'Placeholder',1,7,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2607,1007,'ListItemComment',2,7,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2608,1007,'ListItemComment',3,7,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2609,1007,'Placeholder',1,8,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2610,1007,'Information',1,7,NULL,NULL,'information::::Ved skilsmisse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2611,1007,'Questiontext',1,8,NULL,NULL,'questiontext::::Hvem bor i den anden forældres husstand?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2612,1007,'ListItem',2,8,NULL,NULL,'listitem::::Fornavn:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2613,1007,'ListItem',3,8,NULL,NULL,'listitem::::Familieforhold til barnet:\n(ex: mor, far søskende, bonusmor, bonusfor, bonussøskende)',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2614,1007,'Placeholder',1,9,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2615,1007,'ListItemComment',2,9,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2616,1007,'ListItemComment',3,9,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2617,1007,'Placeholder',1,10,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2618,1007,'ListItemComment',2,10,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2619,1007,'ListItemComment',3,10,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2620,1007,'Placeholder',1,11,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2621,1007,'ListItemComment',2,11,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2622,1007,'ListItemComment',3,11,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2623,1007,'ListItem',1,12,NULL,NULL,'listitem::::Daginstitution',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2624,1007,'Rating',2,12,NULL,NULL,'radio::1::Nej###radio::0::Ja','--- \n:switch: \n- l\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2625,1007,'ListItemComment',1,13,NULL,NULL,'listitem::::Vuggestue (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2607,7005,'ListItemComment',2,12,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2626,1007,'ListItemComment',1,14,NULL,NULL,'listitem::::Dagpleje  (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2609,7005,'ListItemComment',2,13,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2627,1007,'ListItemComment',1,15,NULL,NULL,'listitem::::Børnehave (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2611,7005,'ListItemComment',2,14,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2628,1007,'ListItem',1,16,NULL,NULL,'listitem::::Skole',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2629,1007,'Rating',2,16,NULL,NULL,'radio::1::Nej###radio::0::Ja','--- \n:switch: \n- m\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2630,1007,'ListItemComment',1,17,NULL,NULL,'listitem::::Barnets skole (navn og adresse)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2614,7005,'ListItemComment',2,12,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2631,1007,'ListItemComment',1,18,NULL,NULL,'listitem::::Klasselærer/kontaktperson###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2616,7005,'ListItemComment',2,13,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2632,1007,'ListItemComment',1,19,NULL,NULL,'listitem::::SFO (navn / adresse / kontaktperson)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2618,7005,'ListItemComment',2,14,NULL,NULL,'listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2633,1007,'ListItemComment',1,20,NULL,NULL,'listitem::::Eventuelle tidligere skoler, barnet har gået på (navn samt adresse og evt. årstal)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2634,1007,'ListItemComment',1,21,NULL,NULL,'listitem::::Evt. midlertidig opholdsadresse for barnet (efterskole, døgninstitution o.lign.):###textbox::::',NULL,1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2621,7005,'TextBox',2,16,NULL,NULL,'###textbox::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2635,1007,'Placeholder',1,22,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2636,1007,'SectionSubtitle',1,23,NULL,NULL,'sectionsubtitle::::PPR - Pædagogisk-Psykologisk-Rådgivning:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2637,1007,'ListItem',1,24,NULL,NULL,'listitem::::Har I / barnet haft kontakt til PPR',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2638,1007,'Rating',2,24,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- n\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2639,1007,'ListItemComment',1,25,NULL,NULL,'listitem::::I hvilken forbindelse (navn og adresse på psykolog:):###textbox::::','--- \n:targets: \n- :target: n\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2640,1007,'SectionSubtitle',1,26,NULL,NULL,'sectionsubtitle::::Socialforvaltning:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2641,1007,'ListItem',1,27,NULL,NULL,'listitem::::Har I / barnet haft kontakt til socialforvaltning',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2642,1007,'Rating',2,27,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- o\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2643,1007,'ListItemComment',1,28,NULL,NULL,'listitem::::I hvilken forbindelse (navn og adresse på sagsbehandler):###textbox::::','--- \n:targets: \n- :target: o\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2645,1007,'SectionSubtitle',1,29,NULL,NULL,'sectionsubtitle::::Fysioterapi/Ergoterapi:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2646,1007,'ListItem',1,30,NULL,NULL,'listitem::1::Er barnet tidligere undersøgt/behandlet af fysioterapeut/ergoterapeut (navn og adresse):',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2647,1007,'Rating',2,30,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- p\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2648,1007,'ListItemComment',1,31,NULL,NULL,'listitem::::I hvilken forbindelse (navn og adresse):###textbox::::','--- \n:targets: \n- :target: p\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2649,1007,'ListItem',1,32,NULL,NULL,'listitem::::Andre:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2650,1007,'Rating',2,32,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- z\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2651,1007,'ListItemComment',1,33,NULL,NULL,'listitem::::I hvilken forbindelse:###textbox::::','--- \n:targets: \n- :target: z\n  :state: offstate\n',1,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1008,10,8,0,4,NULL);
INSERT INTO `question_cells` VALUES (2660,1008,'SectionSubtitle',1,1,NULL,NULL,'placeholder::::Senere barndom:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2661,1008,'ListItem',1,2,NULL,NULL,'listitem::::Har barnet haft fysiske sygdomme / handicaps?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2662,1008,'Rating',2,2,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- q\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2663,1008,'ListItemComment',3,2,NULL,NULL,'listitem::::Hvis ja, beskriv hvilke###textbox::::','--- \n:targets: \n- :target: q\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2664,1008,'ListItem',1,4,NULL,NULL,'listitem::::Har barnet nogensinde været indlagt på sygehus?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2665,1008,'Rating',2,4,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- r\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2666,1008,'ListItemComment',3,4,NULL,NULL,'listitem::::Hvis ja, for hvilke sygdomme og hvor (afdeling/hospital)###textbox::::','--- \n:targets: \n- :target: r\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2670,1008,'ListItem',1,5,NULL,NULL,'listitem::::Er barnet vaccineret efter det almindelige børnevaccinationsprogram?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2671,1008,'Rating',2,5,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- s\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2672,1008,'ListItemComment',3,5,NULL,NULL,'listitem::::Beskriv eventuelle undtagelser###textbox::::','--- \n:targets: \n- :target: s\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2673,1008,'ListItem',1,6,NULL,NULL,'listitem::::Får barnet medicin?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2674,1008,'Rating',2,6,NULL,NULL,'radio::0::Nej###radio::1::Ja','--- \n:switch: \n- t\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2675,1008,'Placeholder',1,7,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2680,1008,'ListItemComment',1,8,NULL,NULL,'listitem::::Hvilken medicin###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2681,1008,'ListItemComment',2,8,NULL,NULL,'listitem::::For hvad?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2682,1008,'ListItemComment',3,8,NULL,NULL,'listitem::::Hvornår?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
-- INSERT INTO `question_cells` VALUES (2683,8006,'Placeholder',1,11,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2684,1008,'ListItemComment',1,9,NULL,NULL,'listitem::::Hvilken medicin?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2685,1008,'ListItemComment',2,9,NULL,NULL,'listitem::::For hvad?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2686,1008,'ListItemComment',3,9,NULL,NULL,'listitem::::Hvornår?###textbox::::','--- \n:targets: \n- :target: t\n  :state: offstate\n',1,NULL,NULL,NULL);

COMMIT;