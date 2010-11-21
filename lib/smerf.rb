%w{ models controllers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end

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