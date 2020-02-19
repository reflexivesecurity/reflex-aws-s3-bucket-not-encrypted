# reflex-aws-enforce-s3-encryption
A Reflex rule for enforcing AES256 bucket encryption in all S3 buckets.

## Usage
To use this rule either add it to your `reflex.yaml` configuration file:  
```
version: 0.1

providers:
  - aws

measures:
  - reflex-aws-enforce-s3-encryption:
      email: "example@example.com"
```

or add it directly to your Terraform:  
```
...

module "enforce-s3-encryption" {
  source           = "github.com/cloudmitigator/reflex-aws-enforce-s3-encryption"
  email            = "example@example.com"
}

...
```

## License
This Reflex rule is made available under the MPL 2.0 license. For more information view the [LICENSE](https://github.com/cloudmitigator/reflex-aws-enforce-s3-encryption/blob/master/LICENSE) 
