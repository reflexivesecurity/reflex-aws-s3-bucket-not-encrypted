# reflex-aws-enforce-s3-encryption
A Reflex rule for enforcing AES256 bucket encryption in S3 buckets.

To learn more about S3 Bucket encryption, see [the AWS Documentation](https://docs.aws.amazon.com/AmazonS3/latest/dev/serv-side-encryption.html).

## Getting Started
To get started using Reflex, check out [the Reflex Documentation](https://docs.cloudmitigator.com/).

## Usage
To use this rule either add it to your `reflex.yaml` configuration file:  
```
rules:
  aws:
    - enforce-s3-encryption:
        configuration:
          mode: remediate
        version: latest
```

or add it directly to your Terraform:  
```
module "enforce-s3-encryption" {
  source            = "git::https://github.com/cloudmitigator/reflex-aws-enforce-s3-encryption.git?ref=latest"
  sns_topic_arn     = module.central-sns-topic.arn
  reflex_kms_key_id = module.reflex-kms-key.key_id
  mode              = "remediate"
}
```

Note: The `sns_topic_arn` and `reflex_kms_key_id` example values shown here assume you generated resources with `reflex build`. If you are using the Terraform on its own you need to provide your own valid values.

## Configuration
This rule has the following configuration options:

<dl>
  <dt>mode</dt>
  <dd>
  <p>Sets the rule to operate in <code>detect</code> or <code>remediate</code> mode.</p>

  <em>Required</em>: No  

  <em>Type</em>: string

  <em>Possible values</em>: `detect` | `remediate`  

  <em>Default</em>: `detect`
  </dd>
</dl>

## Contributing
If you are interested in contributing, please review [our contribution guide](https://docs.cloudmitigator.com/about/contributing.html).

## License
This Reflex rule is made available under the MPL 2.0 license. For more information view the [LICENSE](https://github.com/cloudmitigator/reflex-aws-enforce-s3-encryption/blob/master/LICENSE).
