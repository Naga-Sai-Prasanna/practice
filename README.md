# 🛒 RoboShop: End-to-End DevOps & Cloud Transformation Hub

Welcome to the centralized repository for the **RoboShop Microservices E-Commerce Application**. This codebase documents how I modernized a multi-tier microservices application from procedural automation to infrastructure as code, containerization, and cluster orchestration.

---

## 📂 Repository Architecture & Folder Map

### 🟩 Phase 1: Linux Base & Shell Scripting
*   **The Blueprint:** Map out runtime paths, system configurations, application port routing, and runtime binaries.
*   **Modules:**
    *   📁 [shell_practice](./shell_practice): Baseline automated system setup validation files.

### 🟩 Phase 2: Idempotent Configuration Management (Ansible)
*   **The Blueprint:** Transition installation rules from step-by-step procedural scripting to self-healing configs.
*   **Modules:**
    *   📁 [ansible](./ansible) / [ansible-roles](./ansible-roles) / [roboshop-ansible](./roboshop-ansible): Production infrastructure state definitions.
    *   📁 [ansible-roboshop-roles-tf](./ansible-roboshop-roles-tf): Variable parsing mappings handling config automation.

### 🟩 Phase 3: Infrastructure as Code & Networks (Terraform)
*   **The Blueprint:** Orchestrate network paths, security borders, and compute targets dynamically on AWS.
*   **Modules:**
    *   📁 [terraform](./terraform) / [terraform-aws-vpc](./terraform-aws-vpc): Custom isolated VPC networking fabrics.
    *   📁 [terraform-aws-sg](./terraform-aws-sg): Security boundary configuration definitions.
    *   📁 [terraform-roboshop-component](./terraform-roboshop-component) / [roboshop-infra-dev](./roboshop-infra-dev) / [vpc-module-test](./vpc-module-test): Modular component environments.

### 🟨 Phase 4: Application Containerization (Docker)
*   **The Blueprint:** Minimize image size using optimized multi-stage compilation templates.
*   **Modules:**
    *   📁 [dockerfiles](./dockerfiles) / [docker-in](./docker-in) / [roboshop-docker](./roboshop-docker): Optimized layer-cached runtime images.

### 🟨 Phase 5: Cluster Orchestration (Kubernetes & EKS)
*   **The Blueprint:** Automate service scaling, proxy rule routing, and secure storage persistence.
*   **Modules:**
    *   📁 [k8s](./k8s) / [k8-resources](./k8-resources) / [k8-roboshop](./k8-roboshop): Microservice cluster tracking matrices.
    *   📁 [k8-roboshop-volumes](./k8-roboshop-volumes): Declarative storage orchestration logic.
    *   📁 [k8-selector](./k8-selector): Object classification maps.
    *   📁 [eksctl](./eksctl) / [eksctl-in](./eksctl-in): Cluster control layer configurations.

---

## 🛠️ Microservices Architecture Matrix

| Component | Runtime | Dependency | System Function |
| :--- | :--- | :--- | :--- |
| **Frontend** | Nginx | None | Visual Client Web Engine |
| **Catalogue** | NodeJS | MongoDB | Core Product Listing Catalog |
| **User** | NodeJS | MongoDB / Redis | Authentication & Identity Profiles |
| **Cart** | NodeJS | Redis | Real-time Cache Item Tracker |
| **Shipping** | Java / Maven | MySQL | Business Logic & Delivery Rules |
| **Payment** | Python | RabbitMQ | Backend Financial Settlement Worker |


## 📈 Core Engineering Competencies Demonstrated
*   **Architectural Migration:** Practical experience migrating architectures smoothly from virtual instances (Ansible) to cloud-native footprints (Docker/Kubernetes).
*   **Network Design:** Structured multi-tier security filtering using customized cloud subnets, routing path structures, and strict security groups.
*   **State Separation:** Isolated ephemeral application runtime loops safely from stateful backend cloud databases.
  
