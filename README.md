# Acme Equipment Monitoring

A containerized Node.js application deployed to AWS ECS Fargate using an automated GitHub Actions CI/CD pipeline.

## Architecture

**Deployment flow:**

Developer → GitHub → GitHub Actions → Amazon ECR → Amazon ECS Fargate → Application Load Balancer → Users

### AWS Services

- **Amazon ECS Fargate:** Runs the application containers without managing EC2 container hosts.
- **Amazon ECR:** Stores versioned Docker images.
- **Application Load Balancer:** Routes HTTP traffic to healthy application tasks.
- **Amazon CloudWatch Logs:** Collects container logs.
- **AWS IAM and GitHub OIDC:** Allow GitHub Actions to access AWS using short-lived credentials instead of long-lived AWS access keys.

## Application Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | Application status and version |
| `/health` | Health check |
| `/api/equipment` | Equipment status data |

## Technology Stack

- Node.js and Express
- Docker
- AWS ECS Fargate
- Amazon ECR
- Application Load Balancer
- Amazon CloudWatch
- GitHub Actions
- AWS IAM and OpenID Connect (OIDC)

## CI/CD Pipeline

When code is pushed to the `main` branch, GitHub Actions:

1. Checks out the repository.
2. Authenticates to AWS using GitHub OIDC.
3. Builds the Docker image.
4. Pushes the image to Amazon ECR using the commit SHA as its tag.
5. Renders the ECS task definition with the new image.
6. Registers a new ECS task definition revision and updates the ECS service.
7. Waits for the service to become stable.

## Security

- GitHub Actions uses OIDC rather than stored AWS access keys.
- The GitHub Actions IAM role uses a repository-specific trust policy.
- The ECS task security group accepts application traffic from the load balancer security group.
- Container logs are sent to CloudWatch Logs.
- The ECR repository uses immutable image tags.

## Local Development

Requirements: Node.js and npm.

Install dependencies:

```bash
npm ci
```

Start the application:

```bash
npm start
```

Open localhost:3000 in your browser.

## Docker

Build the image:

```bash
docker build -t acme-equipment:local .
```

Run the container:

```bash
docker run --rm -p 3000:3000 acme-equipment:local
```

Test the health endpoint:

```bash
curl localhost:3000/health
```

## ECS Task Definition

The ECS task definition template is located at `ecs/task-definition.json`. The deployment workflow replaces its image placeholder with the newly built ECR image.

## Future Improvements

- Configure HTTPS using AWS Certificate Manager and a custom domain.
- Add CloudWatch alarms and dashboards.
- Implement ECS service auto scaling.
- Add automated application tests and deployment validation.
- Document rollback and incident response procedures.
