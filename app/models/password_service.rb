class PasswordService
  
  def self.generate_password
    ord1 = words[srand % (words.size)]
    n0 = rand(10).to_s
    n1 = rand(100).to_s
    n2 = rand(100).to_s
    ord2 = words[srand % (words.size)]
    assword = { :password => ord1 + n1 + ord2 + n2, :password_confirmation => ord1 + n1 + ord2 + n2 }
  end
  
  def self.words
    return @@words
  end

  @@words = ["abe", "ko", "hest", "hund", "kat", "mus", "fugl", "fisk", "gris", "and", "lam", "dyr", "fod", "ben", "rod", "fest",
    "stik", "stak", "stuk", "loft", "tag", "rip", "rap", "rup", "is", "ton", "tin", "tun", "dun",
    "luft", "jord", "ild", "vand", "bord", "stol", "post", "sofa", "ske", "sok", "stok", "zoo", "bus", "bil", "have",
    "havn", "hav", "hval", "glas", "blad", "dam", "vej", "gade", "sti", "sten", "lava", "lys", "skov", "mark", "korn",
    "bane", "spil", "tand", "sand", "land", "taxi", "mose", "sild", "grus", "gave", "hus", "telt", "kane", "kalk", "quiz",
    "nys", "hegn", "kop", "krat", "hegn", "tegn", "hane", "sol", "sal", "siv", "tur", "tip", "tal", "ord", "bog",
    "gul", "gips", "tog", "jern", "guld", "husk", "blik", "blok", "pop", "pap", "bold", "arm", "kage", "seng", "klub",
    "vogn", "knap", "pen", "snip", "fin", "fon", "snap", "fan", "snup", "fun", "snep", "vest", "nord", "syd",
    "nest", "test", "gast", "gust", "hep", "hop", "hip", "pip", "hap", "pep", "hup", "hyp", "snyt", "snit", "tit",
    "fut", "tut", "rat", "rut", "ret", "tast", "sub", "til", "told", "tran", "fup", "prop", "top", "tap", "stop",
    "stub", "stil", "stip", "spol", "spul", "brak", "nok", "kok", "kik", "ting", "tom", "bat", "bot", "bit",
    "nat", "dag", "hov", "hof", "bim", "bam", "bom", "bob", "bib", "bip", "pift", "fif", "nip", "nap", "nop",
    "nup", "flip", "flap", "flop", "sne", "slud", "vind", "vejr", "vip", "vap",
    "stav", "stap", "stip", "step", "gren", "bro", "gro", "kro", "krog", "tur", "tus", "bly", "ilt",
    "nul", "en", "to", "tre", "fire", "fem", "seks", "syv", "otte", "ni", "ti", "tolv", "snes", "kar", "banan", "bo", "lo", 
    "by", "sav", "rav", "dav", "dag", "dal", "bi", "dyne", "pude", "bamse", "beo", "due", "elg", "emu", "gnu", "haj", "klo", "los",
    "myg", "orm", "ren", "uld", "ulv", "yak", "zoo", "muh", "tja", "ups", "oh", "aha", "abc", "bad", "dan", "dej", "agn", "aks", 
    "als", "ara", "art", "ask", "asp", "bud", "fad", "fan", "fez", "fif", "fly", "fim", "fip", "ged", "gab", "gin", "god", "gro", "guf",
    "gut", "hej", "hik", "hyp", "ild", "ilt", "jul", "kok", "kro", "kor", "lak", "lap", "lex", "lyd", "lyn", "lun", "lur", "lys", 
    "ost", "obo", "olm", "ovn", "olm"    ]

end