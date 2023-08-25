require 'splitclient-rb'

module Toggle
  class Split 
    def initialize(split_file_path)
      setup_split_client
    end

    def enabled?(toggle_name, options = {})
      key = options[:key].present? ? options[:key] : 'default'
      attrbs = options[:attrbs] || {}
      treatment = @split_client.get_treatment(key, toggle_name, attrbs)
      treatment.eql?('on')
    end

    def check_toggles(toggles_array, options = {})
      key = options[:key].present? ? options[:key] : 'default'
      attrbs = options[:attrbs] || {}
      splits_response = @split_client.get_treatments(key, toggles_array, attrbs)
      splits_response.keys.select { |split| splits_response[split].eql?('on') }.map(&:to_s)
    end

    private

    def setup_split_client
      split_factory = build_split_factory
      @split_client = split_factory.client
      @split_client.block_until_ready
    rescue StandardError => e
      puts  "Error connecting splitio: #{e.message}"
      split_factory.stop! if split_factory.present?
    end

    def build_split_factory
      SplitIoClient::SplitFactory.new('YOUR_API_KEY', split_options)
    end

    def split_options
      refresh_rate = 10
      {
        cache_adapter: :memory,
        connection_timeout: 10,
        read_timeout: 5,
        segments_refresh_rate: refresh_rate,
        features_refresh_rate: refresh_rate,
        metrics_refresh_rate: 360,
        impressions_refresh_rate: 360,
        events_push_rate: 360,
        debug_enabled: false,
        transport_debug_enabled: false,
        ip_addresses_enabled: false,
        logger: SplitLogger,
        impressions_mode: :optimized
      }
    end
  end

  # Logs 
  class SplitLogger
    class << self
      def debug(message)
        puts "DEBUG: SplitIO #{message}"
        Rails.logger.debug("SplitIO #{message}")
      end

      def error(message)
        puts "ERROR: SplitIO #{message}"
        Rails.logger.error("SplitIO #{message}")
      end

      def info(message)
        puts "INFO: SplitIO #{message}"
        Rails.logger.info("SplitIO #{message}")
      end

      def warn(message)
        puts "WARN: SplitIO #{message}"
        Rails.logger.warn("SplitIO #{message}")
      end

      def log(message)
        Rails.logger.info("SplitIO #{message}")
      end
    end
  end
end
