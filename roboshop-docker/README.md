# RoboShop Docker

A fully Dockerized deployment of the **RoboShop** microservices e-commerce application, using optimized, lightweight (Alpine-based) images for each service and a single `docker-compose.yaml` to orchestrate the entire stack.

## What This Does

Each RoboShop component has its own folder containing a `Dockerfile`, built and run together via Docker Compose. This is a more production-minded follow-up to the manual installation steps practiced in [`docker-in`](https://github.com/Naga-Sai-Prasanna/docker-in) — here, every service is containerized, image-optimized, and wired together with proper dependency ordering, networking, and persistent storage.

## Services

| Folder | Service | Depends On | Notes |
|--------|---------|------------|-------|
| `catalogue/` | Catalogue API | `mongodb` | |
| `user/` | User API | `redis`, `mongodb` | |
| `cart/` | Cart API | `redis`, `catalogue` | |
| `shipping/` | Shipping API | `mysql`, `cart` | |
| `payment/` | Payment API | `rabbitmq`, `cart`, `user` | Connects to `cart` and `user` via env vars (`CART_HOST`, `USER_HOST`), and to RabbitMQ via `AMQP_*` env vars |
| `frontend/` | Nginx frontend | `catalogue`, `user`, `cart`, `shipping`, `payment` | Exposed on port `80` |
| `mongodb/` | MongoDB | — | Custom Dockerfile, persists to a named volume |
| `mysql/` | MySQL | — | Custom Dockerfile, persists to a named volume |

**Pulled directly from official images (no custom Dockerfile needed):**

| Service | Image | Notes |
|---------|-------|-------|
| `redis` | `redis:7.0` | Persists to a named volume |
| `rabbitmq` | `rabbitmq:3` | Configured with `RABBITMQ_DEFAULT_USER` / `RABBITMQ_DEFAULT_PASS`, persists to a named volume |

## Images

All custom-built services are pushed to Docker Hub under `kopparthiprasanna/<service>:1.0.0`, built from Alpine-based images where possible to keep image sizes small.

## Networking & Storage

- All services run on a dedicated bridge network named `roboshop` (created automatically by Compose, not external)
- Persistent named volumes are used for all stateful services: `mongodb`, `redis`, `mysql`, `rabbitmq`

## Prerequisites

- Docker and Docker Compose installed (see [`docker-in`](https://github.com/Naga-Sai-Prasanna/docker-in) for installation steps on EC2)

## Usage

Build and start the full stack:

```bash
docker compose up -d --build
```

Check status:

```bash
docker compose ps
```

View logs for a specific service:

```bash
docker compose logs -f frontend
```

Access the app via the frontend, exposed on port 80 of the host:

```
http://<host-ip>
```

Tear down (containers and network, keeping volumes):

```bash
docker compose down
```

Tear down completely, including persisted data:

```bash
docker compose down -v
```

## Notes

- `payment`'s environment variables hardcode service hostnames/ports and RabbitMQ credentials for this compose setup — review and externalize these (e.g. via an `.env` file) before using outside local/dev environments.
- Build order is automatically handled by Compose's `depends_on`, but `depends_on` only waits for the container to **start**, not for the service inside it to be ready — add healthchecks if services fail intermittently on first boot.

## Status

This is a personal learning/practice project for containerizing a microservices application with Docker and Docker Compose, part of a broader RoboShop deployment exercise also covering Ansible, Shell scripting, Terraform, and EKS in separate repos.