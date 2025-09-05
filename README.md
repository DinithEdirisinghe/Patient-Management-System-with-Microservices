# Patient Management System with Microservices

A comprehensive patient management system built using **Spring Boot microservices architecture** with **gRPC** communication and **PostgreSQL** database. The system demonstrates modern microservices patterns, containerization with Docker, and inter-service communication.

## 🏗️ Architecture Overview

The system consists of two main microservices:

- **Patient Service**: Manages patient data and operations
- **Billing Service**: Handles billing account creation and management

Both services communicate through **gRPC** for efficient inter-service communication and are containerized using **Docker** with **Docker Compose** orchestration.

## 🛠️ Technology Stack

### Backend Technologies

- **Java 21**
- **Spring Boot 3.3.3**
- **Spring Data JPA**
- **Spring Web**
- **gRPC** (Google Remote Procedure Call)
- **Protocol Buffers (protobuf)**

### Database

- **PostgreSQL** (Production database)
- **H2** (Development/Testing - currently commented out)

### Documentation & Validation

- **OpenAPI 3.0** (Swagger)
- **Jakarta Validation** (Bean Validation)

### DevOps & Containerization

- **Docker**
- **Docker Compose**
- **Maven** (Build tool)

### gRPC Libraries

- `grpc-netty-shaded`
- `grpc-protobuf`
- `grpc-stub`
- `grpc-spring-boot-starter`

## 📁 Project Structure

```
Patient Management System with Microservices/
├── docker-compose.yml
├── patient-service/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/pm/patient_service/
│   │   │   │   ├── controller/PatientController.java
│   │   │   │   ├── service/PatientService.java
│   │   │   │   ├── model/Patient.java
│   │   │   │   ├── repository/PatientRepository.java
│   │   │   │   ├── dto/
│   │   │   │   ├── mapper/PatientMapper.java
│   │   │   │   ├── grpc/BillingServiceGrpcClient.java
│   │   │   │   └── exception/
│   │   │   ├── resources/
│   │   │   │   ├── application.properties
│   │   │   │   └── data.sql
│   │   │   └── proto/billing_service.proto
│   │   └── test/
│   ├── Dockerfile
│   └── pom.xml
├── billing-service/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/pm/billing_service/
│   │   │   │   ├── grpc/BillingGrpcService.java
│   │   │   │   └── BillingServiceApplication.java
│   │   │   ├── resources/application.properties
│   │   │   └── proto/billing_service.proto
│   │   └── test/
│   ├── Dockerfile
│   └── pom.xml
└── README.md
```

## 🚀 Services Description

### Patient Service

**Port**: 4000  
**Database**: PostgreSQL (port 5000)

#### Features:

- ✅ **CRUD Operations** for patient management
- ✅ **RESTful API** endpoints
- ✅ **Data validation** with Jakarta Validation
- ✅ **Email uniqueness** validation
- ✅ **gRPC Client** integration with Billing Service
- ✅ **Swagger documentation** available
- ✅ **PostgreSQL integration** with JPA/Hibernate

#### API Endpoints:

- `GET /patients` - Retrieve all patients
- `POST /patients` - Create a new patient
- `PUT /patients/{id}` - Update an existing patient
- `DELETE /patients/{id}` - Delete a patient

#### Patient Entity Fields:

- `id` (UUID, auto-generated)
- `name` (String, required)
- `email` (String, required, unique)
- `address` (String, required)
- `dateOfBirth` (LocalDate, required)
- `registeredDate` (LocalDate, required)

### Billing Service

**Port**: 4001  
**gRPC Port**: 9001

#### Features:

- ✅ **gRPC Server** implementation
- ✅ **Billing account creation** via gRPC
- ✅ **Spring Boot gRPC integration**
- ✅ **Protocol Buffers** for message definition
- ✅ **Logging** for service monitoring

#### gRPC Service:

- `CreateBillingAccount` - Creates billing accounts when patients are registered

## 🐳 Docker Configuration

### Services in Docker Compose:

1. **patient-service-db** (PostgreSQL)

   - Port: 5000:5432
   - Database: `db`
   - Username: `admin_user`
   - Password: `password`

2. **patient-service**

   - Port: 4000:4000
   - Depends on: patient-service-db

3. **billing-service**
   - Ports: 4001:4001, 9001:9001
   - Depends on: patient-service-db

### Networks:

- `internal_db_network` - Bridge network for inter-service communication

### Volumes:

- `patient-service-db-data` - Persistent PostgreSQL data storage

## 🚦 Getting Started

### Prerequisites

- **Java 21**
- **Maven 3.6+**
- **Docker & Docker Compose**

### Running the Application

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd "Patient Management System with Microservices"
   ```

2. **Build and run with Docker Compose**

   ```bash
   docker-compose up -d --build
   ```

3. **Access the services**
   - Patient Service API: http://localhost:4000/patients
   - Swagger Documentation: http://localhost:4000/swagger-ui.html
   - PostgreSQL Database: localhost:5000

### Development Setup

1. **Run PostgreSQL locally** (optional)

   ```bash
   docker run -d -p 5000:5432 -e POSTGRES_DB=db -e POSTGRES_USER=admin_user -e POSTGRES_PASSWORD=password postgres:latest
   ```

2. **Run Patient Service**

   ```bash
   cd patient-service
   mvn spring-boot:run
   ```

3. **Run Billing Service**
   ```bash
   cd billing-service
   mvn spring-boot:run
   ```

## 🔄 Inter-Service Communication

The system demonstrates **gRPC communication** between microservices:

1. When a patient is created via the Patient Service REST API
2. Patient Service automatically calls Billing Service via gRPC
3. Billing Service creates a corresponding billing account
4. Response is logged and processed

### gRPC Protocol Definition

```protobuf
syntax = "proto3";

service BillingService {
  rpc CreateBillingAccount (BillingRequest) returns (BillingResponse);
}

message BillingRequest {
  string patientId = 1;
  string name = 2;
  string email = 3;
}

message BillingResponse {
  string accountId = 1;
  string status = 2;
}
```

## 🧪 Testing

### Manual Testing

1. **Create a Patient**

   ```bash
   curl -X POST http://localhost:4000/patients \
   -H "Content-Type: application/json" \
   -d '{
     "name": "John Doe",
     "email": "john.doe@example.com",
     "address": "123 Main St",
     "dateOfBirth": "1990-01-01",
     "registeredDate": "2025-01-01"
   }'
   ```

2. **Get All Patients**

   ```bash
   curl http://localhost:4000/patients
   ```

3. **Check Logs** for gRPC communication
   ```bash
   docker-compose logs billing-service
   ```

## 🛡️ Security & Validation

- **Email validation** with proper format checking
- **Email uniqueness** enforcement
- **Required field validation** for all patient data
- **Data integrity** with database constraints
- **Input sanitization** through Jakarta Validation

## 📊 Key Features Implemented

✅ **Microservices Architecture**  
✅ **RESTful API Design**  
✅ **gRPC Inter-Service Communication**  
✅ **PostgreSQL Database Integration**  
✅ **Docker Containerization**  
✅ **Data Validation & Error Handling**  
✅ **Swagger API Documentation**  
✅ **Maven Build Configuration**  
✅ **Protocol Buffers Implementation**  
✅ **Spring Boot Auto-Configuration**

## 📈 Future Enhancements

- [ ] **Authentication & Authorization** (JWT, OAuth2)
- [ ] **API Gateway** (Spring Cloud Gateway)
- [ ] **Service Discovery** (Eureka, Consul)
- [ ] **Distributed Tracing** (Zipkin, Jaeger)
- [ ] **Circuit Breaker** (Resilience4j)
- [ ] **Message Queuing** (RabbitMQ, Apache Kafka)
- [ ] **Monitoring & Metrics** (Prometheus, Grafana)
- [ ] **Unit & Integration Testing**
- [ ] **CI/CD Pipeline** (GitHub Actions, Jenkins)
- [ ] **Configuration Management** (Spring Cloud Config)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Spring Boot, gRPC, and Docker**
