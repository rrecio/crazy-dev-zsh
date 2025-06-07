package context

import (
	"fmt"

	"github.com/go-git/go-git/v5"
	"github.com/go-git/go-git/v5/plumbing"
	"github.com/go-git/go-git/v5/plumbing/object"
)

// GitAnalyzer analyzes Git repositories
type GitAnalyzer interface {
	// AnalyzeRepository analyzes a Git repository and returns information about it
	AnalyzeRepository(path string) (GitInfo, bool, error)
}

// GitAnalyzerImpl implements the GitAnalyzer interface
type GitAnalyzerImpl struct {
	maxCommitsToAnalyze int
}

// NewGitAnalyzer creates a new Git analyzer
func NewGitAnalyzer() GitAnalyzer {
	return &GitAnalyzerImpl{
		maxCommitsToAnalyze: 100, // Limit to avoid performance issues with large repos
	}
}

// AnalyzeRepository analyzes a Git repository and returns information about it
func (ga *GitAnalyzerImpl) AnalyzeRepository(path string) (GitInfo, bool, error) {
	gitInfo := GitInfo{}
	
	// Open the repository
	repo, err := git.PlainOpen(path)
	if err != nil {
		if err == git.ErrRepositoryNotExists {
			// Not a Git repository, return empty info
			return gitInfo, false, nil
		}
		return gitInfo, false, fmt.Errorf("error opening Git repository: %w", err)
	}
	
	// Get remote URL
	remotes, err := repo.Remotes()
	if err == nil && len(remotes) > 0 {
		for _, remote := range remotes {
			if remote.Config().Name == "origin" {
				if len(remote.Config().URLs) > 0 {
					gitInfo.RemoteURL = remote.Config().URLs[0]
					break
				}
			}
		}
	}
	
	// Get current branch
	head, err := repo.Head()
	if err == nil {
		if head.Name().IsBranch() {
			gitInfo.CurrentBranch = head.Name().Short()
		}
		
		// Get last commit
		commit, err := repo.CommitObject(head.Hash())
		if err == nil {
			gitInfo.LastCommit = commit.Hash.String()
		}
	}
	
	// Try to determine default branch
	// First check if we have a remote named "origin"
	if remotes != nil {
		for _, remote := range remotes {
			if remote.Config().Name == "origin" {
				// Try common default branch names
				for _, branchName := range []string{"main", "master", "develop"} {
					branchRef := plumbing.NewRemoteReferenceName("origin", branchName)
					_, err := repo.Reference(branchRef, true)
					if err == nil {
						gitInfo.DefaultBranch = branchName
						break
					}
				}
				break
			}
		}
	}
	
	// If we couldn't determine the default branch, use the current branch
	if gitInfo.DefaultBranch == "" && gitInfo.CurrentBranch != "" {
		gitInfo.DefaultBranch = gitInfo.CurrentBranch
	}
	
	// Get contributors
	contributors := make(map[string]bool)
	
	// Get commit history
	commitIter, err := repo.Log(&git.LogOptions{
		Order: git.LogOrderCommitterTime,
	})
	if err == nil {
		count := 0
		err = commitIter.ForEach(func(c *object.Commit) error {
			if count >= ga.maxCommitsToAnalyze {
				return nil
			}
			
			author := c.Author.Name
			if author != "" {
				contributors[author] = true
			}
			
			count++
			return nil
		})
		
		if err == nil {
			for contributor := range contributors {
				gitInfo.Contributors = append(gitInfo.Contributors, contributor)
			}
		}
	}
	
	return gitInfo, true, nil
}
