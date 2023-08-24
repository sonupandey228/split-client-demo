Rails.application.reloader.to_prepare do
    # for testing it locally 
    def local_file_path  
      Rails.root.join('config', 'split_toggles.yml') 
    end
    remote_toggle_client = Toggle::Split.new(local_file_path)
    # list of flags in second args
    ::RemoteToggle = Toggle::Wrapper.new(remote_toggle_client, ["FLAG1", "FLAG2", "FLAG3"])
  end