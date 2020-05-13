#!/bin/bash

#set -x

CICDNS=labs-ci-cd
CRWNS=crw
HOMERNS=labs-ci-cd

cat <<EOF | oc apply -n ${HOMERNS} -f-
apiVersion: v1
data:
  conf: |
    footer: <p>Created with <span class="has-text-danger">❤️</span> with <a href="https://bulma.io/">bulma</a>,
      <a href="https://vuejs.org/">vuejs</a> & <a href="https://fontawesome.com/">font
      awesome</a><i class="fab
      fa-github-alt"></i></a></p>
    links:
    - icon: fab fa-github
      name: Ubiquitous Journey
      target: _blank
      url: https://github.com/rht-labs/ubiquitous-journey
    - icon: fab fa-github
      name: Open Management Portal
      url: https://github.com/rht-labs/open-management-portal
    - icon: fab fa-github
      name: Helm Charts
      url: https://github.com/rht-labs/helm-charts
    - icon: fab fa-github
      name: 'DO500 '
      url: https://github.com/rht-labs/enablement-docs
    logo: https://www.redhat.com/cms/managed-files/RHOIL_LogoBadge_RGB_Default.svg
    services:
    - icon: fas fa-code-branch
      items:
      - logo: images/jenkins.jpeg
        name: Jenkins
        subtitle: Continuous integration server
        tag: ci
        target: _blank
        url: https://$(oc -n ${CICDNS} get route jenkins -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: https://argoproj.github.io/argo-cd/assets/logo.png
        name: ArgoCD
        subtitle: Git driven Operations
        tag: ci, gitops
        target: _blank
        url: https://$(oc -n ${CICDNS} get route argocd-server -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: https://github.com/redhat-developer/codeready-workspaces/raw/master/product/branding/CodeReady.png
        name: CodeReady Workspaces
        subtitle: Cloud hosted dev stack
        tag: dev
        target: _blank
        url: https://$(oc -n ${CRWNS} get route codeready -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: https://user-images.githubusercontent.com/7955995/29498304-ee71d418-85c6-11e7-9f95-e87a4439ed3c.png
        name: Nexus
        subtitle: Software artifact repository
        tag: dev, artifacts
        target: _blank
        url: https://$(oc -n ${CICDNS} get route nexus -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: https://www.sonarqube.org/images/downloads/picto.svg
        name: SonarQube
        subtitle: Software quality tooling
        tag: testing, quality
        target: _blank
        url: http://$(oc -n ${CICDNS} get route sonarqube -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: https://gitlab.com/okj8/zalenium/-/avatar
        name: Zalenium
        subtitle: Browser testing tools
        tag: testing, browser
        target: _blank
        url: http://$(oc -n ${CICDNS} get route zalenium -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: images/tekton.png
        name: Tekton
        subtitle: Kuberntes native piplines
        tag: pipelines
        target: _blank
        url: https://$(oc -n ${CICDNS} get route zalenium -o custom-columns=ROUTE:.spec.host --no-headers)/k8s/ns/${CICDNS}/tekton.dev~v1alpha1~Pipeline
      name: Automation
    - icon: fas fa-heartbeat
      items:
      - logo: images/grafana.png
        name: Grafana
        subtitle: Metric analytics & dashboards
        tag: metrics, dashboard
        target: _blank
        url: http://$(oc -n ${CICDNS} get route argocd-grafana -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: https://d15shllkswkct0.cloudfront.net/wp-content/blogs.dir/1/files/2017/11/prometheus_logo.png
        name: Prometheus
        subtitle: Collect Mertics
        tag: metrics
        target: _blank
        url: http://$(oc -n ${CICDNS} get route argocd-prometheus -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: images/hoverfly.jpeg
        name: Hoverfly
        subtitle: API Simulations and Testing
        tag: api
        target: _blank
        url: https://$(oc -n ${CICDNS} get route hoverfly-hoverfly-admin -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: images/pact.png
        name: Pact
        subtitle: Consumer Driven Contract Testing
        tag: api
        target: _blank
        url: http://$(oc -n ${CICDNS} get route pact-broker -o custom-columns=ROUTE:.spec.host --no-headers)
      name: Monitoring
    - icon: fas fa-tasks
      items:
      - logo: https://avatars0.githubusercontent.com/u/11725037?s=200&v=4
        name: Wekan
        subtitle: Wekan Tasks
        tag: kanban
        target: _blank
        url: https://$(oc -n ${CICDNS} get route wekan -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: https://images.g2crowd.com/uploads/product/image/large_detail/large_detail_0b2e8ea823612a322cf779c35039d756/mattermost.png
        name: Mattermost
        subtitle: Cluster hosted Chat app
        tag: chat
        target: _blank
        url: https://$(oc -n ${CICDNS} get route mattermost-team-edition -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: images/etherpad.jpeg
        name: Etherpad
        subtitle: Collaborative text pad
        tag: write, text
        target: _blank
        url: https://$(oc -n ${CICDNS} get route etherpad -o custom-columns=ROUTE:.spec.host --no-headers)
      - logo: images/owncloud.png
        name: Owncloud
        subtitle: Share your documents
        tag: sharing, documents
        target: _blank
        url: https://$(oc -n ${CICDNS} get route -lapp.kubernetes.io/name=owncloud -o custom-columns=ROUTE:.spec.host --no-headers)
      name: Project Management
    subtitle: Red Hat Open Innovation Labs
    title: "\U0001F984 Developer Experience \U0001F525"
kind: ConfigMap
metadata:
  name: dev-ex-dashboard-environment
  namespace: ${HOMERNS}
  labels:
    rht-labs.com/uj: dev-ex-dashboard
  annotations:
    argocd.argoproj.io/sync-options: Prune=false  
    argocd.argoproj.io/compare-options: IgnoreExtraneous
EOF
oc delete pod -lapp=dev-ex-dashboard -n ${HOMERNS}
oc -n ${HOMERNS} wait pod -lapp=dev-ex-dashboard --for=condition=Ready --timeout=300s
