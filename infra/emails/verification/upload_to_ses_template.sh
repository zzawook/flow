#!/bin/bash

REGION=ap-southeast-1
TEMPLATE=FlowVerifyEn
SENDER=no-reply@mail.flowfinancials.io   # use a verified identity

HTML=$(jq -Rs . < verification_template.html)
TEXT='"Please confirm your email address by clicking the button below"'  # optional fallback

cat > flow-verify.json <<JSON
{
  "TemplateName": "$TEMPLATE",
  "TemplateContent": {
    "Subject": "Flow Email Verification",
    "Text": $TEXT,
    "Html": $HTML
  }
}
JSON

# Create new:
# aws sesv2 update-email-template --region $REGION --cli-input-json file://flow-verify.json
# later updates:
aws sesv2 update-email-template --region $REGION --cli-input-json file://flow-verify.json
