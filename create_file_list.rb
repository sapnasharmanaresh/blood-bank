require 'json'
File.open('file_list.json', 'w+') do |file|
  file_list = Dir['*/**'].delete_if {|file_name| file_name =~ /^(events|images|schema)\//}
  file_list.delete_if {|file_name| file_name !~ /\.json$/}
  file.write file_list.to_json
end
