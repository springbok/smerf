%w{ models controllers helpers views}.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  model_path = path if path.include?('models') 
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)  
end

# Include smerf classes once Rails have initialised. We need to do this so 
# that YAML will be able know how to unserialize smerf forms we 
# serialize to the DB
require "smerf_item"
require "smerf_file"
require "smerf_group"
require "smerf_question"
require "smerf_answer"
require "smerf_meta_form"

module Smerf
  
  protected

    # Method retrieves the user id from the session if it exists
    def smerf_user_id
      session[:smerf_user_id] || -1      
    end

    # Method stores the specified user id in the session
    def smerf_user_id=(id)
      session[:smerf_user_id] = id
    end

end    