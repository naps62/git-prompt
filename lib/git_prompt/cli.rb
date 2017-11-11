class GitPrompt
  class CLI
    def initialize(args)
      @repo = GitPrompt::Repo.new
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
          public_send(cmd)
        end
      else
        public_send(cmd)
      end

      return 0
    end

    def update
      prs = GitPrompt::PullRequests.new(repo: repo).fetch_all_open

      prs.each do |pr|
        key = [repo.github_org_and_repo, pr.head.ref]

        GitPrompt::Cache.get key do
          "test"
        end
      end
    end

    def status
      key = [repo.github_org_and_repo, repo.current_branch]

      puts GitPrompt::Cache.get(key, default: "")
    end

    def usage
      puts <<~EOF
      TODO: usage
      EOF
    end

    private

    def cacheable?(cmd)
      ["update"].include?(cmd)
    end

    attr_reader :args, :repo
  end
end
