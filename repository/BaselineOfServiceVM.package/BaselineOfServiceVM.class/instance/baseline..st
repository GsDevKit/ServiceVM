baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
	  spec baseline: 'Seaside3' with: [
		spec loads: #('Core' 'REST' 'Seaside-Tools-Web');
			repository: 'github://GsDevKit/Seaside31:gs_master/repository' ].		
      spec
        package: 'Seaside-GemStone-ServiceVM-Support'
          with: [ spec requires: #('Seaside3') ];
        package: 'Seaside-GemStone-ServiceExamples'
          with: [ spec requires: #('Seaside-GemStone-ServiceVM-Support') ];
        yourself.
      spec
        group: 'default' with: #('Core' 'Example');
        group: 'Core' with: #('Seaside-GemStone-ServiceVM-Support');
        group: 'Example' with: #('Seaside-GemStone-ServiceExamples');
        group: 'Tests' with: #() yourself ]