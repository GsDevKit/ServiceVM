"edit the repoPath to match your installation"
| projectName repoPath |
projectName := 'ServiceVM'.
repoPath := 'filtree:///opt/git/ServiceVM/repository'.
GsDeployer bulkMigrate: [
  Metacello new
    baseline: projectName;
    repository: repoPath;
    get.
  Metacello new
    baseline: projectName;
    repository: repoPath;
    load.
].
