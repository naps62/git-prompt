require "octokit"

class GitPrompt
  class PullRequests
    def initialize(**opts)
      @config = opts[:config] || GitPrompt::Config.new
      @repo = opts[:repo] || GitPrompt::Repo.new
    end

    def fetch_all_open
      gh_client.pulls(repo.github_org_and_repo)
    end

    private

    attr_reader :config, :repo

    def gh_client
      @gh_client ||= begin
        ENV["OCTOKIT_SILENT"] = "1"
        Octokit::Client.new(access_token: config.github_token)
      end
    end
  end
end
