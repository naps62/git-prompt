require "octokit"

class GitPrompt
  class CLI
    class Update
      def initialize(**opts)
        @config = opts[:config]
        @repo = opts[:repo]
      end

      def run
        prs = fetch_pull_requests

        prs.each do |pr|
          key = ["prs", repo.github_org_and_repo, pr.head.ref]

          GitPrompt::Cache.get key do
            ci_status = `hub ci-status`.strip

            reviews = latest_reviews_for(pr)

            reviews.
              merge(ci_status: ci_status).
              to_json
          end
        end

        return 0
      end

      private

      def fetch_pull_requests
        gh_client.pulls(repo.github_org_and_repo)
      end

      def latest_reviews_for(pr)
        reviews_for_pull_request(pr).
          reverse.
          uniq { |r| r.user.login }.
          reduce({}) { |accum, r| accum.merge(r.user.login => r.state.downcase) }
      end

      def reviews_for_pull_request(pr)
        gh_client.pull_request_reviews(repo.github_org_and_repo, pr.number)
      end

      attr_reader :repo, :config

      def gh_client
        @gh_client ||= begin
          ENV["OCTOKIT_SILENT"] = "1"
          Octokit::Client.new(access_token: config.github_token)
        end
      end
    end
  end
end
