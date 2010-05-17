namespace :typus do

  desc 'Install ckeditor.'
  task :ckeditor do
    system "script/plugin install git://github.com/galetahub/rails-ckeditor.git --force"
    load File.join Rails.root, 'vendor', 'plugins', 'rails-ckeditor', 'tasks', 'ckeditor_tasks.rake'
    Rake::Task["ckeditor:install"].invoke
    Rake::Task["ckeditor:config"].invoke
  end

end