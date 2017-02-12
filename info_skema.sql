INSERT INTO `surveys` VALUES (10,'Oplysningsskema','INFO','Oplysningsskema (Forældreskema)','1.5-16','parent','4499FF',99,'info','INFO');

INSERT INTO `questions` VALUES (1500,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2400,1500,'Information',1,1,NULL,NULL,'information::::Kære forældre,\n\nJeres barn er sammen med jer indkaldt til undersøgelse.\nVi vil bede jer om at udfylde oplysningsskemaet forud for jeres første besøg i ambulatoriet.',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2401,1500,'Questiontext',1,2,NULL,NULL,'questiontext::::Barnets navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2402,1500,'Questiontext',1,3,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2403,1500,'Questiontext',1,4,NULL,NULL,'questiontext::::Skemaet er udfyldt d.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2404,1500,'Questiontext',1,5,NULL,NULL,'questiontext::::Af::::subtext::::(navn, familieforhold til barnet)',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1501,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2405,1501,'Information',1,1,NULL,NULL,'information::::Oplysninger om mor:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2406,1501,'Questiontext',1,2,NULL,NULL,'questiontext::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2407,1501,'Questiontext',1,3,NULL,NULL,'questiontext::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2408,1501,'Questiontext',1,4,NULL,NULL,'questiontext::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2409,1501,'Questiontext',1,5,NULL,NULL,'questiontext::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2410,1501,'Questiontext',1,6,NULL,NULL,'questiontext::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1502,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2411,1502,'Information',1,1,NULL,NULL,'information::::Oplysninger om far:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2412,1502,'Questiontext',1,2,NULL,NULL,'questiontext::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2413,1502,'Questiontext',1,3,NULL,NULL,'questiontext::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2414,1502,'Questiontext',1,4,NULL,NULL,'questiontext::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2415,1502,'Questiontext',1,5,NULL,NULL,'questiontext::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2416,1502,'Questiontext',1,6,NULL,NULL,'questiontext::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1503,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2430,1503,'Information',1,1,NULL,NULL,'information::::Oplysninger om evt. stedfar/stedmor:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2431,1503,'Questiontext',1,2,NULL,NULL,'questiontext::::Navn:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2432,1503,'Questiontext',1,3,NULL,NULL,'questiontext::::Alder:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2433,1503,'Questiontext',1,4,NULL,NULL,'questiontext::::Adresse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2434,1503,'Questiontext',1,5,NULL,NULL,'questiontext::::Telefonnr./mobilnr:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2435,1503,'Questiontext',1,6,NULL,NULL,'questiontext::::Nuværende beskæftigelse:',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1504,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2440,1504,'Questiontext',1,1,NULL,NULL,'questiontext::::Evt barnets/den unges eget tlf.nr.:',NULL,0,NULL,NULL,NULL);

INSERT INTO `questions` VALUES (1505,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2445,1505,'Information',1,1,NULL,NULL,'information::::Hvis forældrene er skilte:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2446,1505,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvem har forældremyndigheden:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2447,1505,'Questiontext',1,3,NULL,NULL,'questiontext::::Forhold omkring samvær',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2447,1505,'TextBox',2,3,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2448,1505,'Questiontext',1,4,NULL,NULL,'questiontext::::Kort beskrivelse af det forløb der har medført henvisning til børnepsykiatrisk undersøgelse',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2449,1505,'TextBox',2,4,NULL,NULL,'textbox::::',NULL,0,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1506,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2450,1506,'Checkbox',1,1,NULL,NULL,'checkbox::1::Er barnet allergisk over for noget','--- \n:switch: \n- a\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2451,1506,'Questiontext',2,1,NULL,'','questiontext::::Hvis ja, for hvad?','--- \n:targets: \n- :target: a\n  :state: onstate\n',0,NULL,NULL,NULL)
INSERT INTO `question_cells` VALUES (2452,1506,'Checkbox',1,2,NULL,NULL,'checkbox::1::Er der nogen i barnets familie, som har et alkohol eller stofmisbrug','--- \n:switch: \n- b\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2453,1506,'Questiontext',2,2,NULL,'','questiontext::::Hvis ja, for hvilket?','--- \n:targets: \n- :target: b\n  :state: onstate\n',0,NULL,NULL,NULL)
INSERT INTO `question_cells` VALUES (2454,1506,'Checkbox',1,3,NULL,NULL,'checkbox::1::Er der nogen i barnets familie, som har begået selvmord?',NULL,0,NULL,NULL,NULL);
#INSERT INTO `question_cells` VALUES (2450,1506,'Checkbox',1,4,NULL,NULL,'checkbox::0::Er barnet allergisk over for noget','--- \n:switch: \n- a\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2456,1506,'TextBox',2,4,NULL,'','textbox::::Er der nogen i familien, der har vanskeligheder, der ligner barnets?',NULL,0,NULL,NULL,NULL)


INSERT INTO `questions` VALUES (1507,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2460,1507,'Information',1,1,NULL,NULL,'information::::Syndhedsoplysninger',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2461,1507,'Information',1,2,NULL,NULL,'information::::Graviditet og fødsel:',NULL,0,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2462,1507,'ListItem',1,3,NULL,NULL,'listitem::::Var der sygdom hos barnets mor under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2463,1507,'Rating',2,3,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- c\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2464,1507,'Questiontext',1,4,NULL,'','questiontext::::Hvis ja, beskriv hvilken','--- \n:targets: \n- :target: c\n  :state: onstate\n',0,NULL,NULL,NULL)


INSERT INTO `question_cells` VALUES (2465,1507,'ListItem',1,5,NULL,NULL,'listitem::::Tog moderen medicin under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2466,1507,'Rating',2,5,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- d\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2467,1507,'Questiontext',1,6,NULL,'','questiontext::::Hvis ja, beskriv hvilken','--- \n:targets: \n- :target: d\n  :state: onstate\n',0,NULL,NULL,NULL)

INSERT INTO `question_cells` VALUES (2468,1507,'ListItem',1,7,NULL,NULL,'listitem::::Var der komplikationer i graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2469,1507,'Rating',2,7,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- e\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2470,1507,'Questiontext',1,8,NULL,'','questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: e\n  :state: onstate\n',0,NULL,NULL,NULL)

INSERT INTO `question_cells` VALUES (2471,1507,'ListItem',1,9,NULL,NULL,'listitem::::Var der komplikationer under fødslen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2472,1507,'Rating',2,9,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- f\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2473,1507,'Questiontext',1,10,NULL,'','questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: f\n  :state: onstate\n',0,NULL,NULL,NULL)

INSERT INTO `question_cells` VALUES (2475,1507,'ListItem',1,11,NULL,NULL,'listitem::::Røg moderen tobak under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2476,1507,'Rating',2,11,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- g\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2477,1507,'Questiontext',1,12,NULL,'','questiontext::::Hvis ja, ca. hvor meget?','--- \n:targets: \n- :target: g\n  :state: onstate\n',0,NULL,NULL,NULL)

INSERT INTO `question_cells` VALUES (2478,1507,'ListItem',1,13,NULL,NULL,'listitem::::Drak moderen alkohol under graviditeten?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2479,1507,'Rating',2,13,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- h\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2480,1507,'Questiontext',1,14,NULL,'','questiontext::::Hvis ja, ca. hvor meget?','--- \n:targets: \n- :target: h\n  :state: onstate\n',0,NULL,NULL,NULL)

INSERT INTO `question_cells` VALUES (2481,1507,'ListItem',1,15,NULL,NULL,'listitem::::Hvornår er barnet født?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2482,1507,'Rating',2,15,NULL,NULL,'radio::1::Extrem tidligt født (før 28. svangerskabsuge)###radio::2::Meget tidligt født (28. - 32. svangerskabsuge)###radio::3::Moderat tidligt født (33. - 36. svangerskabsuge)###radio::4::Til termin (37. - 42. svangerskabsuge)###radio::5::Overbåren (efter 42. svangerskabsuge)',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2485,1507,'Questiontext',1,14,NULL,NULL,'questiontext::::Barnets mål og vægt ved fødslen',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2486,1507,'Placeholder',1,15,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2487,1507,'ListItem',2,15,NULL,NULL,'listitem::::længde###listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2488,1507,'Placeholder',1,16,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2489,1507,'ListItem',2,16,NULL,NULL,'listitem::::vægt###listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2490,1507,'ListItem',1,13,NULL,NULL,'listitem::::Har barnet medfødte sygdomme?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2491,1507,'Rating',2,13,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- i\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2492,1507,'Questiontext',1,14,NULL,'','questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: i\n  :state: onstate\n',0,NULL,NULL,NULL)


INSERT INTO `questions` VALUES (1508,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2500,1508,'Information',1,1,NULL,NULL,'information::::Tidlig barndom:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2501,1508,'ListItem',1,2,NULL,NULL,'listitem::::Var der komplikationer i spædbarnsperioden?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2502,1508,'Rating',2,2,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- j\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2502,1508,'Questiontext',1,3,NULL,'','questiontext::::Hvis ja, beskriv hvilke','--- \n:targets: \n- :target: j\n  :state: onstate\n',0,NULL,NULL,NULL)

INSERT INTO `question_cells` VALUES (2506,1508,'ListItem',1,4,NULL,NULL,'listitem::::Var der kontakt til sundhedsplejerske?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2507,1508,'Rating',2,4,NULL,NULL,'radio::1::Ja###radio::0::Nej',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2510,1508,'ListItem',1,5,NULL,NULL,'listitem::::Blev barnet ammet?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2511,1508,'Rating',2,5,NULL,NULL,'radio::1::Ja###radio::0::Nej','--- \n:switch: \n- k\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2512,1508,'Questiontext',1,14,NULL,NULL,'questiontext::::Hvis ja, hvor længe blev barnet ammet','--- \n:targets: \n- :target: k\n  :state: onstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2513,1508,'Placeholder',1,15,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: onstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2514,1508,'ListItem',2,15,NULL,NULL,'listitem::::udelukkende amning###listitem::::','--- \n:targets: \n- :target: k\n  :state: onstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2515,1508,'Placeholder',1,16,NULL,NULL,'placeholder::::','--- \n:targets: \n- :target: k\n  :state: onstate\n',1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2516,1508,'ListItem',2,16,NULL,NULL,'listitem::::delvis amning###listitem::::','--- \n:targets: \n- :target: k\n  :state: onstate\n',1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2520,1508,'TextBox',1,17,NULL,NULL,'listitem::::Hvordan var kontakten til barnet i spædbarnsperioden (øjenkontakt, smil, pludren, kunne barnet trøstes, brød det sig om kropskontakt m.v.)###textbox::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2525,1508,'Questiontext',1,18,NULL,NULL,'questiontext::::Hvornår kunne barnet (mdr):',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2526,1508,'Placeholder',1,19,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2527,1508,'ListItem',2,19,NULL,NULL,'listitem::::Sidde###listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2528,1508,'Placeholder',1,20,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2529,1508,'ListItem',2,20,NULL,NULL,'listitem::::Kravle###listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2530,1508,'Placeholder',1,21,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2531,1508,'ListItem',2,21,NULL,NULL,'listitem::::Gå###listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2532,1508,'Placeholder',1,22,NULL,NULL,'placeholder::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2533,1508,'ListItem',2,22,NULL,NULL,'listitem::::Sige enkelte ord###listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2535,1508,'ListItem',1,23,NULL,NULL,'listitem::::Hvornår var barnet renligt?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2536,1508,'ListItem',2,23,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2537,1508,'ListItem',1,24,NULL,NULL,'listitem::::Er barnet vådligger?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2538,1508,'Rating',2,24,NULL,NULL,'radio::1::Ja###radio::0::Nej',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2540,1508,'ListItem',1,25,NULL,NULL,'listitem::::Er der "uheld" om dagen?',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2541,1508,'ListItem',2,25,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);


INSERT INTO `questions` VALUES (1509,10,1,0,1,NULL);
INSERT INTO `question_cells` VALUES (2550,1509,'Information',1,1,NULL,NULL,'information::::Oplysninger vedrørende netværk',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2551,1509,'Questiontext',1,2,NULL,NULL,'questiontext::::Hvem bor i samme husstand som barnet?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2552,1509,'ListItem',2,2,NULL,NULL,'listitem::::Navn:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2554,1509,'ListItem',3,2,NULL,NULL,'listitem::::Familieforhold til barnet:',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2555,1509,'Placeholder',1,3,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2556,1509,'ListItem',2,3,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2557,1509,'ListItem',3,3,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2558,1509,'Placeholder',1,4,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2559,1509,'ListItem',2,4,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2560,1509,'ListItem',3,4,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2561,1509,'Placeholder',1,5,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2562,1509,'ListItem',2,5,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2563,1509,'ListItem',3,5,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);

INSERT INTO `question_cells` VALUES (2570,1509,'Information',1,6,NULL,NULL,'information::::Ved skilsmisse:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2571,1509,'Questiontext',1,7,NULL,NULL,'questiontext::::Hvem bor i den anden forældres husstand?',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2575,1509,'Placeholder',1,8,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2576,1509,'ListItem',2,8,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2577,1509,'ListItem',3,8,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2578,1509,'Placeholder',1,9,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2579,1509,'ListItem',2,9,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2580,1509,'ListItem',3,9,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2581,1509,'Placeholder',1,10,NULL,NULL,'placeholder::::',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2582,1509,'ListItem',2,10,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2583,1509,'ListItem',3,10,NULL,NULL,'listitem::::',NULL,1,NULL,NULL,NULL);


INSERT INTO `question_cells` VALUES (2450,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2451,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2452,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2453,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2454,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2455,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2456,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2457,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2458,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);
INSERT INTO `question_cells` VALUES (2459,1501,'Questiontext',1,1,NULL,NULL,'questiontext::::Barnets CPR-nr.:',NULL,0,NULL,NULL,NULL);