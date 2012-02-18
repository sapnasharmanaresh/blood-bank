require 'json'
File.open('file_list.json', 'w+') do |file|
  file_list = Dir['*/**'].delete_if { |e| e =~ /(^(courses|events|locations|images|schema)\/)|([^\.][^j][^s][^o][^n]$)/ }
  file.write file_list.to_json
end
