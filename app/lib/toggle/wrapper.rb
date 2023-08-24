module Toggle
    class Wrapper
      attr_reader :client
  
      def initialize(client, toggles_list)
        @client = client  # to test it locally
        @toggles = toggles_list
      end
  
      def on?(toggle_name, options = {})
        @client.enabled?(toggle_name, options)
      end
  
      # return array of all enabled toggles from @toggles list
      def enabled_toggles(options = {})
        @client.check_toggles(@toggles, options)
      end
    end
  end
  