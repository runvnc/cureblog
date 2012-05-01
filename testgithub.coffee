GitHubApi = require "github"

github = new GitHubApi
  version: "3.0.0"

user = { user: 'mikedeboer' }

github.user.getFollowingFromUser user, (err, res) ->
    console.log JSON.stringify res

