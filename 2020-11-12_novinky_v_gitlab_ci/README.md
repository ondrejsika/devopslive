# Novinky v Gitlab CI (listopad 2020) #5

## Training

- Gitlab CI - https://ondrej-sika.cz/skoleni/gitlab-ci
- Kubernetes - https://ondrej-sika.cz/skoleni/kubernetes
- Terraform - https://ondrej-sika.cz/skoleni/terraform

## Repositories

- Setup of Gitlab using Terraform - https://github.com/ondrejsika/terraform-demo-gitlab
- Setup of Gitlab Runner in Docker - https://github.com/ondrejsika/ondrejsika-gitlab-runner
- Setup of Kubernetes Cluster using Terraform - https://github.com/ondrejsika/terraform-do-kubernetes-example

Examples from live stream

- https://github.com/devops-live-examples/devopslive5-k8s
- https://github.com/devops-live-examples/devopslive5-include
- https://github.com/devops-live-examples/devopslive5-child-pipelines
- https://github.com/devops-live-examples/devopslive5-genereted-pipeline
- https://github.com/devops-live-examples/devopslive5-lib
- https://github.com/devops-live-examples/devopslive5-app
- https://github.com/devops-live-examples/devopslive5-needs

## Agenda

- Multiple Kubernetes Clusters
- Package Registries
- Include
- Child Pipelines
- Generated Pipelines
- Multi Project Pipelines
- DAG & Needs

## Demo Gitlab

- Gitlab - <https://gitlab.sikademo.com>
- User - `demo`
- Password - `asdfasdf`

## Includes

[Docs](https://docs.gitlab.com/ee/ci/yaml/#include)

```yaml
# .gitlab-ci.yml

include:
  - ci/core.yml
  - ci/build.yml
  - ci/deploy.yml
```

```yaml
# ci/core.yml

stages:
  - build
  - deploy
```

```yaml
# ci/build.yml

build:
  stage: build
  script: echo build
```

```yaml
# ci/deploy.yml

deploy:
  stage: deploy
  script: echo deploy
```

## Child Pipelines

[Docs](https://docs.gitlab.com/ce/ci/parent_child_pipelines.html)

```yaml
# .gitlab-ci.yml
pipeline_a:
  trigger:
    include: a/.gitlab-ci.yml
    strategy: depend
  only:
    changes:
      - a/**

pipeline_b:
  trigger:
    include: b/.gitlab-ci.yml
    strategy: depend
  only:
    changes:
      - b/**
```

```yaml
# a/.gitlab-ci.yml

stages:
  - build
  - deploy

build:
  stage: build
  script: echo Build service A

deploy:
  stage: deploy
  script: echo Deploy service A
```

```yaml
# b/.gitlab-ci.yml

stages:
  - build
  - deploy

build:
  stage: build
  script: echo Build service B

deploy:
  stage: deploy
  script: echo Deploy service B
```

## Generated Pipelines

```yaml
# .gitlab-ci.yml
stages:
  - generate
  - pipeline

generate:
  stage: generate
  image: python:3.7-slim
  script: python generate-gitlab-ci.py
  artifacts:
    paths:
      - .gitlab-ci.generated.yml

pipeline:
  stage: pipeline
  trigger:
    include:
      - artifact: .gitlab-ci.generated.yml
        job: generate
    strategy: depend
```

```python
# generate-gitlab-ci.py
import json

SERVICES = (
    "foo",
    "bar",
)

def make_service(name):
    return {
        "build %s" % name: {
            "stage": "build",
            "script":[
                "echo Build %s" % name,
            ]
        },
        "deploy %s" % name: {
            "stage": "deploy",
            "script":[
                "echo Deploy %s" % name,
            ]
        }
    }

with open(".gitlab-ci.generated.yml", "w") as f:
    pipeline = {}
    pipeline.update({
        "stages": ["build", "deploy"]
    })
    for service in SERVICES:
        pipeline.update(make_service(service))
    f.write(json.dumps(pipeline))
```

## Multi Project Pipelines

[Docs](https://docs.gitlab.com/ce/ci/multi_project_pipelines.html)

#### example/lib

```yaml
# .gitlab-ci.yml (lib)
job:
  script: Do something

triger-pipelines:
  trigger: example/app
```

#### example/app

```yaml
# .gitlab-ci.yml (app)
job:
  script: Do something
```

## Needs, Directed Acyclic Graph

- [Docs (DAG)](https://docs.gitlab.com/ee/ci/directed_acyclic_graph/index.html)
- [Docs (Needs)](https://docs.gitlab.com/ee/ci/yaml/#needs)

```yaml
# .gitlab-ci.yml

stages:
  - build
  - test
  - deploy

linux build:
  stage: build
  script: sleep 10 && echo Done

mac build:
  stage: build
  script: sleep 20 && echo Done

lint:
  stage: test
  needs: []
  script: echo Done

linux unit tests:
  stage: test
  needs:
    - linux build
  script: echo Done

linux e2e tests:
  stage: test
  needs:
    - linux build
  script: sleep 10 && echo Done

mac unit tests:
  stage: test
  needs:
    - mac build
  script: sleep 5 && echo Done

mac e2e tests:
  stage: test
  needs:
    - mac build
  script: sleep 30 && echo Done

release linux:
  stage: deploy
  script: "echo Done"
  needs:
    - linux unit tests
    - linux e2e tests

release mac:
  stage: deploy
  script: "echo Done"
  needs:
    - mac unit tests
    - mac e2e tests
```
