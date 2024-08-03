# For `git`
_git() {
  local -a commands
  commands=(
    'add:Stage changes'
    'bisect:Find by binary search the commit that introduced a bug'
    'branch:List, create, or delete branches'
    'checkout:Switch branches or restore working tree files'
    'clone:Clone a repository into a new directory'
    'commit:Record changes to the repository'
    'diff:Show changes between commits, commit and working tree, etc'
    'fetch:Download objects and refs from another repository'
    'grep:Print lines matching a pattern'
    'init:Create an empty Git repository or reinitialize an existing one'
    'log:Show commit logs'
    'merge:Join two or more development histories together'
    'mv:Move or rename a file, a directory, or a symlink'
    'pull:Fetch from and integrate with another repository or a local branch'
    'push:Update remote refs along with associated objects'
    'rebase:Reapply commits on top of another base tip'
    'reset:Reset current HEAD to the specified state'
    'rm:Remove files from the working tree and from the index'
    'show:Show various types of objects'
    'status:Show the working tree status'
    'tag:Create, list, delete or verify a tag object signed with GPG'
  )
  _describe -t commands 'git command' commands
}
compdef _git git

