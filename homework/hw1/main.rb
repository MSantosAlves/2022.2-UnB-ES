# 1a
def palindrome? (string)
    treated_string = string.gsub(/\W/, "").downcase
    treated_string == treated_string.reverse
  end

# 1b
def count_words(string)
    splited_string = string.downcase.split(' ').each { |w| w.gsub!(/\W/, "")}.reject {|str| str.nil? || str.empty? }
    result = {}
    splited_string.each do |str|
      if result[str].nil?
        result[str] = 1
      else
        result[str] += 1
      end
    end
    return result
  end