# Single-account-pipeline

Example repository demonstrating a pipeline within a single account using CodeBuild, CodePipeline and CodeArtifact.

## What's in the box?

The repository consists of two NodeJS projects, and a single CICD pipeline to simulate:
* A main source project (`project/`) with a dependency on a shared library (`project_dependency`)
* CICD toolchain for the main project

This is to simulate a situation where you have internal shared libraries, but the shared library does not have a managed CICD toolchain.


* `cloudformation/` - CFN templates to configure the AWS infrastructure
* `project/` - A NodeJS project, depends on the `project_dependency` shared library.
* `project_dependency/` - A NodeJS 'shared library', that shall be uploaded to CodeArtifact separately.

## Setup

Pre-requisites:
* `bash` command line
* AWS CLI installed
* [AWS CLI credentials configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
* [`cfn-lint`](https://github.com/aws-cloudformation/cfn-python-lint)


Deploy the infrastructure:
```
./deploy.sh
```

Kick off the pipeline:
```
./upload-to-s3.sh
```

## Taking it for a spin

We shall:
* deploy the infrastructure
* Kick off the pipeline and watch it fail.
* Upload our 'external dependency' to CodeArtifact (`project_dependency/`)
* Kick off the pipeline again and watch it pass

Deploy the infrastructure:
```
./deploy.sh
./upload-to-s3.sh
```

Login to the AWS console, The CodePipeline `single-account-pipeline-pipeline` should exist, and the `Deploy` step should fail.

Upload our external dependency:
```
./scripts/login.sh
cd project_dependency
npm install
npm publish
```

Trigger our pipeline again, and it should now pass:
```
./upload-to-s3.sh
```

## Notes / Limitations

* `./scripts/login.sh` performs `npm login` into your CodeArtifact with temporary credentials.  These are added into your `~/.npmrc`:
```
registry=https://artifacts-temyers-01234567890.d.codeartifact.ap-southeast-2.amazonaws.com/npm/DefaultCodeArtifactRepository-01234567890/
//artifacts-temyers-01234567890.d.codeartifact.ap-southeast-2.amazonaws.com/npm/DefaultCodeArtifactRepository-01234567890/:always-auth=true
//artifacts-temyers-01234567890.d.codeartifact.ap-southeast-2.amazonaws.com/npm/DefaultCodeArtifactRepository-01234567890/:_authToken=THIS_IS_AN_EXAMPLE_TEMPORARY_AUTH_TOKEN.yevT0ScPWBje9jbNcUmSPw.GUUhGXkJPwFUZib8...
``` 
  * The temporary credentials will expire, meaning you shall need to re-login.
  * Pulling dependencies from CodeArtifact, rather than NPM directly will incur data charges - remove the authentication credentials to revert to pulling from your normal artifact repository
* CodeArtifact disallows overwriting the same version.  This example does not change the version.  Your build will pass once.  If you do not update the version, subsequent builds shall fail.