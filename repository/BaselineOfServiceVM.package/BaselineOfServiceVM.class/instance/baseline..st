baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        configuration: 'Seaside3'
          with: [ 
              spec
                version: #'release3.1';
                loads: #('Zinc' 'Seaside-GemStone-ServiceTask');
                repository:
                    'http://www.smalltalkhub.com/mc/Seaside/MetacelloConfigurations/main' ];
        yourself.
      spec
        package: 'Seaside-GemStone-ServiceVM-Support'
          with: [ spec requires: #('Seaside3') ];
        package: 'Seaside-GemStone-ServiceExamples'
          with: [ spec requires: #('Seaside-GemStone-ServiceVM-Support') ];
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('Seaside-GemStone-ServiceVM-Support');
        group: 'Example' with: #('Seaside-GemStone-ServiceExamples');
        group: 'Tests' with: #() yourself ]