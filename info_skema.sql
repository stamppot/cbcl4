START TRANSACTION;

-- INSERT INTO `surveys` VALUES (10,'Oplysningsskema','INFO','Oplysningsskema (Forældreskema)','1.5-16','parent','4499FF',99,'info','INFO');

INSERT INTO `questions` VALUES (1000,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2400,1000,'Information',1,1,NULL,NULL,'information::::Kære forældre,<p/>Jeres barn er sammen med jer indkaldt til undersøgelse.\nVi vil bede jer om at udfylde oplysningsskemaet forud for jeres første besøg i ambulatoriet.',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2401,1000,'ListItem',1,2,NULL,NULL,'listitem::::Barnets navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2402,1000,'ListItem',2,2,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2403,1000,'ListItem',1,3,NULL,NULL,'listitem::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2404,1000,'ListItem',2,3,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2405,1000,'ListItem',1,4,NULL,NULL,'listitem::::Skemaet er udfyldt d.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2406,1000,'ListItem',2,4,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2407,1000,'ListItem',1,5,NULL,NULL,'listitem::::Af::::subtext::::(navn, familieforhold til barnet)',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2408,1000,'ListItem',2,5,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2410,1000,'Information',1,6,NULL,NULL,'information::::Oplysninger om mor:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2411,1000,'ListItem',1,7,NULL,NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2412,1000,'ListItem',2,7,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2413,1000,'ListItem',1,8,NULL,NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2414,1000,'ListItem',2,8,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2415,1000,'ListItem',1,9,NULL,NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2416,1000,'ListItem',2,9,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2417,1000,'ListItem',1,10,NULL,NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2418,1000,'ListItem',2,10,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2419,1000,'ListItem',1,11,NULL,NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2420,1001,'ListItem',2,11,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2425,1000,'Information',1,12,NULL,NULL,'information::::Oplysninger om far:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2427,1000,'ListItem',1,13,NULL,NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2428,1000,'ListItem',2,13,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2429,1000,'ListItem',1,14,NULL,NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2430,1000,'ListItem',2,14,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2431,1000,'ListItem',1,15,NULL,NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2432,1000,'ListItem',2,15,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2433,1000,'ListItem',1,16,NULL,NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2434,1000,'ListItem',2,16,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2435,1000,'ListItem',1,17,NULL,NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2436,1000,'ListItem',2,17,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2440,1000,'Information',1,18,NULL,NULL,'information::::Oplysninger om evt. stedfar/stedmor:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2441,1000,'ListItem',1,19,NULL,NULL,'listitem::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2442,1000,'ListItem',2,19,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2443,1000,'ListItem',1,20,NULL,NULL,'listitem::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2444,1000,'ListItem',2,20,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2445,1000,'ListItem',1,21,NULL,NULL,'listitem::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2446,1000,'ListItem',2,21,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2447,1000,'ListItem',1,22,NULL,NULL,'listitem::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2448,1000,'ListItem',2,22,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2449,1000,'ListItem',1,23,NULL,NULL,'listitem::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2450,1000,'ListItem',2,23,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2451,1000,'ListItem',1,24,NULL,NULL,'listitem::::Evt barnets/den unges eget tlf.nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2452,1000,'ListItem',2,24,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1001,10,6,0,2,NULL);
INSERT INTO `question_cells` VALUES (2453,1001,'Information',1,1,NULL,NULL,'information::::Hvis forældrene er skilte:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2454,1001,'ListItem',1,2,NULL,NULL,'listitem::::Hvem har forældremyndigheden:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2455,1000,'ListItem',2,2,NULL,NULL,'listitem::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2456,1001,'ListItem',1,3,NULL,NULL,'listitem::::Forhold omkring samvær',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2457,1001,'TextBox',2,3,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2458,1001,'Questiontext',1,4,NULL,NULL,'questiontext::::Kort beskrivelse af det forløb der har medført henvisning til børnepsykiatrisk undersøgelse',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2459,1001,'TextBox',2,4,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1002,10,7,0,2,NULL);
INSERT INTO `question_cells` VALUES (2460,1002,'ListItem',1,1,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2461,1002,'Rating',2,1,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- a\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2462,1002,'Questiontext',2,1,NULL,NULL,'questiontext::::Hvis ja, for hvad?','--- \n:targets: \n- :target: a\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2463,1002,'ListItem',1,2,NULL,NULL,'listitem::1::Er der nogen i barnets familie, som har et alkohol eller stofmisbrug',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2464,1002,'Rating',2,2,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- b\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2465,1002,'Questiontext',2,2,NULL,NULL,'questiontext::::Hvis ja, for hvilket?','--- \n:targets: \n- :target: b\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2466,1002,'ListItem',1,3,NULL,NULL,'listitem::::Er der nogen i barnets familie, som har begået selvmord?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2467,1002,'Rating',2,3,NULL,NULL,'radio::1::Ja###radio::0::Nej',NULL,0,NULL,NULL,NULL);
#INSERT INTO `question_cells` VALUES (2468,1002,'ListItem',1,4,NULL,NULL,'radio::1::###radio::0::Nej',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2469,1002,'TextBox',2,4,NULL,NULL,'textbox::::Er der nogen i familien, der har vanskeligheder, der ligner barnets?',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1003,10,8,0,2,NULL);
INSERT INTO `question_cells` VALUES (2470,1003,'Information',1,1,NULL,NULL,'information::::Syndhedsoplysninger',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2471,1003,'Information',1,2,NULL,NULL,'information::::Graviditet og fødsel:',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2472,1003,'ListItem',1,3,NULL,NULL,'listitem::::Var der sygdom hos barnets mor under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2473,1003,'Rating',2,3,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- c\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2474,1003,'Questiontext',1,4,NULL,NULL,'questiontext::::Hvis ja, beskriv hvilken','--- \n:targets: \n- :target: c\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `question_cells` VALUES (2475,1003,'ListItem',1,5,NULL,NULL,'listitem::::Tog moderen medicin under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2476,1003,'Rating',2,5,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- d\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2477,1003,'Questiontext',1,6,NULL,NULL,'questiontext::::Hvis ja, beskriv hvilken','--- \n:targets: \n- :target: d\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2478,1003,'ListItem',1,7,NULL,NULL,'listitem::::Var der komplikationer i graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2479,1003,'Rating',2,7,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- e\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2480,1003,'Questiontext',1,8,NULL,NULL,'questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: e\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2481,1003,'ListItem',1,9,NULL,NULL,'listitem::::Var der komplikationer under fødslen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2482,1003,'Rating',2,9,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- f\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2483,1003,'Questiontext',1,10,NULL,NULL,'questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: f\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2485,1003,'ListItem',1,11,NULL,NULL,'listitem::::Røg moderen tobak under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2486,1003,'Rating',2,11,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- g\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2487,1003,'Questiontext',1,12,NULL,NULL,'questiontext::::Hvis ja, ca. hvor meget?','--- \n:targets: \n- :target: g\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2488,1003,'ListItem',1,13,NULL,NULL,'listitem::::Drak moderen alkohol under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2489,1003,'Rating',2,13,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- h\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2490,1003,'Questiontext',1,14,NULL,NULL,'questiontext::::Hvis ja, ca. hvor meget?','--- \n:targets: \n- :target: h\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2491,1003,'ListItem',1,15,NULL,NULL,'listitem::::Hvornår er barnet født?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2492,1003,'Rating',2,15,NULL,NULL,'radio::1::Extrem tidligt født (før 28. svangerskabsuge)###radio::2::Meget tidligt født (28. - 32. svangerskabsuge)###radio::3::Moderat tidligt født (33. - 36. svangerskabsuge)###radio::4::Til termin (37. - 42. svangerskabsuge)###radio::5::Overbåren (efter 42. svangerskabsuge)',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2495,1003,'Questiontext',1,16,NULL,NULL,'questiontext::::Barnets mål og vægt ved fødslen',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2496,1003,'Placeholder',1,17,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2497,1003,'ListItem',2,17,NULL,NULL,'listitem::::længde',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2498,1003,'ListItem',3,17,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2499,1003,'Placeholder',1,18,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2500,1003,'ListItem',2,18,NULL,NULL,'listitem::::vægt',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2501,1003,'ListItem',3,18,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2502,1003,'ListItem',1,19,NULL,NULL,'listitem::::Har barnet medfødte sygdomme?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2503,1003,'Rating',2,19,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- i\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2504,1003,'Questiontext',1,20,NULL,NULL,'questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: i\n  :state: offstate\n',0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1004,10,8,0,3,NULL);
INSERT INTO `question_cells` VALUES (2510,1009,'Information',1,1,NULL,NULL,'information::::Tidlig barndom:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2511,1009,'ListItem',1,2,NULL,NULL,'listitem::::Var der komplikationer i spædbarnsperioden?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2512,1009,'Rating',2,2,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- j\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2513,1009,'Questiontext',1,3,NULL,NULL,'questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: j\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2516,1009,'ListItem',1,4,NULL,NULL,'listitem::::Var der kontakt til sundhedsplejerske?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2517,1009,'Rating',2,4,NULL,NULL,'radio::1::Ja###radio::0::Nej',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2520,1009,'ListItem',1,5,NULL,NULL,'listitem::::Blev barnet ammet?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2521,1009,'Rating',2,5,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- k\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2522,1009,'Questiontext',1,6,NULL,NULL,'questiontext::::Hvis ja, hvor længe blev barnet ammet','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2523,1009,'Placeholder',1,7,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2524,1009,'ListItem',2,7,NULL,NULL,'listitem::::udelukkende amning###listitem::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2525,1009,'Placeholder',1,8,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2526,1009,'ListItem',2,8,NULL,NULL,'listitem::::delvis amning###listitem::::','--- \n:targets: \n- :target: k\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2529,1009,'ListItem',1,9,NULL,NULL,'listitem::::Hvordan var kontakten til barnet i spædbarnsperioden (øjenkontakt, smil, pludren, kunne barnet trøstes, brød det sig om kropskontakt m.v.)',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2530,1009,'TextBox',2,9,NULL,NULL,'textbox::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2531,1009,'Questiontext',1,10,NULL,NULL,'questiontext::::Hvornår kunne barnet (mdr):',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2532,1009,'Placeholder',1,11,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2533,1009,'ListItem',2,11,NULL,NULL,'listitem::::Sidde',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2534,1009,'ListItem',3,11,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2535,1009,'Placeholder',1,12,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2536,1009,'ListItem',2,12,NULL,NULL,'listitem::::Kravle',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2537,1009,'ListItem',3,12,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2538,1009,'Placeholder',1,13,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2539,1009,'ListItem',2,13,NULL,NULL,'listitem::::Gå',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2540,1009,'ListItem',3,13,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2541,1009,'Placeholder',1,14,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2542,1009,'ListItem',2,14,NULL,NULL,'listitem::::Sige enkelte ord',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2543,1009,'ListItem',3,14,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2545,1009,'ListItem',1,15,NULL,NULL,'listitem::::Hvornår var barnet renligt?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2546,1009,'ListItem',2,15,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2547,1009,'ListItem',1,24,NULL,NULL,'listitem::::Er barnet vådligger?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2548,1009,'Rating',2,24,NULL,NULL,'radio::1::Ja###radio::0::Nej',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2549,1009,'ListItem',1,25,NULL,NULL,'listitem::::Er der "uheld" om dagen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2550,1009,'ListItem',2,25,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1005,10,9,0,3,NULL);
INSERT INTO `question_cells` VALUES (2552,1005,'Information',1,1,NULL,NULL,'information::::Oplysninger vedrørende netværk',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2553,1005,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvem bor i samme husstand som barnet?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2554,1005,'ListItem',2,2,NULL,NULL,'listitem::::Navn:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2555,1005,'ListItem',3,2,NULL,NULL,'listitem::::Familieforhold til barnet:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2556,1005,'Placeholder',1,3,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2557,1005,'ListItem',2,3,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2558,1005,'ListItem',3,3,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2559,1005,'Placeholder',1,4,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2560,1005,'ListItem',2,4,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2561,1005,'ListItem',3,4,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2562,1005,'Placeholder',1,5,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2563,1005,'ListItem',2,5,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2564,1005,'ListItem',3,5,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2570,1005,'Information',1,6,NULL,NULL,'information::::Ved skilsmisse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2571,1005,'Questiontext',1,7,NULL,NULL,'questiontext::::Hvem bor i den anden forældres husstand?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2575,1005,'Placeholder',1,8,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2576,1005,'ListItem',2,8,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2577,1005,'ListItem',3,8,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2578,1005,'Placeholder',1,9,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2579,1005,'ListItem',2,9,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2580,1005,'ListItem',3,9,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2581,1005,'Placeholder',1,10,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2582,1005,'ListItem',2,10,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2583,1005,'ListItem',3,10,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2590,1005,'Checkbox',1,11,NULL,NULL,'checkbox::1::Daginstitution','--- \n:switch: \n- l\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2591,1005,'ListItem',1,12,NULL,NULL,'listitem::::Vuggestue (navn / adresse / kontaktperson)###listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2592,1005,'ListItem',1,13,NULL,NULL,'listitem::::Dagpleje  (navn / adresse / kontaktperson)###listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2593,1005,'ListItem',1,14,NULL,NULL,'listitem::::Børnehave (navn / adresse / kontaktperson)###listitem::::','--- \n:targets: \n- :target: l\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2595,1005,'Checkbox',1,11,NULL,NULL,'checkbox::1::Skole','--- \n:switch: \n- m\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2596,1005,'ListItem',1,12,NULL,NULL,'listitem::::Barnets skole (navn og adresse)###listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2597,1005,'ListItem',1,13,NULL,NULL,'listitem::::Klasselærer/kontaktperson###listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2598,1005,'ListItem',1,14,NULL,NULL,'listitem::::SFO (navn / adresse / kontaktperson)###listitem::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2599,1005,'TextBox',1,10,NULL,NULL,'listitem::::Eventuelle tidligere skoler, barnet har gået på (navn samt adresse og evt. årstal)###textbox::::','--- \n:targets: \n- :target: m\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2600,1005,'TextBox',1,16,NULL,NULL,'listitem::::Evt. midlertidig opholdsadresse for barnet (efterskole, døgninstitution o.lign.):###textbox::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2601,1005,'Questiontext',1,17,NULL,NULL,'questiontext::::PPR - Pædagogisk-Psykologisk-Rådgivning:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2602,1005,'ListItem',1,18,NULL,NULL,'listitem::::Har I / barnet haft kontakt til PPR','--- \n:switch: \n- n\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2603,1005,'Rating',2,18,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- n\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2604,1005,'TextBox',1,19,NULL,NULL,'listitem::::I hvilken forbindelse (navn og adresse på psykolog:):###textbox::::','--- \n:targets: \n- :target: n\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2610,1005,'Questiontext',1,20,NULL,NULL,'questiontext::::Socialforvaltning:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2611,1005,'ListItem',1,21,NULL,NULL,'listitem::::Har I / barnet haft kontakt til socialforvaltning',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2612,1005,'Rating',2,21,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- o\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2613,1005,'TextBox',1,22,NULL,NULL,'listitem::::I hvilken forbindelse (navn og adresse på sagsbehandler):###textbox::::','--- \n:targets: \n- :target: o\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2615,1005,'Questiontext',1,20,NULL,NULL,'questiontext::::Fysioterapi/Ergoterapi:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2616,1005,'Checkbox',1,21,NULL,NULL,'checkbox::1::Er barnet tidligere undersøgt/behandlet af fysioterapeut/ergoterapeut (navn og adresse):','--- \n:switch: \n- p\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2617,1005,'TextBox',1,22,NULL,NULL,'listitem::::I hvilken forbindelse (navn og adresse):###textbox::::','--- \n:targets: \n- :target: p\n  :state: offstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2621,1005,'TextBox',1,23,NULL,NULL,'listitem::::Andre:###textbox::::',NULL,1,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1006,10,10,0,2,NULL);
INSERT INTO `question_cells` VALUES (2630,1006,'Information',1,1,NULL,NULL,'information::::Senere barndom:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2631,1006,'ListItem',1,2,NULL,NULL,'listitem::::Har barnet haft fysiske sygdomme / handicaps?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2632,1006,'Rating',2,2,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- q\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2633,1006,'Questiontext',1,3,NULL,NULL,'questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: q\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2634,1006,'ListItem',1,4,NULL,NULL,'listitem::::Har barnet nogensinde været indlagt på sygehus?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2635,1006,'Rating',2,4,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- r\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2636,1006,'Questiontext',1,5,NULL,NULL,'questiontext::::Hvis ja, for hvilke sygdomme og hvor (afdeling/hospital)','--- \n:targets: \n- :target: r\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2640,1006,'ListItem',1,6,NULL,NULL,'listitem::::Er barnet vaccineret efter det almindelige børnevaccinationsprogram?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2641,1006,'Rating',2,6,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- s\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2642,1006,'Questiontext',1,7,NULL,NULL,'questiontext::::Beskriv eventuelle undtagelser','--- \n:targets: \n- :target: s\n  :state: offstate\n',0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2645,1006,'ListItem',1,8,NULL,NULL,'listitem::::Får barnet medicin?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2646,1006,'Rating',2,8,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- t\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2647,1006,'ListItem',1,9,NULL,NULL,'listitem::::Hvilken medicin?###listitem::::For hvad?###listitem::::Hvornår?','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2648,1006,'ListItem',1,9,NULL,NULL,'listitem::::Hvilken medicin?###listitem::::For hvad?###listitem::::Hvornår?','--- \n:targets: \n- :target: t\n  :state: offstate\n',0,NULL,NULL,NULL);


COMMIT;