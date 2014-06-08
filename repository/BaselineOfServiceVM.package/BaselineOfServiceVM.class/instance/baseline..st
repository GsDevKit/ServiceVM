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
                loads: #('default' 'Seaside-GemStone-Tools-Production-Gems');
                repository: 'github://glassdb/Seaside31:gemstone3.1/repository' ];
        yourself.
      spec
        package: 'Seaside-GemStone-ServiceVM-Support'
          with: [ spec requires: #('Seaside-GemStone-ServiceTask') ];
        package: 'Seaside-GemStone-ServiceTask'
          with: [ spec requires: #('Seaside3') ];
        package: 'Seaside-GemStone-ServiceExamples'
          with: [ spec requires: #('Seaside-GemStone-ServiceVM-Support') ];
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('Seaside-GemStone-ServiceVM-Support');
        group: 'Example' with: #('Seaside-GemStone-ServiceExamples');
        group: 'Tests' with: #() yourself ]