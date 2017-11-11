require "json"

class GitPrompt
  class Config
    def initialize
      file = "#{ENV["HOME"]}/.config/git-prompt/config.json"

      @settings =
        if File.exists?(file)
          JSON.parse(File.read(file))
        else
          {}
        end
    end

    def github_token
      settings["github_token"] || ENV["GITHUB_TOKEN"]
    end

    def cache_dir
      "#{ENV["HOME"]}/.config/git-prompt/cache"
    end

    def method_missing(method, *args, &block)
      settings[method.to_s]
    end

    private

    attr_reader :settings
  end
end
