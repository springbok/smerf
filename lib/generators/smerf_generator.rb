require 'rails/generators/migration'

class SmerfGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  include Rails::Generators::Migration
  
  class_option :skip_migration, :type => :boolean, :desc => "Don't generate a migration file for the Smerf tables."
  
  attr_accessor :plugin_path
  attr_accessor :user_model_name, :user_table_name, :user_table_fk_name 
  attr_accessor :link_table_name, :link_table_fk_name, :link_table_model_name,
                :link_table_model_class_name, :link_table_model_file_name

  def initialize(args = [], options = {}, config = {})
    super
    @user_model_name = file_name.downcase()
    @user_table_name = file_name.pluralize()
    @user_table_fk_name = "#{@user_model_name}_id"
    
    if (("smerf_forms" <=> @user_table_name) <= 0)
      @link_table_name = "smerf_forms_#{@user_table_name}"
    else
      @link_table_name = "#{@user_table_name}_smerf_forms"
    end
    @link_table_fk_name = "#{@link_table_name.singularize()}_id"
    @link_table_model_name = @link_table_name.singularize()
    @link_table_model_class_name = @link_table_model_name.classify()
    @link_table_model_file_name = @link_table_model_name.underscore()
    
    @plugin_path = "vendor/plugins/smerf"
  end
 
  def create_migration
    unless options.skip_migration?
      migration_template 'migrate/create_smerfs.rb', "db/migrate/create_smerfs.rb"
    end
  end
  
  def create_routes
    route "resources :smerf_forms"
  end
  
  def create_smerf_directory_and_test_form
    directory 'smerf'  
  end
  
  def copy_example_stylesheet
    copy_file 'public/smerf.css', 'public/stylesheets/smerf.css'
  end
  
  def copy_error_and_help_images
    copy_file 'public/smerf_error.gif', 'public/images/smerf_error.gif' 
    copy_file 'public/smerf_help.gif', 'public/images/smerf_help.gif' 
  end
  
  def helpers
    copy_file 'lib/smerf_helpers.rb', 'lib/smerf_helpers.rb'
  end    
  
  # NOTE: in the original Smerf code the smerf_forms_user.rb and smerf_response.rb files get
  # generated in the Smerf plugin's app/models folder. Not sure why this is done, but we want
  # to avoid it for the purposes of gemifying the plugin. 
  def copy_models
    template 'app/models/smerf_forms_user.rb', "app/models/#{@link_table_model_file_name}.rb"
    template 'app/models/smerf_response.rb',   "app/models/smerf_response.rb"
  end
  
  # NOTE: see note above
  def copy_controllers
    template 'app/controllers/smerf_forms_controller.rb', "app/controllers/smerf_forms_controller.rb"
  end
  
  # def init
  #   copy_file 'smerf_init.rb', "config/initializers/smerf_init.rb"
  # end  
  #
  # Implement the required interface for Rails::Generators::Migration.
  # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  #
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
 #Rails::Generators::Migration.next_migration_number
 
  #template
  # def manifest
  #   record do |m|
  #     
  #     # Migrations
  #     m.migration_template("migrate/create_smerfs.rb", 
  #       "db/migrate", {:migration_file_name => 'create_smerfs'}) unless options[:skip_migration]
  # 
  #     # Routes
  #     m.route_resources(:smerf_forms)
  # 
  #     # Create smerf directory and copy test form
  #     m.directory('smerf')
  #     m.file('smerf/testsmerf.yml', 'smerf/testsmerf.yml')
  #     
  #     # Copy example stylesheet
  #     m.file('public/smerf.css', 'public/stylesheets/smerf.css')
  # 
  #     # Copy error and help images
  #     m.file('public/smerf_error.gif', 'public/images/smerf_error.gif')
  #     m.file('public/smerf_help.gif', 'public/images/smerf_help.gif')
  #     
  #     # Helpers
  #     m.file 'lib/smerf_helpers.rb', 'lib/smerf_helpers.rb'
  #     
  #     # Copy models
  #     m.template('app/models/smerf_forms_user.rb', "#{plugin_path}/app/models/#{@link_table_model_file_name}.rb")
  #     m.template('app/models/smerf_response.rb', "#{plugin_path}/app/models/smerf_response.rb")
  #     
  #     # Copy controllers
  #     m.template('app/controllers/smerf_forms_controller.rb', "#{plugin_path}/app/controllers/smerf_forms_controller.rb")
  # 
  #     # init.rb
  #     m.file('smerf_init.rb', "#{plugin_path}/init.rb", :collision => :force)
  # 
  #     # Display INSTALL notes
  #     m.readme "INSTALL"
  #   end
  # end
  
  protected
  
    # Custom banner
    def banner
      "Usage: #{$0} smerf UserModelName"
    end
    
    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-migration", 
             "Don't generate a migration files") { |v| options[:skip_migration] = v }
    end

end
