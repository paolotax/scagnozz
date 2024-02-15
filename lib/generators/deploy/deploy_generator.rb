require "rails/generators"

class DeployGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_deployment_files
    @app_name = Rails.application.railtie_name
    @db_name = "#{@app_name}_db"
    @web_name = "#{@app_name}_web"
    @redis_name = "#{@app_name}_redis"

    case name
    when "heroku"
      copy_file "Procfile", "Procfile"
      puts "Copied files for Heroku"
    when "render"
      template "render.yaml", "render.yaml"
      copy_file "render-build.sh", "render-build.sh"
      puts "Copied files for Render"
    else
      puts "Please specify a supported deployment service (heroku, render)"
    end
  end

  private

  def source_paths
    [File.expand_path("templates", __dir__)]
  end
end
