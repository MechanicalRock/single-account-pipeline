#!/bin/bash
set -euo pipefail

ARTIFACT_BUCKET=`aws cloudformation describe-stacks --stack-name single-account-pipeline --query "Stacks[0].Outputs[?OutputKey=='ArtifactBucket'].OutputValue" --output text`
BUILD_PROJECT=`aws cloudformation describe-stacks --stack-name single-account-pipeline --query "Stacks[0].Outputs[?OutputKey=='CodebuildProject'].OutputValue" --output text`

# zip -r artifact.zip . --exclude @.zipignore
aws s3 cp artifact.zip s3://${ARTIFACT_BUCKET}/pipeline-artifact.zip

# aws codebuild start-build --project-name ${BUILD_PROJECT} 