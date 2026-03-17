#  Day-29 Lab

## Topic: Serverless API using AWS Lambda, API Gateway, CloudWatch Logging and S3 Event Triggered Lambda

---

#  Objective

In this lab we explored **AWS Serverless architecture** using:

* **AWS Lambda**
* **API Gateway**
* **Amazon S3**
* **Amazon CloudWatch**
* **Postman for API testing**

We implemented two main tasks:

1. **Serverless REST API using Lambda and API Gateway**
2. **S3 event-triggered Lambda function for automatic file renaming**

These tasks demonstrate how **event-driven serverless systems** work in AWS.

---

#  AWS Lambda

AWS **Lambda** is a serverless compute service that allows running code without managing servers.

Key features:

* Event-driven execution
* Automatic scaling
* Pay-per-execution model
* Integration with AWS services

Common triggers include:

| Trigger     | Example              |
| ----------- | -------------------- |
| API Gateway | Serverless REST APIs |
| S3          | File upload events   |
| CloudWatch  | Scheduled tasks      |
| DynamoDB    | Database updates     |

---

#  API Gateway

**API Gateway** allows developers to create, publish, maintain, and secure APIs.

Features:

* REST API creation
* Lambda integration
* Authentication
* Rate limiting
* CORS support

Flow:

```text id="qz9qeg"
Client → API Gateway → Lambda → Response
```

---

#  Amazon CloudWatch

CloudWatch is AWS monitoring and logging service.

It collects:

* Logs
* Metrics
* Events

Lambda automatically sends logs to **CloudWatch Logs**.

Example logs include:

* Incoming request data
* Lambda execution results
* Errors and exceptions

---

#  Task-1: Create a Serverless API using Lambda

---

# Architecture Overview

```text 
Client (Postman)
        │
        ▼
    API Gateway
        │
        ▼
      Lambda
        │
        ▼
   CloudWatch Logs
```

---

# Step-1: Create Lambda Function

Navigate to:

```text 
AWS Console → Lambda → Create Function
```

Configuration:

| Setting        | Value        |
| -------------- | ------------ |
| Runtime        | Python       |
| Execution Role | Default Role |

Function name example:

```text 
serverless-api-lambda
```

---

# Step-2: Add Lambda Function Code

Paste the following code into the Lambda editor.

```python 
import json
from datetime import datetime

def lambda_handler(event, context):

    # LOG every incoming request to CloudWatch
    print("===== INCOMING REQUEST =====")
    print("Timestamp     :", datetime.utcnow().isoformat())
    print("HTTP Method   :", event.get("httpMethod"))
    print("Path          :", event.get("path"))
    print("Query Params  :", json.dumps(event.get("queryStringParameters")))
    print("Headers       :", json.dumps(event.get("headers")))
    print("Body          :", event.get("body"))
    print("============================")

    # Parse body safely
    request_body = {}
    if event.get("body"):
        try:
            request_body = json.loads(event["body"])
        except Exception as e:
            print("Body parse error:", str(e))

    # Route based on HTTP method
    http_method = event.get("httpMethod", "")
    status_code  = 200

    if http_method == "GET":
        response_body = {
            "message"   : "GET request successful!",
            "query"     : event.get("queryStringParameters") or {},
            "timestamp" : datetime.utcnow().isoformat()
        }

    elif http_method == "POST":
        response_body = {
            "message"      : "POST request successful!",
            "receivedData" : request_body,
            "timestamp"    : datetime.utcnow().isoformat()
        }

    elif http_method == "PUT":
        response_body = {
            "message"     : "PUT request successful!",
            "updatedData" : request_body,
            "timestamp"   : datetime.utcnow().isoformat()
        }

    elif http_method == "DELETE":
        response_body = {
            "message"   : "DELETE request successful!",
            "timestamp" : datetime.utcnow().isoformat()
        }

    else:
        status_code   = 405
        response_body = { "error": "Method Not Allowed" }

    # Log the outgoing response
    print("===== OUTGOING RESPONSE =====")
    print("Status Code:", status_code)
    print("Response   :", json.dumps(response_body))
    print("=============================")

    return {
        "statusCode" : status_code,
        "headers"    : {
            "Content-Type"                : "application/json",
            "Access-Control-Allow-Origin" : "*"    # Enable CORS
        },
        "body" : json.dumps(response_body)
    }
```

This function:

* Logs requests to **CloudWatch**
* Handles **GET, POST, PUT, DELETE** methods
* Returns JSON responses

---

# Step-3: Create API Gateway

Navigate to:

```text
API Gateway → Create API → REST API
```

Create a resource and add methods:

| Method | Integration |
| ------ | ----------- |
| GET    | Lambda      |
| POST   | Lambda      |
| PUT    | Lambda      |
| DELETE | Lambda      |

Enable:

```text 
CORS
```

---

# Step-4: Deploy API

Deploy the API to a stage.

Example stage:

```text 
dev
```

Copy the **Invoke URL**.

Example:

```text 
https://abc123.execute-api.us-east-1.amazonaws.com/dev
```

---

# Step-5: Validate API using Postman

Create a **Postman collection**.

Test requests:

| Method | Example        |
| ------ | -------------- |
| GET    | /?name=test    |
| POST   | Send JSON body |
| PUT    | Update data    |
| DELETE | Delete request |

Example response:

```json 
{
 "message": "GET request successful!",
 "timestamp": "2026-03-12T10:20:30"
}
```

---

# Step-6: Check Logs in CloudWatch

Navigate to:

```text 
CloudWatch → Logs → Log Groups
```

Find Lambda log group.

Example:

```text
/aws/lambda/serverless-api-lambda
```

Logs include:

* Request details
* Headers
* Query parameters
* Response body

---

#  Task-2: S3 Event Triggered Lambda Function

---

# Architecture Overview

```text 
S3 Upload
    │
    ▼
Lambda Trigger
    │
    ▼
Rename File
    │
    ▼
CloudWatch Logs
```

---

# Step-1: Create S3 Bucket

Create a bucket with folders:

```text 
uploads/
renamed/
```

Example bucket name:

```text 
amzn-s3-bucket-1103
```

---

# Step-2: Create IAM Role for Lambda

Create a role with permissions for:

* S3 access
* CloudWatch logs

Add the following policy.

```json 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::amzn-s3-bucket-1103/*"
            ]
        },
        {
            "Sid": "Statement2",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::amzn-s3-bucket-1103/*"
            ]
        },
        {
            "Sid": "Statement3",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}

```

---

# Step-3: Create Lambda Function

Navigate to:

```text 
AWS Console → Lambda → Create Function
```

Configuration:

| Setting        | Value            |
| -------------- | ---------------- |
| Runtime        | Python           |
| Execution Role | Created IAM Role |

---

# Step-4: Add Lambda Code

Paste the provided Python code into the Lambda editor.
```python
import boto3
import urllib.parse
from datetime import datetime

s3 = boto3.client("s3")

def generate_new_filename(original_key):
    """Generate a new filename with timestamp, placed in renamed/ folder."""
    
    # Generate timestamp: 2026-03-12T10-30-00
    timestamp = datetime.utcnow().strftime("%Y-%m-%dT%H-%M-%S")
    
    # Extract just the filename (strip folder prefix like uploads/)
    filename = original_key.split("/")[-1]
    
    # Split name and extension
    if "." in filename:
        name, ext = filename.rsplit(".", 1)
        ext = f".{ext}"
    else:
        name = filename
        ext  = ""
    
    # Final format: renamed/originalName_TIMESTAMP.ext
    # Example: uploads/invoice.pdf → renamed/invoice_2026-03-12T10-30-00.pdf
    return f"renamed/{name}_{timestamp}{ext}"


def lambda_handler(event, context):
    
    print("====== S3 EVENT RECEIVED ======")
    print(f"Full Event: {event}")
    
    for record in event["Records"]:
        
        bucket_name = record["s3"]["bucket"]["name"]
        source_key  = urllib.parse.unquote_plus(record["s3"]["object"]["key"])
        file_size   = record["s3"]["object"]["size"]
        event_time  = record["eventTime"]
        
        # Safety check — only process files in uploads/ folder
        if not source_key.startswith("uploads/"):
            print(f"Skipping '{source_key}' — not in uploads/ folder")
            continue
        
        new_key = generate_new_filename(source_key)
        
        print("------ Processing File ------")
        print(f"Bucket      : {bucket_name}")
        print(f"Source Key  : {source_key}")
        print(f"File Size   : {file_size} bytes")
        print(f"Event Time  : {event_time}")
        print(f"New Key     : {new_key}")
        
        # ── STEP 1: Copy file to renamed/ folder with new name ──────────
        try:
            copy_source = {
                "Bucket" : bucket_name,
                "Key"    : source_key
            }
            
            copy_result = s3.copy_object(
                CopySource        = copy_source,
                Bucket            = bucket_name,   # Same bucket!
                Key               = new_key,
                MetadataDirective = "COPY"
            )
            
            etag = copy_result["CopyObjectResult"]["ETag"]
            print(f"COPY successful — ETag: {etag}")
            print(f"DONE: '{source_key}' → '{new_key}'")
            
        except s3.exceptions.NoSuchKey:
            print(f"COPY FAILED — File not found: {source_key}")
            raise
            
        except Exception as e:
            print(f"COPY FAILED: {type(e).__name__} - {str(e)}")
            raise
    
    print("====== ALL FILES PROCESSED ======")
    return { "status": "success" }


 ```

The function performs:

* Detect file upload
* Generate timestamp
* Rename file
* Copy file to renamed folder

---

# Step-5: Configure Lambda Trigger

Add trigger:

```text 
S3 → uploads/ folder
```

Event type:

```text id="yfxjv7"
ObjectCreated
```

Now Lambda will run whenever a file is uploaded.

---

# Step-6: Test the Workflow

Upload a file to:

```text 
uploads/
```

Example file:

```text 
invoice.pdf
```

Lambda will create:

```text 
renamed/invoice_2026-03-12T10-30-00.pdf
```

---

# Step-7: Verify Logs

Navigate to:

```text 
CloudWatch → Logs
```

Check execution logs for:

* Event details
* File name
* Rename confirmation

---
![alt text](<Screenshot (237)-1.png>) ![alt text](<Screenshot (245)-1.png>) ![alt text](<Screenshot (244)-1.png>) ![alt text](<Screenshot (243)-1.png>) ![alt text](<Screenshot (242)-1.png>) ![alt text](<Screenshot (241)-1.png>) ![alt text](<Screenshot (240)-1.png>) ![alt text](<Screenshot (239)-1.png>) ![alt text](<Screenshot (238)-1.png>)