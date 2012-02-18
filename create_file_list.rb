require 'json'
File.open('file_list.json', 'w+') do |file|
  file.write(Dir['*/**'].delete_if{|e| e=~ /^(courses|events|locations|images|schema)\//}.to_json)
end
