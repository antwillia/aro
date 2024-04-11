# Deploy Gitops NameSpace

resource "kubernetes_namespace" "openshift-gitops-operator" {
  provider = kubernetes.aro-atwlab
  metadata {
    name = "openshift-gitops-operator"
  }
}

# Deploy Gitops admin group

resource "kubernetes_manifest" "gitops-admin-group" {
  depends_on = [ kubernetes_namespace.openshift-gitops-operator ]
  provider = kubernetes.aro-atwlab
  manifest = {
    "apiVersion" = "user.openshift.io/v1"
    "kind" = "Group"
    "metadata" = {
      "name" = "argo-admins"
    }
    "users" = ["kubeadmin"]
  }
}

# Deploy Gitops Operator Group

resource "kubernetes_manifest" "gitops-og" {
  depends_on = [ kubernetes_manifest.gitops-admin-group ]
  provider = kubernetes.aro-atwlab
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind" = "OperatorGroup"
    "metadata" = {
       "name" =  "openshift-og"
       "namespace" = "openshift-gitops-operator"
    }
  
    "spec" = {
      "upgradeStrategy" = "Default"
    }
  }
}

# Deploy Gitops Subscription

resource "kubernetes_manifest" "gitops-operator" {
  depends_on = [ kubernetes_manifest.gitops-og ]
  provider = kubernetes.aro-atwlab
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind" = "Subscription"
    "metadata" = {
      "name" = "openshift-gitops-operator"
      "namespace" = "openshift-gitops-operator"
    }
    "spec" = {
      "channel" = "latest"
      "installPlanApproval" = "Automatic"
      "name" = "openshift-gitops-operator"
      "source" = "redhat-operators"
      "sourceNamespace" = "openshift-marketplace"
    }
  }
}

# Deploy GitOps Cluster Role Binding

resource "kubernetes_cluster_role_binding" "argocd-role-binding" {
  depends_on = [ kubernetes_manifest.gitops-operator ]
  provider = kubernetes.aro-atwlab
  metadata {
    name = "gitops-argocd-application-cluster-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "openshift-gitops-argocd-application-controller"
    namespace = "openshift-gitops"
  }
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [ kubernetes_manifest.gitops-operator ]

  create_duration = "60s"
}

# Deploy App of Apps

resource "helm_release" "gitops" {
  depends_on = [ time_sleep.wait_150_seconds ]

  name = "gitops"
  chart = "gitops"
  repository = "."
  namespace = "default"
  max_history = 3
  wait = true
  
}