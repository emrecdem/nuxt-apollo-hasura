cwlVersion: v1.0
class: CommandLineTool

inputs:
  - id: time
    type: string

outputs:
  - id: out
    type: string
    outputBinding:
      glob: out.txt
      loadContents: true
      outputEval: $(self[0].contents)

baseCommand: ['sleep','$(inputs.time)']
stdout: out.txt