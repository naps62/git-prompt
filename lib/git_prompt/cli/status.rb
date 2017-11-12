class GitPrompt
  class CLI
    class Status
      def initialize(**opts)
        @repo = opts[:repo]
      end

      def run
        key = [repo.github_org_and_repo, repo.current_branch]

        puts GitPrompt::Cache.get(key, default: "")
      end

      private

      attr_reader :repo
    end
  end
end
