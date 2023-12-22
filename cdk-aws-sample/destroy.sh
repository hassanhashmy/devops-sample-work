#!/bin/bash

# Destroy the EC2InfoStack stack
cdk destroy EC2InfoStack
cdk destroy surecloud-cdk-scenario-prerequisite-stack
