variable "env" {
  type = string
  default = "qa"
}

variable "app" {
  type = string
  default = "App-name"
}

variable "sns_subscription_email_address_list" {
   type = list(string)
   default = ["rsaditya.aketi@gmail.com","ars.aditya63@gmail.com"]
   description = "List of email addresses"
 }

 variable "sns_subscription_protocol" {
   type = string
   default = "email"
   description = "SNS subscription protocal"
 }

 variable "sns_topic_name" {
   type = string
   description = "SNS topic name"
   default = "metric-sns"
 }

 variable "sns_topic_display_name" {
   type = string
   description = "SNS topic display name"
   default = "metric-sns"
 }


