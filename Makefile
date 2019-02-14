Profile?=aws-demo-pierre
InfraBucket?=continuous-demo-oswald-aws-ephemeral-infra
PackageBucket?=cphp-oswald-codedeploy-packages
BaseDomain?=oswald.continuous.team
StackName?=continuous-demo-ephemeral-infra-$(PrId)
KeyPair?=continuousdemo-eu-west-1
AmiId?=ami-08596fdd2d5b64915

main.template: stacks/*.yml
	aws --profile $(Profile) \
	  cloudformation package \
		--template-file stacks/main.yml \
		--s3-bucket $(InfraBucket) \
		--s3-prefix stacks \
		--output-template-file main.template

deploy: main.template
	aws --profile $(Profile) \
	  cloudformation deploy \
		--template-file main.template \
		--capabilities CAPABILITY_NAMED_IAM \
		--stack-name $(StackName) \
		--parameter-overrides \
		  BaseDomain=$(BaseDomain) \
		  PrId=$(PrId) \
		  KeyPair=$(KeyPair) \
		  DeployPackagesBucket=$(PackageBucket) \
		  AmiId=$(AmiId)
