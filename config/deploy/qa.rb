set :deploy_to, "/www/sakai-widgetlibrary-qa"
set :host, 'widgetstore'
role :app, host
role :web, host
role :db, host, :primary => true
set :rails_env, "qa"
set :bundle_without, [:development]

namespace :deploy do

  task :cold, :roles => :app do
    run "touch #{shared_path}/db/#{rails_env}.sqlite3"
  end

  desc "Link database"
  task :set_db, :roles => :app do
    run "ln -nfs #{shared_path}/db/#{rails_env}.sqlite3 #{current_release}/db/#{rails_env}.sqlite3"
  end

  desc "set up dummy datea for the qa environment"
  task :dummy_data, :roles => :app do
    run "rm #{shared_path}/db/#{rails_env}.sqlite3"
    run "touch #{shared_path}/db/#{rails_env}.sqlite3"
    run "rm #{shared_path}/db/#{rails_env}.sqlite3"
    run "ln -nfs #{shared_path}/db/#{rails_env}.sqlite3 #{current_release}/db/#{rails_env}.sqlite3"
    run "cd #{current_release} && rake environment RAILS_ENV=#{rails_env} setup:dev --trace"
  end

end
