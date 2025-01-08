# Session 8: Advanced Kubernetes with Terraform

## Objectives
- Manage complex Kubernetes resources using Terraform.
- Handle variables and outputs effectively.

---

## Lab Outline

### Step 1: Preparing the Environment

1. **Install Required Tools**:
   - Ensure Terraform is installed (refer to Session 6 if needed).
   - Ensure a Kubernetes cluster is running (e.g., Minikube or Kind).

2. **Prepare the Lab Environment**:
   - Configure `kubectl` to interact with the cluster:
     ```bash
     kubectl cluster-info
     ```

---

### Step 2: Configuring StatefulSets with Terraform

1. **Review StatefulSet Terraform Configuration**:
   - Open `statefulset.tf` to see the StatefulSet configuration:
     ```hcl
     resource "kubernetes_stateful_set" "db" {
       metadata {
         name      = "db-statefulset"
         namespace = "default"
       }

       spec {
         service_name = "db-service"
         replicas     = 3

         selector {
           match_labels = {
             app = "database"
           }
         }

         template {
           metadata {
             labels = {
               app = "database"
             }
           }

           spec {
             container {
               name  = "db"
               image = "postgres:13"

               ports {
                 container_port = 5432
               }

               volume_mounts {
                 name       = "data"
                 mount_path = "/var/lib/postgresql/data"
               }
             }
           }
         }

         volume_claim_templates {
           metadata {
             name = "data"
           }

           spec {
             access_modes = ["ReadWriteOnce"]

             resources {
               requests = {
                 storage = "1Gi"
               }
             }
           }
         }
       }
     }
     ```

2. **Initialize and Apply the Configuration**:
   - Initialize Terraform:
     ```bash
     terraform init
     ```
   - Preview the changes:
     ```bash
     terraform plan
     ```
   - Apply the changes:
     ```bash
     terraform apply -auto-approve
     ```

3. **Verify the StatefulSet**:
   - Check the StatefulSet and Pods:
     ```bash
     kubectl get statefulsets
     kubectl get pods
     ```

---

### Step 3: Configuring Ingress Resources with Terraform

1. **Review Ingress Configuration**:
   - Open `ingress.tf` to review the Ingress configuration:
     ```hcl
     resource "kubernetes_ingress" "example" {
       metadata {
         name      = "example-ingress"
         namespace = "default"
       }

       spec {
         rule {
           http {
             path {
               path    = "/"
               backend {
                 service_name = "web-service"
                 service_port = 80
               }
             }
           }
         }
       }
     }
     ```

2. **Initialize and Apply the Configuration**:
   - Apply the Ingress configuration:
     ```bash
     terraform apply -auto-approve
     ```

3. **Verify the Ingress**:
   - Check the Ingress resource:
     ```bash
     kubectl get ingress
     ```
   - Test the application using the Ingress URL.

---

### Step 4: Using Variables and Outputs in Terraform

1. **Review Variables and Outputs**:
   - Open `variables.tf` and `outputs.tf`:
     ```hcl
     variable "replica_count" {
       default = 3
     }

     output "statefulset_name" {
       value = kubernetes_stateful_set.db.metadata[0].name
     }
     ```

2. **Customize the Variables**:
   - Edit `terraform.tfvars` to override default values:
     ```hcl
     replica_count = 5
     ```

3. **Apply the Updated Configuration**:
   - Reapply the configuration:
     ```bash
     terraform apply -auto-approve
     ```

4. **Verify Outputs**:
   - View the outputs:
     ```bash
     terraform output
     ```

---

### Step 5: Cleaning Up

1. **Destroy Resources**:
   - If you wish to clean up the resources created during the lab:
     ```bash
     terraform destroy -auto-approve
     ```

2. **Delete the Cluster**:
   - If using Minikube:
     ```bash
     minikube delete
     ```
   - If using Kind:
     ```bash
     kind delete cluster
     ```

---

## Deliverables
- **Screenshots**:
  1. StatefulSet and Pods created via Terraform (`kubectl get statefulsets/pods`).
  2. Ingress resource created (`kubectl get ingress`).

- **Git Repository**:
  - Commit all Terraform files to your Git repository.

---

## Files Included
1. `statefulset.tf`: StatefulSet configuration.
2. `ingress.tf`: Ingress resource configuration.
3. `variables.tf`: Variables used in the configuration.
4. `outputs.tf`: Outputs for Terraform resources.
5. `.gitignore`: Ignoring Terraform state files.
6. `README.md`: Documentation for the lab.

---

Happy managing advanced Kubernetes resources with Terraform! 🚀
