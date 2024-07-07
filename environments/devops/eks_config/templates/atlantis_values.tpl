## -------------------------- ##
# Values to override for your instance.
## -------------------------- ##

# -- Provide a name to substitute for the full names of resources.
fullnameOverride: ""

# -- Provide a name to substitute for the name of the chart.
nameOverride: ""

# -- An option to override the atlantis url,
# if not using an ingress, set it to the external IP.
# Check values.yaml for examples.
atlantisUrl: ""
# Example:  http://10.0.0.0

# -- Replace this with your own repo allowlist.
orgAllowlist: "${allowed_repos}"

# -- Deprecated in favor of orgAllowlist.
orgWhitelist: "<deprecated>"

# -- Specify the log level for Atlantis.
# Accepts: debug, info, warn, or error.
logLevel: ""
github:
  user: "${user}"
  token: "${token}"
  secret: "${secret}"
  hostname: "${hostname}"

githubApp: { }
gitlab: { }
bitbucket: { }
azuredevops: { }


# -- If managing secrets outside the chart for the webhook, use this variable to reference the secret name
vcsSecretName: ""

# -- When referencing Terraform modules in private repositories, it may be helpful
# (necessary?) to use redirection in a .gitconfig.
# Check values.yaml for examples.
gitconfig: ""
# gitconfig: |
# [url "https://YOUR_GH_TOKEN@github.com"]
#   insteadOf = https://github.com
# [url "https://YOUR_GH_TOKEN@github.com"]
#   insteadOf = ssh://git@github.com
# [url "https://oauth2:YOUR_GITLAB_TOKEN@gitlab.com"]
#   insteadOf = https://gitlab.com
# [url "https://oauth2:YOUR_GITLAB_TOKEN@gitlab.com"]
#   insteadOf = ssh://git@gitlab.com
# Source: https://stackoverflow.com/questions/42148841/github-clone-with-oauth-access-token

# -- If managing secrets outside the chart for the gitconfig, use this variable to reference the secret name
gitconfigSecretName: ""

# -- When referencing Terraform modules in private repositories or registries (such as Artfactory)
# configuing a .netrc file for authentication may be required.
# Check values.yaml for examples.
netrc: ""
# netrc: |
# machine artifactory.myapp.com login YOUR_USERNAME password YOUR_PASSWORD
# machine bitbucket.myapp.com login YOUR_USERNAME password YOUR_PASSWORD

# -- If managing secrets outside the chart for the netrc file, use this variable to reference the secret name
netrcSecretName: ""

# -- To specify AWS credentials to be mapped to ~/.aws or to aws.directory.
# Check values.yaml for examples.
aws: { }
# aws:
#   credentials: |
#     [default]
#     aws_access_key_id=YOUR_ACCESS_KEY_ID
#     aws_secret_access_key=YOUR_SECRET_ACCESS_KEY
#     region=us-east-1
#   config: |
#     [profile a_role_to_assume]
#     role_arn = arn:aws:iam::123456789:role/service-role/roleToAssume
#     source_profile = default
#   directory: "/home/atlantis/.aws"

# -- To reference an already existing Secret object with AWS credentials
awsSecretName: ""

# -- To keep backwards compatibility only.
# Deprecated (see googleServiceAccountSecrets).
# To be used for mounting credential files (when using google provider).
# Check values.yaml for examples.
serviceAccountSecrets: { }
# serviceAccountSecrets:
#   credentials: <json file as base64 encoded string>
#   credentials-staging: <json file as base64 encoded string>

## -------------------------- ##
# Default values for atlantis (override as needed).
## -------------------------- ##

image:
  repository: ghcr.io/runatlantis/atlantis
  # -- If not set appVersion field from Chart.yaml is used
  tag: ""
  pullPolicy: Always

# --  Optionally specify an array of imagePullSecrets.
# Secrets must be manually created in the namespace.
# ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/.
# Check values.yaml for examples.
imagePullSecrets: [ ]
# imagePullSecrets:
#   - myRegistryKeySecretName

# -- Override atlantis main configuration by config map,
# ref: https://www.runatlantis.io/docs/using-slack-hooks.html#configuring-atlantis.
# Check values.yaml for examples.
config: ""
# config: |
#   ---
#   webhooks:
#     - event: apply
#       workspace-regex: .*
#       branch-regex: .*
#       kind: slack
#       channel: my-channel

# -- Use Server Side Repo Config,
# ref: https://www.runatlantis.io/docs/server-side-repo-config.html.
# Check values.yaml for examples.
repoConfig: ""
# Example with default configuration:
# repoConfig: |
#   ---
#   repos:
#   - id: /.*/
#     apply_requirements: []
#     workflow: default
#     allowed_overrides: []
#     allow_custom_workflows: false
#   workflows:
#     default:
#       plan:
#         steps: [init, plan]
#       apply:
#         steps: [apply]
#   metrics:
#     prometheus:
#       endpoint: /metrics

# -- Enables atlantis to run on a fork Pull Requests.
allowForkPRs: false

# -- Enables atlantis to run on a draft Pull Requests.
allowDraftPRs: false

# -- Enables atlantis to hide previous plan comments.
hidePrevPlanComments: false

# -- Enables atlantis to hide no-changes plan comments from the pull request.
hideUnchangedPlanComments: false

# -- Sets the default terraform version to be used in atlantis server.
# Check values.yaml for examples.
defaultTFVersion: ""
# Example: "0.12.0".

# -- Disables running `atlantis apply` regardless of which flags are sent with it.
disableApply: false

# -- Disables running `atlantis apply` without any flags.
disableApplyAll: false

# -- Stops atlantis locking projects and or workspaces when running terraform.
disableRepoLocking: false

# -- Use Diff Markdown Format for color coding diffs.
enableDiffMarkdownFormat: false

# -- Optionally specify an username and a password for basic authentication.
basicAuth:
  username: ""
  password: ""

# -- If managing secrets outside the chart for the Basic Auth secret, use this variable to reference the secret name.
basicAuthSecretName: ""

# -- Optionally specify an API secret to enable the API.
# Check values.yaml for examples.
api: { }
# api:
#   secret: "s3cr3t"

# -- If managing secrets outside the chart for the API secret, use this variable to reference the secret name.
apiSecretName: ""

# -- Override the command field of the Atlantis container.
command: [ ]

# -- Common Labels for all resources created by this chart.
commonLabels: { }

livenessProbe:
  enabled: true
  # -- We only need to check every 60s since Atlantis is not a high-throughput service.
  periodSeconds: 60
  initialDelaySeconds: 5
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 5
  scheme: HTTP

readinessProbe:
  enabled: true
  periodSeconds: 60
  initialDelaySeconds: 5
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 5
  scheme: HTTP

service:
  type: NodePort
  annotations: { }
  port: 80
  nodePort: null
  targetPort: 4141
  loadBalancerIP: null
  loadBalancerSourceRanges: [ ]

podTemplate:
  # -- Check values.yaml for examples.
  annotations: { }
  # annotations:
  #   iam.amazonaws.com/role: role-arn # kube2iam example.
  labels: { }

statefulSet:
  annotations: { }
  labels: { }
  securityContext:
    fsGroup: 1000
    # -- It is not recommended to run atlantis as root.
    runAsUser: 100
    fsGroupChangePolicy: "OnRootMismatch"
  priorityClassName: ""
  updateStrategy: { }
  # -- Option to share process namespace with atlantis container.
  shareProcessNamespace: false

# -- (int) Optionally customize the termination grace period in seconds.
# @default -- default depends on the kubernetes version.
terminationGracePeriodSeconds:

ingress:
  enabled: true
  ingressClassName:
  apiVersion: ""
  labels: { }
  # -- Check values.yaml for examples.
  annotations:
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    kubernetes.io/ingress.class: alb
  # -- Use / for nginx.
  path: /*
  # --  Used when several paths under the same host, with different backend services, are required.
  # Check values.yaml for examples.
  paths: [ ]
  #    - path: "/path1"
  #      service: test1
  #      port:
  #    - path: "/path2"
  #      service: test2
  #      port:
  pathType: ImplementationSpecific
  host: ""
  # -- Used when several hosts are required.
  # Check values.yaml for examples.
  hosts: [ ]
  #   - host: chart-example.local
  #     paths: ["/"]
  #     service: chart-example1
  #   - host: chart-example.local2
  #     service: chart-example1
  #     paths: ["/lala"]
  # -- Check values.yaml for examples.
  tls: [ ]
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local

webhook_ingress:
  # -- When true creates a secondary webhook.
  enabled: false
  ingressClassName:
  apiVersion: ""
  # -- Check values.yaml for examples.
  annotations: { }
  # annotations:
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: "true"
  # -- Use / for nginx.
  path: /*
  # --  Used when several paths under the same host, with different backend services, are required.
  # Check values.yaml for examples.
  paths: [ ]
  #    - path: "/path1"
  #      service: test1
  #      port:
  #    - path: "/path2"
  #      service: test2
  #      port:
  pathType: ImplementationSpecific
  host: ""
  # -- Used when several hosts are required.
  # Check values.yaml for examples.
  hosts: [ ]
  #   - host: chart-example.local
  #     paths: ["/"]
  #     service: chart-example1
  #   - host: chart-example.local2
  #     service: chart-example1
  #     paths: ["/lala"]
  # -- TLS configuration.
  # Check values.yaml for examples.
  tls: [ ]
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local
  labels: { }

# -- Allows to override the /etc/ssl/certs/ca-certificates.cer with your custom one.
# You have to create a secret with the specified name.
customPem: ""

# -- Resources for Atlantis.
# Check values.yaml for examples.
resources: { }
# resources:
#   requests:
#     memory: 1Gi
#     cpu: 100m
#   limits:
#     memory: 1Gi
#     cpu: 100m

# -- Path to the data directory for the volumeMount.
atlantisDataDirectory: /atlantis-data

volumeClaim:
  enabled: true
  # -- Disk space available to check out repositories.
  dataStorage: 5Gi
  # -- Storage class name (if possible, use a resizable one).
  storageClassName: "${storageClassName}"
  accessModes: [ "ReadWriteOnce" ]

# -- DEPRECATED - Disk space available to check out repositories.
# Example: 5Gi.
dataStorage: ""
# -- DEPRECATED - Storage class name for Atlantis disk.
storageClassName: ""

# -- Replica count for Atlantis pods.
replicaCount: 1

test:
  # -- Enables test container.
  enabled: true
  image: bats/bats
  imageTag: 1.9.0
  annotations: { }

nodeSelector: { }

tolerations: [ ]

affinity: { }

# -- You can use topology spread constraints to control how Pods are spread across your cluster among failure-domains such as regions,
# zones, nodes, and other user-defined topology domains. (requires Kubernetes >= 1.19).
# Check values.yaml for examples.
topologySpreadConstraints: [ ]
#  - labelSelector:
#      matchLabels:
#        app.kubernetes.io/name: aws-example-cluster
#    maxSkew: 1
#    topologyKey: topology.kubernetes.io/zone
#    whenUnsatisfiable: DoNotSchedule

serviceAccount:
  # -- Specifies whether a ServiceAccount should be created.
  create: true
  # -- Set the `automountServiceAccountToken` field on the pod template spec.
  # -- If false, no kubernetes service account token will be mounted to the pod.
  mount: true
  # -- The name of the ServiceAccount to use.
  # If not set and create is true, a name is generated using the fullname template.
  name: null
  # -- Annotations for the Service Account.
  # Check values.yaml for examples.
  annotations: { }
  # annotations:
  #   annotation1: value
  #   annotation2: value
  # IRSA example:
  # annotations:
  #   eks.amazonaws.com/role-arn: role-arn

# -- Optionally deploy rbac to allow for the serviceAccount to manage terraform state via the kubernetes backend.
enableKubernetesBackend: false

# -- TLS Secret Name for Atlantis pod.
tlsSecretName: ""

# -- Additional path (`:` separated) that will be appended to the system `PATH` environment variable.
extraPath: ""

# -- Environtment values to add to the Atlantis pod.
# Check values.yaml for examples.
environment: { }
# environment:
#   ATLANTIS_DEFAULT_TF_VERSION: v1.2.9

# -- Optionally specify additional environment variables to be populated from Kubernetes secrets.
# Useful for passing in TF_VAR_foo or other secret environment variables from Kubernetes secrets.
# Check values.yaml for examples.
environmentSecrets: [ ]
# environmentSecrets:
#   - name: THE_ENV_VAR
#     secretKeyRef:
#       name: the_k8s_secret_name
#       key: the_key_of_the_value_in_the_secret

# -- Optionally specify additional environment variables in raw yaml format.
# Useful to specify variables refering to k8s objects.
# Check values.yaml for examples.
environmentRaw: [ ]
# environmentRaw:
#   - name: POD_IP
#     valueFrom:
#       fieldRef:
#         fieldPath: status.podIP

# -- Optionally specify additional Kubernetes secrets to load environment variables from.
# All key-value pairs within these secrets will be set as environment variables.
# Note that any variables set here will be ignored if also defined in the env block of the atlantis statefulset.
# For example, providing ATLANTIS_GH_USER here and defining a value for github.user will result in the github.user value being used.
# Check values.yaml for examples.
loadEnvFromSecrets: [ ]
# loadEnvFromSecrets:
#   - secret_one
#   - secret_two

# -- Optionally specify additional Kubernetes ConfigMaps to load environment variables from.
# All key-value pairs within these ConfigMaps will be set as environment variables.
# Note that any variables set here will be ignored if also defined in the env block of the atlantis statefulset.
# For example, providing ATLANTIS_ALLOW_FORK_PRS here and defining a value for allowForkPRs will result in the allowForkPRs value being used.
# Check values.yaml for examples.
loadEnvFromConfigMaps: [ ]
# loadEnvFromConfigMaps:
#   - config_one
#   - config_two

# Check values.yaml for examples.
googleServiceAccountSecrets: [ ]
# googleServiceAccountSecrets:
#   - name: some-secret-name
#     secretName: the_k8s_secret_name

# -- Optionally specify additional volumes for the pod.
# Check values.yaml for examples.
extraVolumes: [ ]
# extraVolumes:
#   - name: some-volume-name
#     emptyDir: {}

# -- Optionally specify additional volume mounts for the container.
# Check values.yaml for examples.
extraVolumeMounts: [ ]
# extraVolumeMounts:
#   - name: some-volume-name
#     mountPath: /path/in/container

# -- Optionally specify additional manifests to be created.
# Check values.yaml for examples.
extraManifests: [ ]
# extraManifests:
#  - apiVersion: cloud.google.com/v1beta1
#    kind: BackendConfig
#    metadata:
#      name: "{{ .Release.Name }}-test"
#    spec:
#      securityPolicy:
#        name: "gcp-cloud-armor-policy-test"

# -- Optionally specify init containers manifests to be added to the Atlantis pod.
# Check values.yaml for examples.
initContainers: [ ]
# initContainers:
# - name: example
#   image: alpine:latest
#   command: ['sh', '-c', 'echo The init container is running! && sleep 10']

initConfig: {}
# -- Optionally specify hostAliases for the Atlantis pod.
# Check values.yaml for examples.
hostAliases: [ ]
# hostAliases:
#   - hostnames:
#     - aaa.com
#     - test.ccc.com
#     ip: 10.0.0.0
#   - hostnames:
#     - bbb.com
#     ip: 10.0.0.2

# -- Optionally specify dnsPolicy parameter to specify a DNS policy for a pod
# Check https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy
dnsPolicy: "ClusterFirst"

# -- Optionally specify dnsConfig for the Atlantis pod.
# Check values.yaml for examples.
dnsConfig: { }
# dnsConfig:
#  nameservers:
#    - 8.8.8.8
#  searches:
#    - mydomain.com

hostNetwork: false

# - These annotations will be added to all the resources.
# Check values.yaml for examples.
extraAnnotations: { }
# extraAnnotations:
#   team: example

# -- Optionally specify extra arguments for the Atlantis pod.
# Check values.yaml for examples.
extraArgs: [ ]
# extraArgs:
#   - --disable-autoplan
#   - --disable-repo-locking

# -- Optionally specify extra containers for the Atlantis pod.
# Check values.yaml for examples.
extraContainers: [ ]
# extraContainers:
#   - name: <container name>
#     args:
#       - ...
#     image: <docker images>
#     imagePullPolicy: IfNotPresent
#     resources:
#       limits:
#         memory: 128Mi
#       requests:
#         cpu: 100m
#         memory: 128Mi
#     volumeMounts:
#       - ...

# -- Check values.yaml for examples.
containerSecurityContext: { }
# containerSecurityContext:
#   allowPrivilegeEscalation: false
#   readOnlyRootFilesystem: true

servicemonitor:
  # -- To enable a Prometheus servicemonitor, set enabled to true,
  #   and enable the metrics in this file's repoConfig
  #   by setting a value for metrics.prometheus.endpoint.
  enabled: false
  interval: "30s"
  path: /metrics
  # -- Prometheus ServiceMonitor labels.
  additionalLabels: { }
  auth:
    # -- If auth is enabled on Atlantis, use one of the following mechanism.
    basicAuth:
      # -- Authentication from the secret generated with the basicAuth values
      #   this will reference the username and password keys
      #   from the atlantis-basic-auth secret.
      enabled: false
    externalSecret:
      # -- Authentication based on an external secret
      enabled: false
      name: ""
      # -- Check values.yaml for examples.
      keys: { }
      # keys:
      #   username: USERNAME
      #   password: ATLANTIS_WEB_PASSWORD

# -- Enable this if you're using Google Managed Prometheus.
podMonitor:
  enabled: false
  interval: "30s"

# -- Set the desired Locking DB type
# Accepts boltdb or redis.
lockingDbType: ""

# -- Configure Redis Locking DB.
# lockingDbType value must be redis for the config to take effect.
# Check values.yaml for examples.
redis: { }
# redis:
#   host: redis.host.name
#   password: myRedisPassword
#   port: 6379
#   db: 0
#   tlsEnabled: false
#   insecureSkipVerify: false

# -- When managing secrets outside the chart for the Redis secret, use this variable to reference the secret name.
redisSecretName: ""

# -- Set lifecycle hooks.
# https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/.
lifecycle: { }

