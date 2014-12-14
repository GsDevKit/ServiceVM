baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        baseline: 'Seaside3'
          with: [ 
              spec
                loads:
                    #('default' 'Zinc' 'Seaside-GemStone-ServiceTask' 'Seaside-GemStone-GemServer');
                repository: 'github://GsDevKit/Seaside31:issue_54/repository' ];
        yourself.
      spec
        package: 'Seaside-GemStone-ServiceVM-Support'
          with: [ spec requires: #('Seaside3') ];
        package: 'Seaside-GemStone-ServiceExamples'
          with: [ spec requires: #('Seaside-GemStone-ServiceVM-Support') ];
        package: 'Seaside-GemStone-ServiceVM-GemServer'
          with: [ spec requires: #('Seaside3') ];
        yourself.
      spec
        group: 'default' with: #('Core' 'Example');
        group: 'Core'
          with:
            #('Seaside-GemStone-ServiceVM-Support' 'Seaside-GemStone-ServiceVM-GemServer');
        group: 'Example' with: #('Seaside-GemStone-ServiceExamples');
        group: 'Tests' with: #();
        group: 'CI' with: #('Core' 'Tests' 'Example');
        yourself ]