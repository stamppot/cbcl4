class AddAsqSurvey < ActiveRecord::Migration
  def self.up

    survey = Survey.new ({ id: 9, title: "ASQ:SE", category: "ASQ", description: "", age: "4.5-6.5", surveytype: "parent", position: 99, prefix: "asq-se"})
    question = Question.new ({ survey: survey, number: 1, ratings_count: 33, columns: 3})

    question.question_cells <<   (QuestionCell.new({ type: "Placeholder", col: 1, row: 1, items: "desc::::", span: 6, prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Description", col: 2, row: 1, items: "desc::::Det meste af tiden###desc::::Nogle gange###desc::::Sjældent eller aldrig", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Description", col: 3, row: 1, items: "desc::::Det bekymrer mig", prop_mask: 0, prespan: 1 }))
    
    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 2, answer_item: 1, items: "listitem::::Ser dit barn på dig, når du taler til hende/ham?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 2, answer_item: 1, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 2, answer_item: 1, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 3, answer_item: 2, items: "listitem::::Klynger dit barn sig til dig, mere end du forventer?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 3, answer_item: 2, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 3, answer_item: 2, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 4, answer_item: 3, items: "listitem::::Kan dit barn lide at blive krammet eller nusset?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 4, answer_item: 3, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 4, answer_item: 3, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 5, answer_item: 4, items: "listitem::::Taler og/eller leger dit barn med voksne, som hun/han kender godt?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 5, answer_item: 4, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 5, answer_item: 4, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 6, answer_item: 5, items: "listitem::::Når dit barn er uroligt eller ked af det kan hun/han så falde til ro inden for 15 minutter?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 6, answer_item: 5, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 6, answer_item: 5, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 7, answer_item: 6, items: "listitem::::Kan dit barn virke for åben og/eller imødekommende overfor fremmede?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 7, answer_item: 6, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 7, answer_item: 6, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 8, answer_item: 7, items: "listitem::::Kan dit barn berolige sig selv efter perioder med spændende aktiviteter?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 8, answer_item: 7, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 8, answer_item: 7, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 9, answer_item: 8, items: "listitem::::Virker dit barn til at være glad?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 9, answer_item: 8, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 9, answer_item: 8, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 10, answer_item: 9, items: "listitem::::Græder, skriger eller får dit barn raserianfald i længere tid af gangen?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 10, answer_item: 9, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 10, answer_item: 9, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 11, answer_item: 10, items: "listitem::::Er dit barn interesseret i ting omkring sig, som f.eks. andre mennesker, legetøj og mad?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 11, answer_item: 10, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 11, answer_item: 10, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 12, answer_item: 11, items: "listitem::::Går dit barn selv på wc? (Påmindelser om det og hjælp med at tørre sig er okay)", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 12, answer_item: 11, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 12, answer_item: 11, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItemComment", col: 1, row: 13, answer_item: 12, items: "listitem::::Har dit barn problemer med spisning, som f.eks. at proppe sig, kaste op, spise ting, der ikke er mad eller (Du kan her skrive hvis der er et andet problem)###textbox::::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 13, answer_item: 12, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 13, answer_item: 12, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 14, answer_item: 13, items: "listitem::::Kan dit barn fastholde aktiviteter, som hun/han kan lide at gøre i mindst 15 minutter (dette inkluderer ikke TV)", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 14, answer_item: 13, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 14, answer_item: 13, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 15, answer_item: 14, items: "listitem::::Nyder du og dit barn at spise sammen?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 15, answer_item: 14, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 15, answer_item: 14, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 16, answer_item: 15, items: "listitem::::Gør dit barn, hvad du beder hende/ham om at gøre?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 16, answer_item: 15, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 16, answer_item: 15, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 17, answer_item: 16, items: "listitem::::Virker dit barn til at være mere aktiv end andre børn på hendes/hans alder?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 17, answer_item: 16, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 17, answer_item: 16, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 18, answer_item: 17, items: "listitem::::Sover dit barn mindst 8 timer i løbet af et døgn?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 18, answer_item: 17, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 18, answer_item: 17, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 19, answer_item: 18, items: "listitem::::Bruger dit barn ord til at fortælle dig, hvad hun/han gerne vil eller har brug for?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 19, answer_item: 18, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 19, answer_item: 18, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 20, answer_item: 19, items: "listitem::::Bruger dit barn ord til at beskrive sine følelser og andres følelser så som: ”Jeg er glad”, ”jeg kan ikke lide det” eller ”hun er ked af det”?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 20, answer_item: 19, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 20, answer_item: 19, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 21, answer_item: 20, items: "listitem::::Skifter dit barn mellem aktiviteter uden de store problemer, som f.eks. skift fra legetid til spisetid?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 21, answer_item: 20, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 21, answer_item: 20, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 22, answer_item: 21, items: "listitem::::Udforsker dit barn nye steder, f.eks. en park eller en vens hjem?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 22, answer_item: 21, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 22, answer_item: 21, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItemComment", col: 1, row: 23, answer_item: 22, items: "listitem::::Gør dit barn ting igen og igen og lader til ikke at kunne stoppe? F.eks. at rokke, snurre rundt, vifte med hænderne. Her kan du skrive andet.###textbox::::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 23, answer_item: 22, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 23, answer_item: 22, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 24, answer_item: 23, items: "listitem::::Skader dit barn sig selv med vilje?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 24, answer_item: 23, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 24, answer_item: 23, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 25, answer_item: 24, items: "listitem::::Følger dit barn reglerne (hjemme, i daginstitution)?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 25, answer_item: 24, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 25, answer_item: 24, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 26, answer_item: 25, items: "listitem::::Ødelægger eller beskadiger dit barn ting med vilje?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 26, answer_item: 25, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 26, answer_item: 25, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 27, answer_item: 26, items: "listitem::::Holder dit barn sig væk fra farlige ting, som f.eks. ild og kørende biler?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 27, answer_item: 26, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 27, answer_item: 26, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 28, answer_item: 27, items: "listitem::::Viser dit barn bekymring for andre folk følelser? F.eks. ser hun/han ked ud af det, når nogen slår sig?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 28, answer_item: 27, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 28, answer_item: 27, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 29, answer_item: 28, items: "listitem::::Kan andre børn lide at lege med dit barn?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 29, answer_item: 28, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 29, answer_item: 28, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 30, answer_item: 29, items: "listitem::::Kan dit barn lide at lege med andre børn?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 30, answer_item: 29, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 30, answer_item: 29, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 31, answer_item: 30, items: "listitem::::Prøver dit barn at gøre andre børn, voksne eller dyr ondt (fx ved at sparke eller bide?)", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 31, answer_item: 30, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 31, answer_item: 30, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 32, answer_item: 31, items: "listitem::::Kan dit barn skiftes til at tage tur og dele, når hun/han leger med andre børn?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 32, answer_item: 31, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 32, answer_item: 31, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 33, answer_item: 32, items: "listitem::::Udviser dit barn interesse for eller viden om seksuelle ord og aktiviteter?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 33, answer_item: 32, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 33, answer_item: 32, items: "checkbox::0::", prop_mask: 0, prespan: 1}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItemComment", col: 1, row: 34, answer_item: 33, items: "listitem::::Har nogen udtrykt bekymringer omkring dit barns adfærd? Hvis du har krydset af i ”nogle gange” eller ”for det meste af tiden” uddyb venligst:###textbox::::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Rating",   col: 2, row: 34, answer_item: 33, items: "radio::0::###checkbox::0::###radio::2::", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "Checkbox",   col: 3, row: 34, answer_item: 33, items: "checkbox::0::", prop_mask: 0, prespan: 1}))


    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 35, answer_item: 34, items: "listitem::::Har du nogle bekymringer om dit barns spise-, sove-, eller toiletvaner? Hvis ja, uddyb venligst:", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "ListItemComment", col: 2, row: 35, items: "###textbox::::", prop_mask: 0}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 36, answer_item: 35, items: "listitem::::Er der noget ved dit barn, som bekymrer dig? Hvis ja, uddyb venligst:", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "ListItemComment", col: 2, row: 36, items: "###textbox::::", prop_mask: 0}))

    question.question_cells <<   (QuestionCell.new({ type: "ListItem", col: 1, row: 37, answer_item: 36, items: "listitem::::Hvilke ting ved dit barn gør dig glad?", prop_mask: 0}))
    question.question_cells <<   (QuestionCell.new({ type: "ListItemComment", col: 2, row: 37, items: "###textbox::::", prop_mask: 0}))


    survey.save
    question.save
  end

  def self.down
    survey = Survey.all.last
    q = survey.questions.first
    q.question_cells.each &:destroy
    q.destroy
    survey.destroy
  end
end