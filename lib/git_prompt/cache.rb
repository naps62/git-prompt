class GitPrompt
  class Cache
    def self.instance
      @instance ||= new
    end

    def self.get(key, **opts, &block)
      if block_given?
        instance.get(key, &block)
      else
        instance.get(key) { opts[:default] }
      end
    end

    def get(key, &block)
      if key.is_a?(Array)
        key = key.join("/")
      end
      cache_file = File.join(config.cache_dir, key)

      FileUtils.mkdir_p(File.dirname(cache_file))

      if File.exists?(cache_file)
        File.read(cache_file)
      else
        new_value = yield
        File.write(cache_file, new_value)
        new_value
      end
    end

    private

    attr_reader :instance, :config

    def initialize
      @config = GitPrompt::Config.new
      FileUtils.mkdir_p(config.cache_dir)
    end
  end
end
