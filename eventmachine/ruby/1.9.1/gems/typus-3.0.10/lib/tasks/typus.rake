namespace :typus do

  desc "List current roles."
  task :roles => :environment do
    Typus::Configuration.roles.each do |role|
      puts "'#{role.first}' role has access to:"
      role.last.each { |k, v| puts "- #{k}: #{v}" }
    end
  end

end
