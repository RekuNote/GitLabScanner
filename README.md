<div align="center">
  <a href="#">
    <img src="assets/banner.png" alt="Logo">
  </a>
</div>

# RekuNote/GitLabScanner

Tools/utilities to clone every repository from a GitLab user or group and all the members of group; and to scan over the entire commit history to find interesting things

> Requires installation of the [`jq`](https://github.com/jqlang/jq) utility to parse GitLab API responses.

## Table of Contents
- [Tools](#tools)
  - [clone_group_users.sh](#clone_group_userssh)
  - [clone_user.sh](#clone_usersh)
  - [search.sh](#searchsh)
  - [exclude.txt](#excludetxt)
- [Getting your GitLab personal access key](#getting-your-gitlab-personal-access-key)
- [Requirements](#requirements)
- [Updated Directory Structure](#updated-directory-structure)
- [Notes](#notes)
- [Credits](#credits)

## Tools

### `clone_group_users.sh`

Iterate through a GitLab group's users and clone all their repositories.

```bash
./clone_group_users.sh groupname
```

### `clone_user.sh`

Clone all repositories from a GitLab user.

```bash
./clone_user.sh username
```

### `search.sh`

Search through all cloned repositories and their commit histories for a given string or regex.

```bash
./search.sh '[regex]'
```

Example:

```bash
./search.sh 'flipnote}'
```

(This searches for any numeric strings in all repositories.)

### `exclude.txt`

Exclude specific repositories from being cloned. Add repositories to this file if they are forks, too large to store or search, or not relevant.

#### Format:

One repository per line, in the format:

```
UserOrGroupName/RepoName
```

For example:

```
exampleuser/huge-repo
examplegroup/irrelevant-fork
```

## Getting your GitLab personal access key

**Note:** Before using these tools, you need to set your `GITLAB_TOKEN` environment variable.  
1. Go to [GitLab Personal Access Tokens](https://gitlab.com/-/user_settings/personal_access_tokens).  
2. Click the `Add new token` button.  
3. Give it a name (e.g., "GitLabScanner"), select the necessary scopes (e.g., `api`), and generate the token.  
4. Copy the token and set it in your environment. For example:
   ```bash
   export GITLAB_TOKEN=your_generated_token
   ```
5. Optionally, add the export command to your shell's configuration file (e.g., `.bashrc` or `.zshrc`) for persistence.

## Requirements

- `jq` for parsing GitLab API responses.
- `git` for cloning and interacting with repositories.

## Updated Directory Structure

Repositories are stored differently to gitscanner:
```
├── repositories
│   └── git@gitlab.com
│       └── Username
│           └── RepoName
│               ├── <repository files>
```

## Notes

- These tools are optimised for GitLab but can be adapted for similar APIs.
- Ensure you have sufficient disk space before running these tools.
- This repository is a fork of [gitscanner](https://github.com/sudofox/gitscanner/) by [sudofox](https://github.com/sudofox/).