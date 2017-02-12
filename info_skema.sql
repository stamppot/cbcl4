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