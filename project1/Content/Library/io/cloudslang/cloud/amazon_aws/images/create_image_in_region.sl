#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates an Amazon EBS-backed AMI from an Amazon EBS-backed instance that is either running or stopped.
#! @input provider: Cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: Endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - Proxy server used to access the provider services
#! @input proxy_port: optional - Proxy server port used to access the provider services - Default: '8080'
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - Region where image will be created. ListRegionAction can be used in order to get all regions.
#!                           For further details check: http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
#!                         - Default: 'us-east-1'
#! @input instance_id: ID of the server (instance) to be used to create image for
#! @input name: A name for the new image
#! @input image_description: optional - A description for the new image - Default: ''
#! @input image_no_reboot: optional - By default, Amazon EC2 attempts to shut down and reboot the instance before creating
#!                                    the image. If the 'No Reboot' option is set, Amazon EC2 doesn't shut down the instance
#!                                    before creating the image. When this option is used, file system integrity on the created
#!                                    image can't be guaranteed
#!                                  - Default: 'true'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the image was successfully created
#! @result FAILURE: an error occurred when trying to create image
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.images

operation:
  name: create_image_in_region

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
        sensitive: true
    - credential:
        default: ''
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        private: true
        required: false
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        private: true
    - debug_mode:
        required: false
    - debugMode:
        default: ${get("debug_mode", "false")}
        private: true
    - region:
        default: 'us-east-1'
        required: false
    - instance_id
    - instanceId:
        default: ${instance_id}
        private: true
    - name
    - image_description:
        required: false
    - imageDescription:
        default: ${get("image_description", "")}
        private: true
        required: false
    - image_no_reboot:
        required: false
    - imageNoReboot:
        default: ${get("image_no_reboot", "")}
        private: true
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-jclouds:0.0.9'
    class_name: io.cloudslang.content.jclouds.actions.images.CreateImageInRegionAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
