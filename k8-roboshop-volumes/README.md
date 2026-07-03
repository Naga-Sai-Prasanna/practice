## K8s RoboShop — Volumes

Kubernetes manifests for deploying **RoboShop** with persistent storage (EBS-backed StatefulSets) and autoscaling, on top of the base [k8-roboshop](https://github.com/Naga-Sai-Prasanna/k8-roboshop) app.

- **Docker Hub:** [kopparthiprasanna](https://hub.docker.com/u/kopparthiprasanna) — service images (`kopparthiprasanna/<service>:<tag>`)

## Overview

This repo extends the base RoboShop deployment with:
- A custom **EBS StorageClass** for dynamic volume provisioning
- **StatefulSets** (instead of Deployments) for stateful components like `mongodb`, giving each pod stable identity and its own persistent volume
- A **headless Service** for direct pod-to-pod DNS resolution between StatefulSet replicas
- A **HorizontalPodAutoscaler (HPA)** for stateless services like `catalogue`, scaling on CPU utilization

## Repository Structure

```
k8-roboshop-volumes/
├── 01-namespace.yaml     # roboshop namespace
├── 04-ebs-sc.yaml        # EBS StorageClass (roboshop-ebs)
├── catalogue/
│   └── manifest.yaml     # ConfigMap + Deployment + Service + HPA
├── mongodb/
│   └── manifest.yaml     # Headless Service + StatefulSet + PVC template
└── README.md
```

## Prerequisites

- A Kubernetes cluster on AWS (EKS) with the **EBS CSI driver** installed, since `04-ebs-sc.yaml` provisions `gp2`/`gp3`-backed EBS volumes dynamically
- `kubectl` configured to point at the target cluster
- Cluster/IAM permissions to create StorageClasses, PVCs, and provision EBS volumes
- Metrics Server installed in-cluster (required for the HPA to read CPU utilization)

## Manifest Details

### `04-ebs-sc.yaml` — StorageClass
Defines the `roboshop-ebs` StorageClass used by StatefulSet volume claim templates to dynamically provision EBS volumes on pod creation.

### `mongodb/manifest.yaml` — StatefulSet + Headless Service
```yaml
# Headless service — clusterIP: None, gives each pod a stable DNS name
# (mongodb-0.mongodb-headless, mongodb-1.mongodb-headless, ...)
kind: Service
metadata:
  name: mongodb-headless
spec:
  clusterIP: None
  ports:
  - port: 27017
    targetPort: 27017
---
kind: StatefulSet
metadata:
  name: mongodb
spec:
  serviceName: "mongodb-headless"
  replicas: 3
  minReadySeconds: 10
  template:
    spec:
      containers:
      - name: mongodb
        image: kopparthiprasanna/mongodb:1.0.0
        volumeMounts:
        - name: mongodb
          mountPath: /data/db
  volumeClaimTemplates:
  - metadata:
      name: mongodb
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: "roboshop-ebs"
      resources:
        requests:
          storage: 1Gi
```
Each of the 3 replicas (`mongodb-0`, `mongodb-1`, `mongodb-2`) gets its own 1Gi EBS-backed PVC and a stable network identity, so data and pod identity survive restarts/rescheduling.

### `catalogue/manifest.yaml` — ConfigMap + Deployment + Service + HPA
Same three-object pattern as the base app (ConfigMap for env vars, Deployment for the app container with readiness/liveness probes, Service exposing port 8080), plus:
```yaml
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef:
    kind: Deployment
    name: catalogue
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 20
```
The HPA scales `catalogue` between 1–10 replicas, targeting 20% average CPU utilization across pods.

The `catalogue` ConfigMap points it at MongoDB via the base app's ClusterIP service name (`mongodb://mongodb:27017/catalogue`) — if only the headless Service is deployed in this repo, make sure a `mongodb` ClusterIP Service (from the base app) is also applied, or update `MONGO_URL` to target `mongodb-headless` / a specific pod DNS name.

## Deployment

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd k8-roboshop-volumes
   ```

2. **Create the namespace**
   ```bash
   kubectl apply -f 01-namespace.yaml
   ```

3. **Create the StorageClass**
   ```bash
   kubectl apply -f 04-ebs-sc.yaml
   ```

4. **Deploy MongoDB (StatefulSet)**
   ```bash
   kubectl apply -f mongodb/manifest.yaml
   ```
   Wait for all 3 replicas to become Ready before deploying dependents:
   ```bash
   kubectl rollout status statefulset/mongodb -n roboshop
   ```

5. **Deploy catalogue (Deployment + HPA)**
   ```bash
   kubectl apply -f catalogue/manifest.yaml
   ```

## Verifying the Deployment

```bash
kubectl get sc                                  # confirm roboshop-ebs StorageClass exists
kubectl get pvc -n roboshop                      # confirm PVCs bound for each mongodb replica
kubectl get statefulset,pods -n roboshop -o wide
kubectl get hpa -n roboshop -w                   # watch HPA scale catalogue
```

Check StatefulSet pod identity/DNS:
```bash
kubectl exec -it mongodb-0 -n roboshop -- mongosh --eval "rs.status()"
```

## Scaling Notes

- **MongoDB replicas**: bump `spec.replicas` in the StatefulSet — each new pod gets its own new PVC automatically via the volume claim template. Note this manifest does not configure MongoDB replica-set initialization; add that separately if you need actual Mongo replication (as opposed to just 3 independently-provisioned pods).
- **Catalogue replicas**: managed automatically by the HPA (1–10) based on CPU; manual `kubectl scale` will be overridden by the HPA on its next sync.

## Cleanup

```bash
kubectl delete -f catalogue/manifest.yaml
kubectl delete -f mongodb/manifest.yaml
kubectl delete -f 04-ebs-sc.yaml
kubectl delete namespace roboshop
```
> Deleting a StatefulSet does **not** delete its PVCs/EBS volumes by default — delete the PVCs explicitly if you want the underlying EBS volumes reclaimed:
> ```bash
> kubectl delete pvc -l component=mongodb -n roboshop
> ```