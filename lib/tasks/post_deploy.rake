desc 'Run all deployment rake tasks'
task :post_deploy => ['deploy:migrate_db', 'deploy:precompile_assets', 'deploy:reindex_solr', 'deploy:tell_newrelic', 'deploy:restart_app']