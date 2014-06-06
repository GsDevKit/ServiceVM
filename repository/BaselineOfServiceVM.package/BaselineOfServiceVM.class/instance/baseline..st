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
                loads: #('default' 'Seaside-REST-Core');
                repository: 'github://glassdb/Seaside31:gemstone3.1/repository' ];
        yourself.
      spec
        package: 'Seaside-GemStone-ServiceExamples'
          with: [ spec requires: #('Seaside3') ];
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('Seaside-GemStone-ServiceExamples');
        group: 'Tests' with: #() yourself ]