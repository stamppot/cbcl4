# encoding: utf-8


t = Survey.new {:title => "BMP-T 6-16 lærerskema", :category => "BMP", :age => "6-16", :surveytype => "teacher", :prefix => "bpm-t"}

q = new Question {:number => 1, :ratings_count => 18, :columns => 3, :survey => t}

cells = [
{:question => q, :col => 1, :row => 1, :answer_item => :null, :items => "information::::Her er en liste over egenskaber, som kan være til stede i større eller mindre grad. Markér for hver egenskab, hvorledes den passer på eleven nu eller de 
sidste  _______ dage. Sæt en ring rundt om 2, hvis beskrivelsen passer godt eller ofte. Sæt ring rung om 1, hvis beskrivelsen passer til en vis grad eller nogen gange. Hvis beskrivelsen ikke passer på barnet, sæt ring om 0. Svar venligst så godt du kan på alle spørgsmålene. ", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 2, :answer_item => null, :items => "questiontext::::Dage", :preferences => "", :prop_mask => 0},
{:question => q, :col => 2, :row => 2, :answer_item => null, :items => "textbox::::", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 3, :answer_item => null, :items => "information::::0 = Passer ikke \\u0026nbsp; 1 = Passer til en vis grad eller nogen gange \\u0026nbsp; 2 = Passer godt eller ofte", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 4, :answer_item => "1", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 4, :answer_item => "1", :items => "listitem::::Opfører sig som yngre end han/hun er", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 5, :answer_item => "2", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 5, :answer_item => "2", :items => "listitem::::Diskuterer meget", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 6, :answer_item => "3", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 6, :answer_item => "3", :items => "listitem::::Bliver ikke færdig med de ting som han/hun begynder på", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 7, :answer_item => "4", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 7, :answer_item => "4", :items => "listitem::::Kan ikke koncentrere sig, kan ikke være opmærksom i længere tid", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 8, :answer_item => "5", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 8, :answer_item => "5", :items => "listitem::::Kan ikke sidde stille, rastløs eller hyperaktiv", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 9, :answer_item => "6", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 9, :answer_item => "6", :items => "listitem::::Ødelægger ting der tilhører andre", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 10, :answer_item => "7", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 10, :answer_item => "7", :items => "listitem::::Ulydig i skolen", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 11, :answer_item => "8", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 11, :answer_item => "8", :items => "listitem::::Føler sig værdiløs eller underlegen", :preferences => "",	:prop_mask => 0},
{:question => q, :col => 1, :row => 12, :answer_item => "9", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 12, :answer_item => "9", :items => "listitem::::Impulsiv eller handler uden at tænke", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 13, :answer_item => "10", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 13, :answer_item => "10", :items => "listitem::::For bange eller ængstelig", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 14, :answer_item => "11", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 14, :answer_item => "11", :items => "listitem::::Har for stærk skyldfølelse", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 15, :answer_item => "12", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 15, :answer_item => "12", :items => "listitem::::Bliver let flov eller forlegen", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 16, :answer_item => "13", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 16, :answer_item => "13", :items => "listitem::::Uopmærksom eller afledes let", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 17, :answer_item => "14", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 17, :answer_item => "14", :items => "listitem::::Stædig, mut eller irritabel", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 18, :answer_item => "15", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 18, :answer_item => "15", :items => "listitem::::Anfald af arrigskab eller vrede", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 19, :answer_item => "16", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 19, :answer_item => "16", :items => "listitem::::Truer folk", :preferences => "",	:prop_mask => 0},
{:question => q, :col => 1, :row => 20, :answer_item => "17", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 20, :answer_item => "17", :items => "listitem::::Ulykkelig, trist eller deprimeret", :preferences => "",	:prop_mask => 0},
{:question => q, :col => 1, :row => 21, :answer_item => "18", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 21, :answer_item => "18", :items => "listitem::::Bekymrer sig", :preferences => "", :prop_mask => 0},
{:question => q, :col => 1, :row => 22, :answer_item => null, :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1},
{:question => q, :col => 2, :row => 22, :answer_item => null, :items => "listitem::::Yderligere spørgsmål ", :preferences => "",	:prop_mask => 0},
{:question => q, :col => 1, :row => 23, :answer_item => null, :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}
{:question => q, :col => 2, :row => 23, :answer_item => null, :items => "listitem::::Yderligere spørgsmål", :preferences => "",	:prop_mask => 0}
]
