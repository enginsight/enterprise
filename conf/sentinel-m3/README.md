# Sentinel Configuration 

For the Sentinel module, a config file is needed with the following information:

## General Information:

| Property | Description |
|--|--|
| loopDelay | Delay between the checks for alerts in milliseconds.|
| initialDelay | Delay between the initialization process and the checks for alerts in milliseconds. |
|uriConnectionString|URI Connection string to MongoDB.|
|cache|URI Connection string to Redis.|
|app.host|URL of your application.|



## Email information:

All information is required by the email Module to send alerts and notifications that are detected by the Sentinel module.

| Property | Description |
|--|--|
|host|Host of your email server.|
|port|Port of communication between the mailing module and the email server.|
|sslTls|Boolean value to enable/disable a secure connection.|
|user|Username to login to your SMTP server.|
|pass|Password to login to your SMTP server.|
|maxConnections|Limit of simultaneous connections to make against the SMTP server (defaults to 5).|
|rateDelta|Defines the time measuring period in milliseconds for rate limiting.|
|rateLimit|Limits the amount of emails sent within rateDelta.|


## SMS information

All information is required by the sms Module to send alerts and notifications that are detected by the Sentinel module.

| Property | Description |
|--|--|
|limit|Limit of sms sent to one user within a month.|
|region|Region of the AWS SNS server, e.g. "eu-west".|
|accessKeyId|Public Access key for the AWS SNS login.|
|secretAccessKey|Secret access key for the AWS SNS login.|


For the format of the config file check config.json