require "git"

class GitPrompt
  class Repo
    def initialize(**opts)
      @config = opts[:config] || GitPrompt::Config.new
      @git = opts[:git] || open_git_repo
    end

    def current_branch
      git.current_branch
    end

    def github_org_and_repo
      origin.url.
        gsub("git@github.com:", "").
        gsub("https://github.com:", "").
        gsub(%r|\.git$|, "")
    end

    def github_org
      github_org_and_repo.split("/")[0]
    end

    def github_repo
      github_org_and_repo.split("/")[1]
    end

    def is_github_origin?
      is_git_repo? && !!origin
    end

    def is_git_repo?
      !!git
    end

    def origin
      git.remotes.find { |r| r.name == "origin" }
    end

    def git_root
      @git_root ||= begin
        path = File.expand_path(".")

        loop do
          return path if File.exists?(File.join(path, ".git"))
          return nil if path == "/"

          path = File.expand_path(File.join(path, ".."))
        end
      end
    end

    attr_reader :config, :git
    private

    def open_git_repo
      Git.open(git_root) if git_root
    end

  end
end
