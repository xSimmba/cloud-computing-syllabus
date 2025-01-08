# Session 7: Automating Kubernetes with Terraform

## Objectives
- Automate cluster creation and management with Terraform.
- Use Terraform to configure namespaces and roles in Kubernetes.

---

## Lab Outline

### Step 1: Automating Minikube/Kind Cluster Creation

1. **Install Required Tools**:
   - Ensure Terraform is installed (refer to Session 6 if needed).
   - Ensure Minikube is installed:
     ```bash
     # Start a Minikube cluster:
     minikube start
     terraform init
     ```
---

### Step 2: Automating Namespace Creation with Terraform

1. **Review Namespace Terraform Configuration**:
   - Open `namespace.tf` to see the Terraform configuration for creating namespaces:
     ```hcl
     provider "kubernetes" {
       config_path = "~/.kube/config"
     }

     resource "kubernetes_namespace" "dev" {
       metadata {
         name = "development"
       }
     }

     resource "kubernetes_namespace" "prod" {
       metadata {
         name = "production"
       }
     }
     ```

2. **Apply the Configuration**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Verify the Namespaces**:
   - Check the namespaces:
     ```bash
     kubectl get namespaces
     ```

---

### Step 3: Configuring RBAC Roles with Terraform

1. **Review RBAC Configuration**:
   - Open `rbac.tf` to review the role and role binding configurations:
     ```hcl
     resource "kubernetes_role" "developer_role" {
       metadata {
         name      = "developer-role"
         namespace = kubernetes_namespace.dev.metadata[0].name
       }

       rule {
         api_groups = [""]
         resources  = ["pods"]
         verbs      = ["get", "list", "watch"]
       }
     }

     resource "kubernetes_role_binding" "developer_binding" {
       metadata {
         name      = "developer-binding"
         namespace = kubernetes_namespace.dev.metadata[0].name
       }

       role_ref {
         api_group = "rbac.authorization.k8s.io"
         kind      = "Role"
         name      = kubernetes_role.developer_role.metadata[0].name
       }

       subject {
         kind      = "User"
         name      = "developer"
         api_group = "rbac.authorization.k8s.io"
       }
     }
     ```

2. **Apply the RBAC Configuration**:
   ```bash
   terraform apply
   ```

3. **Verify the RBAC Setup**:
   - List roles in the `development` namespace:
     ```bash
     kubectl get roles -n development
     ```
   - List role bindings in the `development` namespace:
     ```bash
     kubectl get rolebindings -n development
     ```

---

## Deliverables
- Screenshot of namespaces and roles created via `kubectl`.
- Screenshot of role bindings created via `kubectl`.
---

## Files Included
1. `namespace.tf`: Namespace creation.
2. `rbac.tf`: RBAC roles and role bindings.
3. `variables.tf`: Variables used in the configuration.
4. `.gitignore`: Ignoring Terraform state files.

---

Happy automating Kubernetes with Terraform! 🚀
