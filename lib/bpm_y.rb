# encoding: utf-8

class BpmY

# y = Survey.new({:title => "BMP-P 6-16 selvrapportskema", :description => "BPM-Y ages 11-6 Unges selvrapport", :category => "BMP", :age => "11-16", :surveytype => "youth", :prefix => "bpm-y"})
# y.save

def create
# y = Survey.find 7
y = Survey.new({:title => "BPM-P 6-16 selvrapportskema", :description => "BPM-Y ages 11-6 Unges selvrapport", :category => "BMP", :age => "11-16", :surveytype => "youth", :prefix => "bpm-y"})
y.save

q1 = Question.new({:number => 1, :ratings_count => 1, :columns => 3, :survey => y})
q1.save

q1_cells = [
Questiontext.new({:question => q1, :col => 1, :row => 1, :answer_item => "", :items => "questiontext::::Går i skole?", :preferences => {:targets => [{:state => "onstate", :target => "e"}]}, :prop_mask => 2}),
Rating.new({:question => q1, :col => 2, :row => 1, :answer_item => "", :items => "radio::0::Nej###radio::1::Ja", :preferences => {:targets => [{:state => "onstate", :target => "e"}]}, :prop_mask => 3}),
SelectOption.new({:question => q1, :col => 3, :row => 1, :answer_item => "", :items => "listitem::::Hvis ja, hvilket klassetrin?###option::0::0. klasse###option::1::1. klasse###option::2::2. klasse###option::3::3. klasse###option::4::4. klasse###option::5::5. klasse###option::6::6. klasse###option::7::7. klasse###option::8::8. klasse###option::9::9. klasse###option::10::10. klasse###option::99::Andet", :preferences => {:targets => [{:state => "onstate", :target => "e"}]}, :prop_mask => 1})
]
q1_cells.each &:save


q2 = Question.new({:number => 1, :ratings_count => 18, :columns => 3, :survey => y})
q2.save

q2_cells = [
Information.new({:question => q2, :col => 1, :row => 1, :answer_item => nil, :items => "information::::Her er en liste over egenskaber, som kan være til stede i større eller mindre grad. Markér for hver egenskab, hvorledes den passer på dig nu eller de 
sidste ______dage. Sæt en ring rundt om 2, hvis beskrivelsen passer godt eller ofte. Sæt ring rundt om 1, hvis beskrivelsen passer til en vis grad eller nogen gange. Hvis beskrivelsen ikke passer på barnet, sæt ring om 0. Svar venligst så godt du kan på alle spørgsmålene. ", :preferences => "", :prop_mask => 0}),
ListItem.new({:question => q2, :col => 1, :row => 2, :answer_item => nil, :items => "listitem::::Dage", :preferences => "", :prop_mask => 0}),
TextBox.new({:question => q2, :col => 2, :row => 2, :answer_item => nil, :items => "textbox::::", :preferences => "", :prop_mask => 0}),
Information.new({:question => q2, :col => 1, :row => 3, :answer_item => nil, :items => "information::::0 = Passer ikke &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 = Passer til en vis grad eller nogen gange &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 = Passer godt eller ofte", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 4, :answer_item => "1", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 4, :answer_item => "1", :items => "listitem::::Jeg opfører mig som yngre end jeg er", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 5, :answer_item => "2", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 5, :answer_item => "2", :items => "listitem::::Jeg diskuterer meget", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 6, :answer_item => "3", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 6, :answer_item => "3", :items => "listitem::::Jeg bliver ikke færdig med de ting, som jeg begynder på", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 7, :answer_item => "4", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 7, :answer_item => "4", :items => "listitem::::Jeg kan ikke koncentrere mig, eller være opmærksom i længere tid", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 8, :answer_item => "5", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 8, :answer_item => "5", :items => "listitem::::Jeg kan ikke sidde stille", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 9, :answer_item => "6", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 9, :answer_item => "6", :items => "listitem::::Jeg ødelægger ting der tilhører andre", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 10, :answer_item => "7", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 10, :answer_item => "7", :items => "listitem::::Jeg retter mig ikke efter mine forældre", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 11, :answer_item => "8", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 11, :answer_item => "8", :items => "listitem::::Jeg retter mig ikke efter mine lærere", :preferences => "",	:prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 12, :answer_item => "9", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 12, :answer_item => "9", :items => "listitem::::Jeg føler mig værdiløs eller underlegen", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 13, :answer_item => "10", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 13, :answer_item => "10", :items => "listitem::::Jeg handler uden at tænke", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 14, :answer_item => "11", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 14, :answer_item => "11", :items => "listitem::::Jeg er bange eller ængstelig", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 15, :answer_item => "12", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 15, :answer_item => "12", :items => "listitem::::Jeg har for stærk skyldfølelse", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 16, :answer_item => "13", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 16, :answer_item => "13", :items => "listitem::::Jeg bliver let flov eller forlegen", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 17, :answer_item => "14", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 17, :answer_item => "14", :items => "listitem::::Jeg er uopmærksom eller afledes let", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 18, :answer_item => "15", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 18, :answer_item => "15", :items => "listitem::::Jeg er stædig", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 19, :answer_item => "16", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 19, :answer_item => "16", :items => "listitem::::Jeg har et voldsomt temperament", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 20, :answer_item => "17", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 20, :answer_item => "17", :items => "listitem::::Jeg truer andre med at skade dem", :preferences => "",	:prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 21, :answer_item => "18", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 21, :answer_item => "18", :items => "listitem::::Jeg er ulykkelig, trist eller deprimeret", :preferences => "",	:prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 22, :answer_item => "19", :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 22, :answer_item => "19", :items => "listitem::::Jeg er meget bekymret", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 23, :answer_item => nil, :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 23, :answer_item => nil, :items => "listitem::::Yderligere spørgsmål###textbox::::", :preferences => "", :prop_mask => 0}),
Rating.new({:question => q2, :col => 1, :row => 24, :answer_item => nil, :items => "radio::0::0###radio::1::1###radio::2::2", :preferences => { :required => true}, :prop_mask => 1}),
ListItem.new({:question => q2, :col => 2, :row => 24, :answer_item => nil, :items => "listitem::::Yderligere spørgsmål###textbox::::", :preferences => "", :prop_mask => 0})
]

q2_cells.each &:save
end

def remove_cells(id)
	y = Survey.find id
	y.questions.map {|q| q.question_cells.each &:destroy }
end
end