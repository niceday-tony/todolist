# 2. High Level Architecture

## Technical Summary

The architecture will be a traditional client-server model, optimized for local MVP development. The frontend will be a Next.js single-page application (SPA) communicating with a backend REST API. The backend is an existing Spring Boot application, which connects to a MySQL database running locally in a Docker container. This setup allows for rapid, focused development of the MVP within a self-contained local environment.

## Platform and Infrastructure Choice

-   **Platform:** Docker Desktop (Local Development)
-   **Key Services:** Docker Compose, Local MySQL Container, Local Spring Boot Application, Local Next.js Development Server
-   **Deployment Host and Regions:** N/A (로컬 개발 전용)

## Repository Structure

-   **Structure:** Monorepo
-   **Monorepo Tool:** Not specified, manual management via separate `frontend` and `backend` directories.
-   **Package Organization:** `backend` (Spring Boot API), `frontend` (Next.js web app)

## High Level Architecture Diagram

```mermaid
graph TD
    subgraph User's Machine (localhost)
        subgraph Browser
            U[사용자] -- http://localhost:3000 --> F[Next.js Dev Server]
        end

        subgraph Backend
            F -- API Request (http://localhost:8080/api) --> S[Spring Boot App]
        end

        subgraph Docker
            S -- JDBC --> DB[(MySQL Container)]
        end
    end

    style F fill:#cde4ff
    style S fill:#d4edda
    style DB fill:#f5c6cb
```

## Architectural Patterns

-   **Hexagonal Architecture (Ports & Adapters):** The backend's core business logic (domain) will be isolated from external concerns like the UI, database, or other APIs. The core will communicate with the outside world through "ports" (interfaces), and the external components ("adapters") will implement these ports. _Rationale:_ This creates a loosely coupled, highly testable, and technology-agnostic application core, making it easier to maintain and evolve.
-   **Domain-Driven Design (DDD):** We will model the software to match the business domain ("감성적인 할일 목록"). This involves creating a rich domain model with entities, value objects, and aggregates, and using a Ubiquitous Language shared by developers and domain experts. _Rationale:_ Ensures the software accurately reflects and solves the core business problem, leading to a more robust and understandable design.
-   **Single Page Application (SPA):** A dynamic Next.js application will run in the browser, providing a rich user experience and making API calls to the backend for data. _Rationale:_ Decouples frontend from backend, allowing independent development and deployment.
-   **REST API (Adapter):** The Spring Boot application will expose a RESTful API. This API will be an "adapter" that translates HTTP requests into calls to the application's core logic via its ports. _Rationale:_ A standard, well-understood pattern for client-server communication that fits neatly into the Hexagonal architecture.
-   **Containerization (Docker):** The database dependency (MySQL) is managed via Docker Compose. _Rationale:_ Ensures a consistent, isolated, and easily reproducible development environment.

---
