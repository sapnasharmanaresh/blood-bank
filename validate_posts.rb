require 'minitest/autorun'
require 'active_support/inflector'

posts_path = File.join(File.dirname(File.expand_path(__FILE__)) , 'posts')
required_attributes = %w(slug title person content)

describe 'posts' do
  Dir["#{posts_path}/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{posts_path}/,'')} contains valid yaml header" do
      
      begin

        raw_data = File.open(file) { |f| f.read }
        if raw_data =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)(.*)/m
          yaml_data = YAML.load($1)

          post = {
            :slug           => yaml_data['slug'] || yaml_data['title'].parameterize,
            :title          => yaml_data['title'],
            :person         => yaml_data['author'],
            :featured_image => yaml_data['featured_image'],
            :published_at   => (yaml_data["published_at"] && ( Time.parse(yaml_data["published_at"].to_s) rescue nil )) || Time.now,
            :content        => $3,
            :keyword_list   => yaml_data.has_key?('tags') ? yaml_data['tags']['keyword'] : nil,
            :project_list   => yaml_data.has_key?('tags') ? yaml_data['tags']['project'] : nil,
            :person_list    => yaml_data.has_key?('tags') ? yaml_data['tags']['person'] : nil
          }

          required_attributes.each do |attribute|
            raise "Missing attribute #{attribute}" if !post[attribute.to_sym] || post[attribute.to_sym].empty?
          end

          raise "Invalid author: #{post[:person]}" if !File.exists? "people/#{post[:person]}.json"
        
          if post[:person_list] && !post[:person_list].empty?
            post[:person_list].split(",").each(&:strip!).each do |person_slug|
              raise "Invalid person: #{person_slug}" if !File.exists? "people/#{person_slug}.json"
            end
          end

        end
      rescue => e
        assertion = false, e.message + "\nIn: #{file}\nplease fix this!"
      else
         assertion = true
      end
      assert *assertion
    end
  end
end
