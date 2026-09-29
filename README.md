# env0-provider-qa-pr1148

Throwaway QA template for [terraform-provider-env0#1148](https://github.com/env0/terraform-provider-env0/pull/1148).
The custom flow builds the provider from the PR commit (`QA_PROVIDER_REF`) before `terraform init`,
then the config makes 3,000 reads over 3 method + path keys, so the 2,000/min client total is what binds.
Delete after QA.
