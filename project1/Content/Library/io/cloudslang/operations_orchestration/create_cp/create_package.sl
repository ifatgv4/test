#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Creates a content pack from a CloudSlang content folder which can be deployed in OO Central.
#! @input cp_name: content pack name - Example: "base"
#! @input cp_version: content pack version - Example: "0.1"
#! @input cslang_folder: CloudSlang content folder to pack - Example: "C:/cslang-cli/cslang/content/io/cloudslang/base"
#! @input cp_publisher: content pack publisher - Example: "Customer"
#! @input cp_location: location for the content pack jar file - Example: "c:/content_packs"
#! @input cp_folder: optional - temporary folder for the package - Default: <cp_location>/<cp_name>-cp-<cp_version>
#! @result SUCCESS: 
#! @result CREATE_LIB_FOLDER_FAILURE: 
#! @result POPULATE_LIB_FOLDER_FAILURE: 
#! @result CREATE_SYSTEM_PROPERTIES_FAILURE: 
#! @result CREATE_LIBRARY_STRUCTURE_FAILURE: 
#! @result COPY_CONTENT_FAILURE: 
#! @result CREATE_CP_PROPERTIES_FAILURE: 
#! @result CREATE_ARCHIVE_FAILURE: 
#! @result CREATE_JAR_FAILURE: 
#! @result CLEAN_FOLDER_FAILURE: 
#!!#
#
####################################################
namespace: io.cloudslang.operations_orchestration.create_cp
imports:
  create_cp: io.cloudslang.operations_orchestration.create_cp
  files: io.cloudslang.base.files
flow:
  name: create_package
  inputs:
    - cp_name
    - cp_version
    - cslang_folder
    - cp_publisher
    - cp_location
    - cp_folder: '${cp_location + "/" + cp_name + "-cp-" + cp_version}'
  workflow:
    - create_Lib_folder:
        do:
          files.create_folder_tree:
            - folder_name: '${cp_folder + "/Lib"}'
        navigate:
          - SUCCESS: populate_Lib_folder
          - FAILURE: CREATE_LIB_FOLDER_FAILURE
    - populate_Lib_folder:
        do:
          files.write_to_file:
            - file_path: '${cp_folder + "/Lib/placeHolder"}'
            - text: ' '
        navigate:
          - SUCCESS: create_system_Properties_folder
          - FAILURE: POPULATE_LIB_FOLDER_FAILURE
    - create_system_Properties_folder:
        do:
          files.create_folder_tree:
            - folder_name: '${cp_folder + "/Content/Configuration/System Properties"}'
        navigate:
          - SUCCESS: create_Library_Structure
          - FAILURE: CREATE_SYSTEM_PROPERTIES_FAILURE
    - create_Library_Structure:
        do:
          files.create_folder_tree:
            - folder_name: '${cp_folder + "/Content/Library/Community/cslang/"}'
        navigate:
          - SUCCESS: copy_content
          - FAILURE: CREATE_LIBRARY_STRUCTURE_FAILURE
    - copy_content:
        do:
          files.copy:
            - source: '${cslang_folder}'
            - destination: '${cp_folder + "/Content/Library/Community/cslang/" + cp_name}'
        navigate:
          - SUCCESS: move_config_items
          - FAILURE: COPY_CONTENT_FAILURE
    - move_config_items:
        do:
          create_cp.copy_config_items:
            - source_dir: '${cp_folder + "/Content/Library/Community/cslang/" + cp_name}'
            - target_dir: '${cp_folder + "/Content/Configuration/System Properties/"}'
        navigate:
          - SUCCESS: create_cp_properties
    - create_cp_properties:
        do:
          files.write_to_file:
            - file_path: '${cp_folder + "/contentpack.properties"}'
            - text: "${\"content.pack.name=\" + cp_name + \"\\n\" + \"content.pack.version=\" + cp_version + \"\\n\" + \"content.pack.description=\" + cp_name + \"\\n\" + \"content.pack.publisher=\" + cp_publisher}"
        navigate:
          - SUCCESS: create_archive
          - FAILURE: CREATE_CP_PROPERTIES_FAILURE
    - create_archive:
        do:
          files.zip_folder:
            - folder_path: '${cp_folder}'
            - archive_name: '${cp_name + "-cp-" + cp_version}'
        navigate:
          - SUCCESS: create_jar
          - FAILURE: CREATE_ARCHIVE_FAILURE
    - create_jar:
        do:
          files.move:
            - source: '${cp_folder + "/" + cp_name + "-cp-" + cp_version + ".zip"}'
            - destination: '${cp_location + "/" + cp_name + "-cp-" + cp_version + ".jar"}'
        navigate:
          - SUCCESS: clean_folder
          - FAILURE: CREATE_JAR_FAILURE
    - clean_folder:
        do:
          files.delete:
            - source: '${cp_folder}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CLEAN_FOLDER_FAILURE
  results:
    - SUCCESS
    - CREATE_LIB_FOLDER_FAILURE
    - POPULATE_LIB_FOLDER_FAILURE
    - CREATE_SYSTEM_PROPERTIES_FAILURE
    - CREATE_LIBRARY_STRUCTURE_FAILURE
    - COPY_CONTENT_FAILURE
    - CREATE_CP_PROPERTIES_FAILURE
    - CREATE_ARCHIVE_FAILURE
    - CREATE_JAR_FAILURE
    - CLEAN_FOLDER_FAILURE
extensions:
  graph:
    steps:
      create_cp_properties:
        x: 1900
        y: 250
        navigate:
          8f365a7d-a7d8-a52d-86e2-6d6958dd36ee:
            targetId: 5eceed9b-19db-8ef7-bd0e-54665ee16cee
            port: FAILURE
      clean_folder:
        x: 2800
        y: 125
        navigate:
          0a50314d-d78b-5c9b-3e83-180e59608ec8:
            targetId: 0faa84e5-ead3-4fe8-0fd5-1a6049b22a45
            port: SUCCESS
          146dcb30-b074-647c-32e5-cfbef5b56f2c:
            targetId: 1c8cb1ab-b9d7-3590-33ea-6fcc88a1a8a8
            port: FAILURE
      create_Lib_folder:
        x: 100
        y: 250
        navigate:
          08e79b54-5f17-23e3-68cc-3976e878c5a1:
            targetId: 548b54c3-0569-dc7b-a8f7-15b2cd3e0679
            port: FAILURE
      create_Library_Structure:
        x: 1000
        y: 125
        navigate:
          e5fa8005-a44a-5007-1ece-d64bd9545aa3:
            targetId: 324faa61-f222-d1ec-edfa-aebe80f418cc
            port: FAILURE
      create_system_Properties_folder:
        x: 700
        y: 125
        navigate:
          72494afb-4989-8c78-732f-53b9847c6369:
            targetId: 6f8d2221-f947-4e33-044f-09c4f37cc645
            port: FAILURE
      copy_content:
        x: 1300
        y: 125
        navigate:
          eb1ae77b-d9f2-97d7-0686-df1c4fdf4a93:
            targetId: b8a1f164-d1f7-13c5-5535-3a171ece49f7
            port: FAILURE
      move_config_items:
        x: 1600
        y: 125
      create_jar:
        x: 2500
        y: 125
        navigate:
          8973b053-6969-fc45-b015-5b4613a639bc:
            targetId: e53057f0-9c34-1ffe-98e9-f812f1b0d502
            port: FAILURE
      populate_Lib_folder:
        x: 211
        y: 64
        navigate:
          c970e4c5-ffdf-b079-b62a-10e15c43c5f0:
            targetId: a1295dc3-205d-218c-7a5d-71efd09c9e21
            port: FAILURE
      create_archive:
        x: 2200
        y: 125
        navigate:
          04317a4a-43c3-e741-675c-484182322cdd:
            targetId: 71a25a17-0a10-70aa-72bb-59ec06fc6981
            port: FAILURE
    results:
      CREATE_JAR_FAILURE:
        e53057f0-9c34-1ffe-98e9-f812f1b0d502:
          x: 2800
          y: 375
      SUCCESS:
        0faa84e5-ead3-4fe8-0fd5-1a6049b22a45:
          x: 3100
          y: 125
      POPULATE_LIB_FOLDER_FAILURE:
        a1295dc3-205d-218c-7a5d-71efd09c9e21:
          x: 700
          y: 377
      CREATE_ARCHIVE_FAILURE:
        71a25a17-0a10-70aa-72bb-59ec06fc6981:
          x: 2500
          y: 375
      CREATE_SYSTEM_PROPERTIES_FAILURE:
        6f8d2221-f947-4e33-044f-09c4f37cc645:
          x: 1000
          y: 375
      CREATE_CP_PROPERTIES_FAILURE:
        5eceed9b-19db-8ef7-bd0e-54665ee16cee:
          x: 2200
          y: 375
      CLEAN_FOLDER_FAILURE:
        1c8cb1ab-b9d7-3590-33ea-6fcc88a1a8a8:
          x: 3100
          y: 375
      CREATE_LIB_FOLDER_FAILURE:
        548b54c3-0569-dc7b-a8f7-15b2cd3e0679:
          x: 400
          y: 375
      CREATE_LIBRARY_STRUCTURE_FAILURE:
        324faa61-f222-d1ec-edfa-aebe80f418cc:
          x: 1300
          y: 375
      COPY_CONTENT_FAILURE:
        b8a1f164-d1f7-13c5-5535-3a171ece49f7:
          x: 1600
          y: 375
