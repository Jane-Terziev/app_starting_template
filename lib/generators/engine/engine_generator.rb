class EngineGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def generate_root_files
    engine_root_path = "engines/#{file_name}"
    template(".rubocop.yml.tt", "#{engine_root_path}/.rubocop.yml")
    template("Gemfile.tt", "#{engine_root_path}/Gemfile")
    template("gemspec.tt", "#{engine_root_path}/#{file_name}.gemspec")
    template("Rakefile.tt", "#{engine_root_path}/Rakefile")
    template("README.md.tt", "#{engine_root_path}/README.md")
  end

  def generate_lib_files
    engine_root_path = "engines/#{file_name}"
    template("lib/engine_name.rb.tt", "#{engine_root_path}/lib/#{file_name}.rb")
    template("lib/engine_name/engine.rb.tt", "#{engine_root_path}/lib/#{file_name}/engine.rb")
    template("lib/engine_name/version.rb.tt", "#{engine_root_path}/lib/#{file_name}/version.rb")
  end

  def generate_config_files
    engine_root_path = "engines/#{file_name}"
    template("config/importmap.rb.tt", "#{engine_root_path}/config/importmap.rb")
    template("config/routes.rb.tt", "#{engine_root_path}/config/routes.rb")
  end

  def generate_bin_files
    engine_root_path = "engines/#{file_name}"
    template("bin/rails.tt", "#{engine_root_path}/bin/rails")
    template("bin/rubocop.tt", "#{engine_root_path}/bin/rubocop")
  end

  def generate_app_files
    engine_root_path = "engines/#{file_name}"
    empty_directory("#{engine_root_path}/app/assets/stylesheets/#{file_name}")
    empty_directory("#{engine_root_path}/app/assets/images/#{file_name}")
    template("app/controllers/engine_name/application_controller.rb.tt", "#{engine_root_path}/app/controllers/#{file_name}/application_controller.rb")
    template("app/helpers/engine_name/application_helper.rb.tt", "#{engine_root_path}/app/helpers/#{file_name}/application_helper.rb")
    template("app/jobs/engine_name/application_job.rb.tt", "#{engine_root_path}/app/jobs/#{file_name}/application_job.rb")
    template("app/mailers/engine_name/application_mailer.rb.tt", "#{engine_root_path}/app/mailers/#{file_name}/application_mailer.rb")
    template("app/models/engine_name/application_record.rb.tt", "#{engine_root_path}/app/models/#{file_name}/application_record.rb")
    empty_directory("#{engine_root_path}/app/services/#{file_name}")
    empty_directory("#{engine_root_path}/app/views/#{file_name}")
  end

  def update_gemfile
    inject_into_file "Gemfile" do
      "
gem '#{file_name}', path: 'engines/#{file_name}'"
    end
  end

  def update_main_app_routes
    route_code = "mount #{file_name.capitalize}::Engine, at: '/#{file_name}'"
    insert_into_file "config/routes.rb", "  #{route_code}\n", after: "Rails.application.routes.draw do\n"
  end
end
