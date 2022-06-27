def parse_file(filename)
    file = File.open(filename)
    encoded_file_content = file.read.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    splited_data = encoded_file_content.split("\n")
    lines = []
    splited_data.each { |l| lines.push(l.strip) if l =~/[0-9][0-9]\/[0-9]{7}/ }
    yield lines
    file.close
end

# Print data sorted by "Matricula"
parse_file("engsoft.txt") do |x|
    puts x.sort_by { |line| line.split("    ")[0] }
end

# Print data sorted by "Name"
parse_file("engsoft.txt") do |x|
    puts x.sort_by { |line| line.split("    ")[1] }
end