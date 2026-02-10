# Log Monitoring Alarming Complete Example

This example demonstrates how to use the log monitoring alarming module to create a complete log monitoring and alarming solution.

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create real resources in your Alibaba Cloud account, which may incur charges.

## Notes

1. Make sure to provide a valid password for the `ecs_instance_password` variable. The password must be 8-30 characters and contain at least three of the following: uppercase letters, lowercase letters, numbers, and special characters.

2. After deployment, you can use the `ecs_login_address` output to access the ECS instances and view the generated logs using the command: `tail -f /tmp/sls-monitor-test.log`

3. Use the `sls_logsearch_url` output to access the SLS log search interface and query the collected logs.

4. This example creates resources that may incur charges. Make sure to clean up resources when they are no longer needed by running `terraform destroy`.