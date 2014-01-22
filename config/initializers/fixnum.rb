class Fixnum
  def to_roman
    value = self
    str = ""
    (str << "C"; value = value - 100) while (value >= 100)
    (str << "XC"; value = value - 90) while (value >= 90)
    (str << "L"; value = value - 50) while (value >= 50)
    (str << "XL"; value = value - 40) while (value >= 40)
    (str << "X"; value = value - 10) while (value >= 10)
    (str << "IX"; value = value - 9) while (value >= 9)
    (str << "V"; value = value - 5) while (value >= 5)
    (str << "IV"; value = value - 4) while (value >= 4)
    (str << "I"; value = value - 1) while (value >= 1)
    str
  end
end