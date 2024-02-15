require "active_support/inflector"

# [RailsNotes UI Addition]
# A Rake task to rename your app when you initially clone it.
# Run as part of app:setup script.
#
namespace :app do
  desc "Rename the application"
  task :rename, [:new_name] => :environment do |t, args|
    new_name = args[:new_name]

    raise ">>> Error Renaming: you provided a blank name!" if new_name.blank?

    camel_cased_name = new_name.camelize

    # Update application.html.erb
    file_path = "app/views/layouts/application.html.erb"
    text = File.read(file_path)
    new_contents = text.gsub(/<title>.*<\/title>/, "<title>#{camel_cased_name}</title>")
    File.open(file_path, "w") { |file| file.puts new_contents }

    # Update application.rb
    file_path = "config/application.rb"
    text = File.read(file_path)
    new_contents = text.gsub(/module \w+/, "module #{camel_cased_name}")
    File.open(file_path, "w") { |file| file.puts new_contents }

    # Update cable.yml
    file_path = "config/cable.yml"
    text = File.read(file_path)
    new_contents = text.gsub(/channel_prefix: \w+_production/, "channel_prefix: #{new_name}_production")
    File.open(file_path, "w") { |file| file.puts new_contents }

    # Update database.yml
    file_path = "config/database.yml"
    text = File.read(file_path)
    new_contents = text.gsub(/database: \w+_(development|test|production)/) do |match|
      "database: #{new_name}_#{match.split("_").last}"
    end
    new_contents.gsub!(/username: \w+/, "username: #{new_name}")
    new_contents.gsub!(/password: <%= ENV\["\w+_DATABASE_PASSWORD"\] %>/, "password: <%= ENV[\"#{new_name.upcase}_DATABASE_PASSWORD\"] %>")
    File.open(file_path, "w") { |file| file.puts new_contents }

    puts "Application renamed to #{camel_cased_name}"
  end
end
