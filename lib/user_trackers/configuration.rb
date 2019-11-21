require "erb"
require "yaml"

module UserTrackers
  module Configuration
    def self.config_path
      'config/user_trackers.yml'
    end

    def self.get_yml_options
      opts = parse_config(config_path)
      opts
    end

    def self.parse_config(path)
      opts = YAML.load(ERB.new(File.read(path)).result) || {}

      if opts.respond_to? :deep_symbolize_keys!
        opts.deep_symbolize_keys!
      else
        symbolize_keys_deep!(opts)
      end

      opts
    end

    def self.symbolize_keys_deep!(hash)
      hash.keys.each do |k|
        symkey = k.respond_to?(:to_sym) ? k.to_sym : k
        hash[symkey] = hash.delete k
        symbolize_keys_deep! hash[symkey] if hash[symkey].is_a? Hash
      end
    end
    
  end
end