# encoding: utf-8

class BpmP

def create
p = Survey.new({:title => "BPM-P 6-16 forældreskema", :category => "BPM", :age => "6-16", :surveytype => "parent", :prefix => "bpm-p"})
p.save

q1 = Question.new({:number => 1, :ratings_count => 1, :columns => 3, :survey => p})
q1.save

q1_cells = [
Questiontext.new({:question => q1, :col => 1, :row => 1, :answer_item => "", :items => "questiontext::::Går i skole?", :preferences => {:targets => [{:state => "onstate", :target => "e"}]}, :prop_mask => 2}),
Rating.new({:question => q1, :col => 2, :row => 1, :answer_item => "", :items => "radio::0::Nej###radio::1::Ja", :preferences => {:targets => [{:state => "onstate", :target => "e"}]}, :prop_mask => 3}),
SelectOption.new({:question => q1, :col => 3, :row => 1, :answer_item => "", :items => "listitem::::Hvis ja, hvilket klassetrin?###option::0::0. klasse###option::1::1. klasse###option::2::2. klasse###option::3::3. klasse###option::4::4. klasse###option::5::5. klasse###option::6::6. klasse###option::7::7. klasse###option::8::8. klasse###option::9::9. klasse###option::10::10. klasse###option::99::Andet", :preferences => {:targets => [{:state => "onstate", :target => "e"}]}, :prop_mask => 1})
]
q1_cells.each &:save


q2 = Question.new({:number => 1, :ratings_count => 18, :columns => 3, :survey => p})
q2.save

q2_cells = [
Information.new({:question => q2, :col => 1, :row => 1, :answer_item => nil, :items => "information::::Her er en liste over egenskaber, som kan være til stede i større eller mindre grad. Markér for hver egenskab, hvorledes det passer på din søn/datter nu eller de sidste 7 dage (hvis andet ikke er aftalt). Marker 2, hvis beskrivelsen passer godt eller ofte. Marker 1, hvis beskrivelsen passer til en vis grad eller nogen gange. Hvis beskrivelsen ikke passer på barnet, mar 0. Svar venligst så godt du kan på alle spørgsmålene. ", :preferences => "", :prop_mask => 0}),
ListItem.new({:question => q2, :col => 1, :row => 2, :answer_item => nil, :items => "listitem::::Hvis aftalt andet end 7 dage, angiv hvor mange dage, det passer på din søn/datter", :preferences => "", :prop_mask => 0}),
TextBox.new({:question => q2, :col => 2, :row => 2, :answer_item => nil, :items => "textbox::::", :preferences => "", :prop_mask => 0}),
Information.new({:question => q2, :col => 1, :row => 3, :answer_item => nil, :items => "information::::0 = Passer ikke &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 = Passer til en vis grad eller nogen gange &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 = Passer godt eller ofte", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 4, :answer_item => "1", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 4, :answer_item => "1", :items => "listitem::::Opfører sig som yngre end han/hun er", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 5, :answer_item => "2", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 5, :answer_item => "2", :items => "listitem::::Diskuterer meget", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 6, :answer_item => "3", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 6, :answer_item => "3", :items => "listitem::::Bliver ikke færdig med de ting som han/hun begynder på", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 7, :answer_item => "4", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 7, :answer_item => "4", :items => "listitem::::Kan ikke koncentrere sig, kan ikke være opmærksom i længere tid", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 8, :answer_item => "5", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 8, :answer_item => "5", :items => "listitem::::Kan ikke sidde stille, rastløs eller hyperaktiv", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 9, :answer_item => "6", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 9, :answer_item => "6", :items => "listitem::::Ødelægger ting der tilhører familier eller andre", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 10, :answer_item => "7", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 10, :answer_item => "7", :items => "listitem::::Ulydig hjemme", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 11, :answer_item => "8", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 11, :answer_item => "8", :items => "listitem::::Ulydig i skolen", :preferences => "",	:prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 12, :answer_item => "9", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 12, :answer_item => "9", :items => "listitem::::Føler sig værdiløs eller underlegen", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 13, :answer_item => "10", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 13, :answer_item => "10", :items => "listitem::::Impulsiv eller handler uden at tænke", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 14, :answer_item => "11", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 14, :answer_item => "11", :items => "listitem::::For bange eller ængstelig", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 15, :answer_item => "12", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 15, :answer_item => "12", :items => "listitem::::Har for stærk skyldfølelse", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 16, :answer_item => "13", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 16, :answer_item => "13", :items => "listitem::::Bliver let flov eller forlegen", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 17, :answer_item => "14", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 17, :answer_item => "14", :items => "listitem::::Uopmærksom eller afledes let", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 18, :answer_item => "15", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 18, :answer_item => "15", :items => "listitem::::Stædig, mut eller irritabel", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 19, :answer_item => "16", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 19, :answer_item => "16", :items => "listitem::::Anfald af arrigskab eller vrede", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 20, :answer_item => "17", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 20, :answer_item => "17", :items => "listitem::::Truer folk", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 21, :answer_item => "18", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 21, :answer_item => "18", :items => "listitem::::Ulykkelig, trist eller deprimeret", :preferences => "",	:prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 22, :answer_item => "19", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 22, :answer_item => "19", :items => "listitem::::Bekymrer sig", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 23, :answer_item => nil, :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 23, :answer_item => nil, :items => "listitem::::Yderligere spørgsmål###textbox::::", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 24, :answer_item => nil, :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 24, :answer_item => nil, :items => "listitem::::Yderligere spørgsmål###textbox::::", :preferences => "", :prop_mask => 0})
]

q2_cells.each &:save
end

def remove_cells(id)
	t = Survey.find id
	t.questions.map {|q| q.question_cells.each &:destroy }
end
end