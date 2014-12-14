"Load and run tests to be performed by TravisCI"
| gitCache gitPath loadBlock |
Transcript cr; show: 'travis---->travisCI.st'.

gitCache := 'git_cache'.
gitPath := (fileDirectoryClass default directoryNamed: gitCache ) fullName.

"Upgrade Grease and Metacello"
Gofer new
  package: 'GsUpgrader-Core';
  url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
  load.
(Smalltalk at: #GsUpgrader) upgradeGrease.


"Load ServiceVM"
GsDeployer deploy: [
  Metacello new
    baseline: 'ServiceVM';
    repository: 'filetree://', gitPath, '/ServiceVM/repository';
    load: 'CI' ].

true ifTrue: [
  "Run all tests in image"
   TravisCISuiteHarness
     value: TestCase suite
     value: 'TravisCISuccess.txt'
     value: 'TravisCIFailure.txt'.
] ifFalse: [
  "Run just the ServiceVM tests"
  TravisCIHarness
    value: #( 'BaselineOfServiceVM' )
    value: 'TravisCISuccess.txt' 
    value: 'TravisCIFailure.txt' ].
