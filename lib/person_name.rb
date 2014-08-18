class PersonName 

    attr_accessor :names

    def process
        @names = {:boys => {}, :girls => {}}
        PersonInfo.find_each({:batch_size => 400}) do |pi|
            name = pi.name.split(" ").first
            next if name.first.to_i > 0 || name.last.to_i > 0
            gender = pi.sex == 1 && :boys || :girls

            if names[gender][name]
                @names[gender][name] += 1 
            else
                @names[gender][name] = 1
            end
        end

        @names[:boys].sort_by(&:last).each do |name|
            puts "#{name.first}: #{name.last}"
        end
        @names[:girls].sort_by(&:last).each do |name|
            puts "#{name.first}: #{name.last}"
        end
    end

    def boy?(name)
        @names[:boys][name]
    end

    def girl?(name)
        @names[:girls][name]
    end

    def correct_gender?(j)
        name = j.title.split(" ").first
        return true if name.first.to_i > 0 || name.last.to_i > 0
        result = j.sex == 1 && boy?(name) || girl?(name)
        prefix = j.sex == 1 && :boys || :girls
        puts "#{name} #{@names[prefix][name]}: #{j.title}"
        result
    end

    def count(j)
        name = j.title.split(" ").first
        prefix = j.sex == 1 && :boys || :girls
        puts "#{name} #{@names[prefix][name]}: #{j.title}"
        @names[prefix][name]
    end
end