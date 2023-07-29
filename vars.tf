variable "myregion" {
description = "AWS Region Name"
}

variable "myaccesskey" {
description = "AWS IAM Access Key"
sensitive = true
}

variable "mysecretkey" {
description = "AWS IAM secret access Key"
sensitive = true
}

