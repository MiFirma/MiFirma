namespace :typus do

  desc "Install acts_as_list, acts_as_tree and paperclip."
  task :misc do

    plugins = [ "git://github.com/thoughtbot/paperclip.git", 
                "git://github.com/rails/acts_as_list.git", 
                "git://github.com/rails/acts_as_tree.git" ]

    # plugins << "git://github.com/NZKoz/rails_xss.git" if Rails.version.eql?("2.3.5")

    system "script/plugin install #{plugins.join(" ")} --force"

  end

  desc "Install ssl_requirement."
  task :ssl do
    system "script/plugin install git://github.com/rails/ssl_requirement.git --force"
  end

  desc "List current roles."
  task :roles => :environment do
    Typus::Configuration.roles.each do |role|
      puts "\n#{role.first.capitalize} role has access to:"
      role.last.each { |key, value| puts "- #{key}: #{value}" }
    end
    puts "\n"
  end

end