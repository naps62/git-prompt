require "git_prompt/cli/update"
require "git_prompt/cli/status"
require "git_prompt/cli/usage"

class GitPrompt
  class CLI
    def initialize(args)
      @repo = GitPrompt::Repo.new
      @config = GitPrompt::Config.new
      @args = args
    end

    def run
      cmd = args.shift || "usage"

      if !repo.is_github_origin?
        STDERR.puts "Error: Not in a github repo"
        return 1
      end

      if cacheable?(cmd)
        key = [repo.github_org, repo.github_repo, cmd]

        GitPrompt::Cache.get(key) do
          run_cmd(cmd)
        end
      else
        run_cmd(cmd)
      end

      return 0
    end

    def run_cmd(cmd)
      cmd_handler(cmd).new(repo: repo, config: config).run
    end

    private

    def cmd_handler(cmd)
      case cmd
      when "update" then GitPrompt::CLI::Update
      when "status" then GitPrompt::CLI::Status
      else GitPrompt::CLI::Usage
      end
    end

    def cacheable?(cmd)
      ["update"].include?(cmd)
    end

    attr_reader :args, :repo, :config
  end
end
