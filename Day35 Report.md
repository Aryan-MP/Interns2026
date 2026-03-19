# Internship Daily Report — Day 34

**Date:** March 19, 2026
**Domain:** Cloud / DevOps (AWS)
**Focus Area:** AWS CloudFormation Nested Stacks — Full Application Infrastructure
**Status:** ✅ Successfully Deployed and Verified

---

## Overview

Today's task was to design, build, debug, and deploy a complete production-grade AWS infrastructure using **CloudFormation Nested Stacks**. A single parent template orchestrates four child stacks — Network, ALB, Compute, and Data — each responsible for a separate layer of the architecture. The entire environment supports a scalable Nginx web application backed by an S3 static website bucket.

By end of day, all 5 stacks (1 parent + 4 nested) reached `CREATE_COMPLETE` status and both the Nginx site and S3 static website were verified live in the browser.

---

## Final Deployment Result — All Stacks CREATE_COMPLETE

> **Screenshot 7 — All 5 stacks in CREATE_COMPLETE state**
> CloudFormation console showing all nested stacks listed with green CREATE_COMPLETE status:
> - `applo` (parent) — CREATE_COMPLETE at 16:46:32 UTC+0530
> - `applo-NetworkStack-JCJ6LXVSLVOA` — CREATE_COMPLETE at 16:46:34
> - `applo-ALBStack-BV8BNUB3QDA2` — CREATE_COMPLETE at 16:49:13
> - `applo-ComputeStack-1ANJKM1R6OCL6` — CREATE_COMPLETE at 16:51:28
> - `applo-DataStack-1R1IL7OYBLYG` — CREATE_COMPLETE at 16:55:31

---

## What is a Nested Stack?

Instead of writing one giant CloudFormation template, the infrastructure is broken into focused child templates. The parent template (`parent-stack.yaml`) acts as an orchestrator — it deploys each child in the correct order and passes values between them using **Exports and Imports** (`Export` / `Fn::ImportValue`).

**Deploy order enforced by `DependsOn`:**
```
Network → ALB → Compute → Data
```

**Architecture:**
```
Internet
    │
    ▼
ALB (public subnets, AZ-a + AZ-b)
    │
    ▼
Nginx EC2 instances via ASG (private subnets, AZ-a + AZ-b)
    │
    ▼
S3 Static Website Bucket (Data Stack)
```

---

## Files Created

| File | Purpose |
|---|---|
| `parent-stack.yaml` | Orchestrates all 4 child stacks |
| `network-stack.yaml` | VPC, subnets, IGW, NAT GW, route tables, security groups |
| `alb-stack.yaml` | Application Load Balancer, target group, listeners, health checks |
| `compute-stack.yaml` | IAM role, launch template, auto scaling group, Nginx UserData |
| `data-stack.yaml` | S3 static website bucket, public read bucket policy |

---

## Deployment Timeline Screenshots

### Screenshot 1 — First Deployment Attempt (with failures)
The first deployment attempt of stack `mystack` showing the timeline with a rollback. NetworkStack and ALBStack completed (green) but ComputeStack and DataStack had issues. The gray bars represent "Rollback in progress" and "Rollback complete" states. This was the learning phase where errors were debugged.

**Timeline observed:**
- `NetworkStack` — deployed first, completed ~15:26
- `ALBStack` — deployed second, completed ~15:29
- `ComputeStack` — deployed third, ran until ~15:34 then rolled back
- `DataStack` — failed early due to `EC2RoleBucketPolicy` circular dependency

### Screenshot 2 — Second Deployment (stack: `applo`) — All Complete
Final successful deployment of stack `applo` showing all 4 child stacks completing in the correct order with no failures. The timeline clearly shows:
- `NetworkStack` finishes first (blue bar ends with green ~16:49)
- `ALBStack` starts after Network completes (~16:49 to 16:52)
- `ComputeStack` starts after ALB (~16:52 to 16:55)
- `DataStack` starts last (~16:55 to 16:56)

All bars end in green = `Complete`. No red (failed) or gray (rollback) bars.

---

## Stack 1 — Network Stack

### Screenshot 3 — Network Stack Resources Timeline
Showing `applo-NetworkStack-JCJ6LXVSLVOA` deployment timeline with every individual resource that was created in order:

| Resource | What it is |
|---|---|
| VPC | The Virtual Private Cloud `10.0.0.0/16` |
| InternetGateway | Door to the internet |
| PrivateRouteTable | Routes private subnet traffic via NAT |
| ALBSecurityGroup | Firewall for ALB — port 80/443 open |
| PublicSubnet1 | `10.0.1.0/24` AZ-a for ALB |
| PublicSubnet2 | `10.0.2.0/24` AZ-b for ALB |
| PrivateSubnet1 | `10.0.10.0/24` AZ-a for EC2 |
| PrivateSubnet2 | `10.0.11.0/24` AZ-b for EC2 |
| InternetGatewayAttachment | Connects IGW to VPC |
| NatGatewayEIP | Elastic IP for NAT Gateway |
| EC2SecurityGroup | Firewall for EC2 — only from ALB |
| PublicRouteTable | Routes public subnet traffic via IGW |
| DefaultPublicRoute | `0.0.0.0/0 → IGW` |
| PublicSubnet1RouteTableAssociation | Links public subnet 1 to public RT |
| PublicSubnet2RouteTableAssociation | Links public subnet 2 to public RT |
| PrivateSubnet1RouteTableAssociation | Links private subnet 1 to private RT |
| PrivateSubnet2RouteTableAssociation | Links private subnet 2 to private RT |
| NatGateway | Allows private EC2 outbound internet |
| DefaultPrivateRoute | `0.0.0.0/0 → NAT GW` |

Note: NatGateway takes the longest (the long blue bar) because AWS needs to provision the Elastic IP and associate it.

**Key design decisions:**
- Used `!Select [0, !GetAZs ""]` for dynamic AZ selection — works in any AWS region without hardcoding
- EC2 SG references ALB SG as source (not a CIDR) — instances only reachable through ALB

**Exports:** `VpcId`, `PublicSubnet1Id`, `PublicSubnet2Id`, `PrivateSubnet1Id`, `PrivateSubnet2Id`, `ALBSecurityGroupId`, `EC2SecurityGroupId`

---

## Stack 2 — ALB Stack

### Screenshot 4 — ALB Stack Resources Timeline
Showing `applo-ALBStack-BV8BNUB3QDA2` deployment timeline with 3 resources:

| Resource | What it is |
|---|---|
| NginxTargetGroup | Group of EC2 instances ALB routes to |
| ApplicationLoadBalancer | The internet-facing ALB (takes longest — AWS provisions nodes in both AZs) |
| HTTPListener | Port 80 listener that forwards to target group |

The `ApplicationLoadBalancer` takes the most time (long blue bar) because AWS needs to provision ALB nodes in both public subnets simultaneously.

**Key resources:**

| Resource | Detail |
|---|---|
| Application Load Balancer | `internet-facing`, in Public Subnet 1 + 2 |
| Target Group | Protocol HTTP port 80, `least_outstanding_requests` algorithm |
| Health Check | `GET /` every 30s, 2 healthy / 3 unhealthy threshold, HTTP 200 |
| HTTP Listener | Port 80 — forwards to target group |
| HTTPS Listener | Only created if `CertificateArn` parameter passed (not used today) |

**Condition used:**
```yaml
Conditions:
  HasCertificate:
    !Not [!Equals [!Ref CertificateArn, ""]]
```

**HTTPS status:** HTTP only today — no certificate. ALB Security Group allows 443 but no HTTPS listener exists. Options to enable HTTPS: pass ACM certificate ARN, or add CloudFront in front for free `*.cloudfront.net` HTTPS.

### Screenshot 9 — ALB Stack Outputs
ALB Stack Outputs tab showing 5 exported values:

| Output Key | Value |
|---|---|
| ALBArn | `arn:aws:elasticloadbalancing:us-east-1:...prod-alb/...` |
| ALBDnsName | `prod-alb-1960325760.us-east-1.elb.amazonaws.com` |
| ALBHostedZoneId | `Z35SXDOTRQ7X7K` |
| ALBTargetGroupArn | `arn:aws:elasticloadbalancing:us-east-1:...prod-nginx-tg/...` |
| HTTPListenerArn | `arn:aws:elasticloadbalancing:us-east-1:...listener/app/prod-alb/...` |

**Exports:** `ALBTargetGroupArn` (consumed by Compute Stack ASG), `ALBDnsName`, `ALBHostedZoneId`

---

## Stack 3 — Compute Stack

### Screenshot 5 — Compute Stack Resources Timeline
Showing `applo-ComputeStack-1ANJKM1R6OCL6` deployment timeline with 5 resources:

| Resource | What it is |
|---|---|
| EC2InstanceRole | IAM Role with SSM + S3 + CloudWatch permissions |
| EC2InstanceProfile | Wrapper around IAM Role so EC2 can assume it |
| NginxLaunchTemplate | Blueprint for every EC2 instance (AMI, type, SG, UserData) |
| AutoScalingGroup | Fleet manager — keeps 2 instances running, scales on CPU |
| CPUScalingPolicy | Target tracking at 60% avg CPU — auto scale in/out |

The `EC2InstanceProfile` takes longest because it must wait for `EC2InstanceRole` to be fully created and propagated through IAM before the profile can be attached. The `AutoScalingGroup` then waits for `cfn-signal` from both EC2 instances before marking complete.

### IAM Role

```yaml
EC2InstanceRole:
  Type: AWS::IAM::Role
  Properties:
    RoleName: !Sub "${EnvironmentName}-ec2-instance-role"
    AssumeRolePolicyDocument:
      Statement:
        - Effect: Allow
          Principal:
            Service: ec2.amazonaws.com
          Action: sts:AssumeRole
    ManagedPolicyArns:
      - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
      - arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
    Policies:
      - PolicyName: s3-read-policy
        PolicyDocument:
          Statement:
            - Effect: Allow
              Action:
                - s3:GetObject
                - s3:PutObject
                - s3:DeleteObject
                - s3:ListBucket
              Resource:
                - !Sub "arn:aws:s3:::${EnvironmentName}-static-website-${AWS::AccountId}"
                - !Sub "arn:aws:s3:::${EnvironmentName}-static-website-${AWS::AccountId}/*"
```

- `AmazonSSMManagedInstanceCore` — AWS Session Manager terminal access (no SSH, no key pair, no port 22)
- `CloudWatchAgentServerPolicy` — push metrics and logs to CloudWatch
- Custom inline policy — read/write the S3 static website bucket

### Launch Template

```yaml
NginxLaunchTemplate:
  Type: AWS::EC2::LaunchTemplate
  Properties:
    LaunchTemplateData:
      ImageId: !Ref AmiId          # Amazon Linux 2, auto-resolved from SSM Parameter Store
      InstanceType: !Ref InstanceType
      IamInstanceProfile:
        Arn: !GetAtt EC2InstanceProfile.Arn
      SecurityGroupIds:
        - Fn::ImportValue: !Sub "${EnvironmentName}-EC2SecurityGroupId"
      MetadataOptions:
        HttpTokens: required       # IMDSv2 enforced — prevents SSRF attacks
        HttpPutResponseHopLimit: 1
        HttpEndpoint: enabled
```

### UserData Script (Full — with line-by-line explanation)

The UserData script runs automatically on first boot as root. It is wrapped in `Fn::Base64: !Sub` so CloudFormation substitutes `${AWS::StackName}` and `${AWS::Region}` before the instance receives it.

```bash
#!/bin/bash
set -euo pipefail
# set -e  → stop script immediately if any command fails (exit code != 0)
# set -u  → treat unset variables as errors — prevents silent bugs
# set -o pipefail → fail if any command in a pipe fails, not just the last one
# Without this line, a failed yum install would silently continue

# ── Step 1: Update all OS packages ──────────────────────────────────────────
# Downloads and installs all latest security patches on Amazon Linux 2
# -y flag auto-confirms all prompts so the script runs non-interactively
# Important: the AMI snapshot may be weeks old — patches needed on first boot
yum update -y

# ── Step 2: Enable Nginx from amazon-linux-extras ───────────────────────────
# Nginx is NOT in the default yum repo on Amazon Linux 2
# It lives in the amazon-linux-extras repository
# Must run 'enable' first, then 'install' — skipping enable = "package not found"
amazon-linux-extras enable nginx1
yum install -y nginx

# ── Step 3: Enable and start Nginx ──────────────────────────────────────────
# systemctl enable → registers nginx to AUTO-START on every future reboot
# systemctl start  → starts nginx RIGHT NOW in this boot session
# Both lines are needed:
#   - Only 'start' → nginx dies after next reboot, ALB health checks fail
#   - Only 'enable' → nginx doesn't start now, port 80 is dead until reboot
systemctl enable nginx
systemctl start nginx

# ── Step 4: Enable and start SSM Agent ──────────────────────────────────────
# SSM Agent pre-installed on AL2 but may not be running
# Required for AWS Session Manager — our only way to get terminal access
# (no SSH port 22 is open, no key pair attached to the instance)
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# ── Step 5: Write custom Nginx landing page ──────────────────────────────────
# 'cat >' overwrites the default index.html in Nginx's document root
# '<<HTMLEOF' is a heredoc — writes multi-line content into the file
# /usr/share/nginx/html/ is Nginx's default web root on Amazon Linux 2
# ${EnvironmentName} and ${AWS::Region} are substituted by CloudFormation
# BEFORE the script reaches the instance, via the !Sub wrapper in the template
cat > /usr/share/nginx/html/index.html <<'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Nginx | ${EnvironmentName}</title>
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      font-family: 'Segoe UI', system-ui, sans-serif;
      background: #0f172a; color: #e2e8f0;
      min-height: 100vh; display: flex;
      align-items: center; justify-content: center;
    }
    .card {
      background: #1e293b; border: 1px solid #334155;
      border-radius: 16px; padding: 48px 56px;
      text-align: center; max-width: 520px;
    }
    .badge {
      display: inline-block; background: #0f4c81;
      color: #7dd3fc; font-size: 12px; font-weight: 700;
      letter-spacing: 2px; text-transform: uppercase;
      padding: 4px 14px; border-radius: 999px; margin-bottom: 24px;
    }
    h1 { font-size: 2rem; font-weight: 800; margin-bottom: 12px; }
    .grid {
      display: grid; grid-template-columns: 1fr 1fr;
      gap: 12px; margin-top: 24px; text-align: left;
    }
    .item { background: #0f172a; border-radius: 10px; padding: 14px 16px; }
    .label { font-size: 11px; color: #64748b; text-transform: uppercase;
             letter-spacing: 1px; }
    .value { font-size: 14px; font-weight: 600; color: #38bdf8; margin-top: 4px; }
  </style>
</head>
<body>
  <div class="card">
    <div class="badge">&#x2705; HEALTHY</div>
    <h1>Nginx is Running</h1>
    <div class="grid">
      <div class="item">
        <div class="label">Environment</div>
        <div class="value">${EnvironmentName}</div>
      </div>
      <div class="item">
        <div class="label">Server</div>
        <div class="value">Nginx</div>
      </div>
      <div class="item">
        <div class="label">Region</div>
        <div class="value">${AWS::Region}</div>
      </div>
      <div class="item">
        <div class="label">Managed by</div>
        <div class="value">Auto Scaling</div>
      </div>
    </div>
  </div>
</body>
</html>
HTMLEOF

# ── Step 6: Signal CloudFormation that this instance is ready ────────────────
# cfn-signal tells CloudFormation "this instance finished bootstrapping"
# The CreationPolicy on AutoScalingGroup waits for signals from ALL instances
# before marking the stack CREATE_COMPLETE
#
# Without cfn-signal:
#   CloudFormation marks stack COMPLETE even if Nginx failed to install
#   ALB health checks fail, instances get terminated and replaced in a loop
#
# $?  = exit code of the previous command (0 = success, non-zero = failure)
# set -e already stopped the script if anything above failed,
# so by this point $? is always 0
#
# ${AWS::StackName} and ${AWS::Region} are substituted by !Sub in the template
/opt/aws/bin/cfn-signal \
  --exit-code $? \
  --stack  ${AWS::StackName} \
  --resource AutoScalingGroup \
  --region ${AWS::Region}
```

**How UserData flows from template to EC2 instance:**

```
Template (YAML)              CloudFormation              EC2 Instance
─────────────────────        ──────────────────          ──────────────────
Fn::Base64: !Sub |     →    !Sub substitutes:     →    Base64 decoded to
  #!/bin/bash                ${AWS::StackName}           plain bash script
  ...                        = "applo"                   stored at:
  cfn-signal \               ${AWS::Region}              /user-data
    --stack                  = "us-east-1"               runs ONCE on first
    ${AWS::StackName}        then Base64 encodes         boot via cloud-init
                             the entire script           as root user
```

### Auto Scaling Group

```yaml
AutoScalingGroup:
  Type: AWS::AutoScaling::AutoScalingGroup
  Properties:
    MinSize: 1
    MaxSize: 4
    DesiredCapacity: 2
    VPCZoneIdentifier:
      - !ImportValue PrivateSubnet1Id    # EC2 instances in private subnets only
      - !ImportValue PrivateSubnet2Id    # not directly reachable from internet
    TargetGroupARNs:
      - !ImportValue ALBTargetGroupArn   # auto-registers instances with ALB
    HealthCheckType: ELB                 # trusts ALB health checks over EC2 checks
    HealthCheckGracePeriod: 120          # wait 2 min before first health check
  CreationPolicy:
    ResourceSignal:
      Count: 2          # wait for BOTH instances to run cfn-signal
      Timeout: PT15M    # fail stack if not signalled within 15 minutes
  UpdatePolicy:
    AutoScalingRollingUpdate:
      MinInstancesInService: 1    # keep 1 instance live during updates
      MaxBatchSize: 1             # replace 1 instance at a time (zero downtime)
      WaitOnResourceSignals: true
```

### CPU Scaling Policy

```yaml
CPUScalingPolicy:
  Type: AWS::AutoScaling::ScalingPolicy
  Properties:
    PolicyType: TargetTrackingScaling
    TargetTrackingConfiguration:
      PredefinedMetricType: ASGAverageCPUUtilization
      TargetValue: 60.0
      # AWS automatically adds instances when avg CPU > 60%
      # AWS automatically removes instances when avg CPU well below 60%
      # No manual scale-in/scale-out rules needed
```

**Exports:** `EC2RoleArn`, `ASGName`, `LaunchTemplateId`

---

## Stack 4 — Data Stack

### Screenshot 6 — Data Stack Resources Timeline
Showing `applo-DataStack-1R1IL7OYBLYG` deployment timeline with 2 resources:

| Resource | What it is |
|---|---|
| StaticWebsiteBucket | S3 bucket for static website — takes longest (versioning, encryption, lifecycle config) |
| PublicReadBucketPolicy | Bucket policy allowing public `s3:GetObject` |

### Screenshot 10 — Data Stack Outputs
Data Stack Outputs tab showing 4 exported values:

| Output Key | Value |
|---|---|
| BucketArn | `arn:aws:s3:::prod-static-19-03-2026-website-595842667987` |
| BucketDomainName | `prod-static-19-03-2026-website-595842667987.s3.us-east-1.amazonaws.com` |
| BucketName | `prod-static-19-03-2026-website-595842667987` |
| WebsiteURL | `http://prod-static-19-03-2026-website-595842667987.s3-website-us-east-1.amazonaws.com` |

**Key design decisions:**

```yaml
# AccountId in bucket name — S3 names are globally unique across ALL AWS accounts
BucketName: !Sub "${EnvironmentName}-static-website-${AWS::AccountId}"

# Never delete the bucket even if the stack is deleted
DeletionPolicy: Retain
UpdateReplacePolicy: Retain

# Versioning condition — NoncurrentVersionExpiration only valid when Enabled
LifecycleConfiguration:
  Rules:
    - !If
      - VersioningEnabled
      - Id: ExpireOldVersions
        Status: Enabled
        NoncurrentVersionExpiration:
          NoncurrentDays: 90
      - !Ref AWS::NoValue    # removes the rule entirely when Suspended
```

**Only policy kept (EC2RoleBucketPolicy removed — see errors section):**
```yaml
PublicReadBucketPolicy:
  Type: AWS::S3::BucketPolicy
  Properties:
    Bucket: !Ref StaticWebsiteBucket
    PolicyDocument:
      Statement:
        - Sid: PublicReadGetObject
          Effect: Allow
          Principal: "*"
          Action: s3:GetObject
          Resource: !Sub "${StaticWebsiteBucket.Arn}/*"
```

---

## Live Verification Screenshots

### Screenshot 8 — Nginx Site Live in Browser ✅
URL: `http://prod-alb-1960325760.us-east-1.elb.amazonaws.com`

The custom Nginx landing page deployed via UserData is visible showing:
- **HEALTHY** badge (green)
- **Nginx is Running** heading
- Environment: `prod`
- Server: `Nginx`
- Region: `us-east-1`
- Managed by: `Auto Scaling`

This confirms the full traffic path works: Internet → ALB → Target Group → EC2 (private subnet) → Nginx → response back to browser.

### Screenshot 11 — S3 Static Website Live in Browser ✅
URL: `http://prod-static-19-03-2026-website-595842667987.s3-website-us-east-1.amazonaws.com`

The S3 static website is publicly accessible showing:
- **Hello World!**
- "This is my first static website."
- About Us link

This confirms the S3 bucket is correctly configured for static website hosting with the `PublicReadBucketPolicy` allowing public access.

---

## Errors Faced & Fixed Today

### Error 1 — `Template format error: At least one Resources member must be defined`

**Cause:** Deployed `parent-stack.yaml` before uploading child templates to S3. CloudFormation fetches each `TemplateURL` during validation — if S3 files don't exist, the parent appears to have no valid resources.

**Fix:** Always upload child templates to S3 first, then deploy the parent.

```bash
# Step 1 — Upload all child templates to S3 FIRST
aws s3 cp network-stack.yaml  s3://my-cfn-templates-bucket/templates/network-stack.yaml
aws s3 cp alb-stack.yaml      s3://my-cfn-templates-bucket/templates/alb-stack.yaml
aws s3 cp compute-stack.yaml  s3://my-cfn-templates-bucket/templates/compute-stack.yaml
aws s3 cp data-stack.yaml     s3://my-cfn-templates-bucket/templates/data-stack.yaml

# Step 2 — Deploy parent AFTER all files are in S3
aws cloudformation deploy \
  --template-file parent-stack.yaml \
  --stack-name applo \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      EnvironmentName=prod \
      TemplatesBucketName=my-cfn-templates-bucket
```

### Error 2 — `StaticWebsiteBucket CREATE_FAILED` (S3 bucket name globally taken)

**Error message:**
```
The following resource(s) failed to create: [StaticWebsiteBucket]
```

**Cause:** `BucketName: prod-static-website` was already taken by another AWS account. S3 bucket names are globally unique across every account in the world.

**Fix:** Append `${AWS::AccountId}` to guarantee uniqueness:

```yaml
# Before — almost certainly taken
BucketName: !Sub "${EnvironmentName}-static-website"

# After — AccountId guarantees global uniqueness
BucketName: !Sub "${EnvironmentName}-static-website-${AWS::AccountId}"
```

### Error 3 — `EC2RoleBucketPolicy CREATE_FAILED` (circular dependency)

**Error message:**
```
Embedded stack was not successfully created:
The following resource(s) failed to create: [EC2RoleBucketPolicy]
```

**Cause:** `EC2RoleBucketPolicy` in the Data Stack used `Fn::ImportValue` to reference `EC2RoleArn` exported by the Compute Stack. But Data Stack deploys before Compute Stack — the export simply didn't exist yet when Data Stack tried to use it. This is a circular dependency — Data needs Compute's export, but Compute deploys after Data.

**Root cause diagram:**
```
Data Stack deploys FIRST
  └─ EC2RoleBucketPolicy
       └─ Fn::ImportValue: EC2RoleArn   ← DOESN'T EXIST YET
                                           Compute Stack hasn't deployed
```

**Fix:** Remove `EC2RoleBucketPolicy` entirely. EC2 instances access S3 through their IAM Role (defined in Compute Stack) — the bucket policy is redundant and was the sole cause of the failure.

```yaml
# REMOVED — caused circular dependency error
EC2RoleBucketPolicy:
  Type: AWS::S3::BucketPolicy
  Properties:
    PolicyDocument:
      Statement:
        - Principal:
            AWS:
              Fn::ImportValue: !Sub "${EnvironmentName}-EC2RoleArn"  # ← didn't exist yet
          Action: [s3:GetObject, s3:PutObject, s3:DeleteObject, s3:ListBucket]
```

The IAM Role policy in `compute-stack.yaml` already grants the necessary S3 permissions — no bucket policy needed for EC2 access.

### Error 4 — `NoncurrentVersionExpiration` lifecycle rule failure

**Cause:** `NoncurrentVersionExpiration` is only a valid lifecycle rule when `VersioningConfiguration.Status = Enabled`. When versioning is `Suspended`, the rule is invalid.

**Fix:** Wrapped in a condition using `!Ref AWS::NoValue` to remove the rule when not needed:

```yaml
Conditions:
  VersioningEnabled:
    !Equals [!Ref EnableVersioning, "Enabled"]

LifecycleConfiguration:
  Rules:
    - !If
      - VersioningEnabled
      - Id: ExpireOldVersions
        Status: Enabled
        NoncurrentVersionExpiration:
          NoncurrentDays: 90
      - !Ref AWS::NoValue    # completely removes this rule when versioning = Suspended
```

---

## Commands Used Today

```bash
# Create S3 bucket to store child templates
aws s3 mb s3://my-cfn-templates-bucket --region us-east-1

# Upload all 4 child templates to S3
aws s3 cp network-stack.yaml  s3://my-cfn-templates-bucket/templates/network-stack.yaml
aws s3 cp alb-stack.yaml      s3://my-cfn-templates-bucket/templates/alb-stack.yaml
aws s3 cp compute-stack.yaml  s3://my-cfn-templates-bucket/templates/compute-stack.yaml
aws s3 cp data-stack.yaml     s3://my-cfn-templates-bucket/templates/data-stack.yaml

# Verify all files are uploaded
aws s3 ls s3://my-cfn-templates-bucket/templates/

# Deploy the full nested stack (parent handles all 4 children)
aws cloudformation deploy \
  --template-file parent-stack.yaml \
  --stack-name applo \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      EnvironmentName=prod \
      TemplatesBucketName=my-cfn-templates-bucket

# Update only data-stack after fixing EC2RoleBucketPolicy error
aws s3 cp data-stack.yaml s3://my-cfn-templates-bucket/templates/data-stack.yaml
aws cloudformation deploy \
  --template-file parent-stack.yaml \
  --stack-name applo \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      EnvironmentName=prod \
      TemplatesBucketName=my-cfn-templates-bucket

# Get the Nginx site URL directly from stack outputs
aws cloudformation describe-stacks \
  --stack-name applo \
  --query "Stacks[0].Outputs[?OutputKey=='NginxSiteURL'].OutputValue" \
  --output text

# Delete entire stack and all child stacks in one command
aws cloudformation delete-stack --stack-name applo
```

---

## Key Concepts Learned Today

| Concept | Summary |
|---|---|
| Nested Stacks | Parent template deploys child stacks via `AWS::CloudFormation::Stack`. Child templates stored in S3. One `deploy` command handles everything. |
| Cross-stack exports | Child stacks `Export` values; others consume via `Fn::ImportValue`. Circular imports cause deployment failures — must plan dependency order carefully. |
| `DependsOn` | Forces deploy order. Without it, CloudFormation may try to deploy children in parallel, causing import failures. |
| `CreationPolicy` + `cfn-signal` | Stack only marks complete after EC2 instances signal success — prevents premature COMPLETE status before Nginx is ready. |
| `set -euo pipefail` | Critical bash safety pattern — stops UserData on first failure instead of silently continuing with a broken instance. |
| `systemctl enable` vs `start` | `start` = runs now. `enable` = runs on every reboot. Both required together for a persistent service. |
| `amazon-linux-extras` | Package repo for modern software on Amazon Linux 2. Nginx must be enabled here before `yum install`. |
| IMDSv2 (`HttpTokens: required`) | Enforced on Launch Template — prevents SSRF attacks against instance metadata endpoint. |
| S3 global uniqueness | Bucket names shared across all AWS accounts worldwide. Always append `${AWS::AccountId}` to guarantee uniqueness. |
| IAM Role vs Bucket Policy | IAM Role policy on EC2 is sufficient for S3 access. Bucket policy for EC2 is redundant and caused a circular dependency in this setup. |
| HTTPS on ALB | Requires ACM certificate ARN parameter. Without it, HTTP only. CloudFront alternative provides free HTTPS via `*.cloudfront.net` without a domain. |
| Updating nested stacks | Re-upload changed child template to S3, re-run parent deploy. CloudFormation detects only that child changed — other stacks untouched. |
| Parent template location | Parent template is passed directly via `--template-file`. Only the 4 child templates need to be in S3. |
| `!Ref AWS::NoValue` | Removes a CloudFormation property conditionally — used to skip lifecycle rules when versioning is disabled. |

---

## Final Stack Summary

| Stack | Status | Resources Created | Time |
|---|---|---|---|
| applo (parent) | ✅ CREATE_COMPLETE | 4 nested stacks | 16:46:32 |
| NetworkStack | ✅ CREATE_COMPLETE | VPC, 4 subnets, IGW, NAT GW, 2 SGs, 2 RTs | 16:46:34 |
| ALBStack | ✅ CREATE_COMPLETE | ALB, Target Group, HTTP Listener | 16:49:13 |
| ComputeStack | ✅ CREATE_COMPLETE | IAM Role, Instance Profile, Launch Template, ASG, Scaling Policy | 16:51:28 |
| DataStack | ✅ CREATE_COMPLETE | S3 Bucket, Public Read Policy | 16:55:31 |

**Total deploy time: ~9 minutes**

**Live endpoints verified:**
- Nginx: `http://prod-alb-1960325760.us-east-1.elb.amazonaws.com` ✅
- S3 Static Site: `http://prod-static-19-03-2026-website-595842667987.s3-website-us-east-1.amazonaws.com` ✅

---

## Summary

Day 34 was a complete end-to-end Infrastructure as Code day. Started with designing a nested CloudFormation architecture, built 5 YAML templates, hit 4 real deployment errors (template not in S3, S3 name collision, EC2RoleBucketPolicy circular dependency, versioning lifecycle rule), debugged each one at root cause level, and ended with all stacks in CREATE_COMPLETE status and both endpoints live and verified in the browser. The Nginx page correctly shows Environment=prod, Region=us-east-1, and Managed by=Auto Scaling — confirming the UserData script executed successfully and cfn-signal worked correctly.

---

*Report prepared by: Intern*
*Day: 34 of Internship*
