namespace: Folder6
flow:
  name: a2
  workflow:
    - a1:
        do:
          Folder6.a1: []
        navigate:
          - FAILURE: on_failure
  results:
    - CUSTOM
    - FAILURE
extensions:
  graph:
    steps:
      a1:
        x: 351
        y: 163
    results:
      CUSTOM:
        de651b99-aed1-22c0-4151-3b99fcb44f0c:
          x: 65
          y: 82
