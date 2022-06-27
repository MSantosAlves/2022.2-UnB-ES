def parse_file(filename)
    file = File.open(filename)
    encoded_file_content = file.read.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    splited_data = encoded_file_content.split("\n")
    splited_data.each { |line| puts line.strip if line =~/[0-9][0-9]\/[0-9]{7}/ }
    file.close
end

parse_file("engsoft.txt")