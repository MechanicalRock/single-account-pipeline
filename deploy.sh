#! /bin/bash
set -euo pipefail

# FIXME - not working in codebuild
for template in $(ls cloudformation)
do
  echo "Testing $template"
  cfn-lint "cloudformation/$template"
done

ORGANIZATION_ID=$(aws organizations describe-organization --query Organization.Id --output text)
echo "Deploying for organization: ${ORGANIZATION_ID}"

PARAM_DOMAIN_NAME="artifacts-temyers"

aws cloudformation deploy --stack-name single-account-pipeline-template-bucket --template cloudformation/template-bucket.yaml

TEMPLATE_BUCKET=$(aws cloudformation describe-stacks --stack-name single-account-pipeline-template-bucket --query "Stacks[0].Outputs[?OutputKey=='TemplateBucket'].OutputValue" --output text)

echo "Template Bucket: ${TEMPLATE_BUCKET}"
mkdir -p .build
aws cloudformation package --template-file cloudformation/master.yaml --s3-bucket "${TEMPLATE_BUCKET}" --output-template-file .build/master.yaml

aws cloudformation deploy --stack-name single-account-pipeline --template-file .build/master.yaml --parameter-overrides OrganizationId="${ORGANIZATION_ID}" DomainName="${PARAM_DOMAIN_NAME}" --capabilities CAPABILITY_IAM