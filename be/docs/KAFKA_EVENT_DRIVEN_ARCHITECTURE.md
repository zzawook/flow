# Kafka Event-Driven Architecture

## Overview

The application has been refactored to use an event-driven architecture using Apache Kafka. This decouples the REST controllers from the service layer, improving scalability, reliability, and maintainability.

## Architecture

### Before (Synchronous)
```
REST Controller → Service Layer → Database/External APIs
```

### After (Event-Driven)
```
REST Controller → Kafka Topic → Event Consumer → Service Layer → Database/External APIs
```

## Components

### 1. Event Models
- **FinverseWebhookEvent**: Represents webhook events from Finverse
- **FinverseAuthCallbackEvent**: Represents auth callback events

### 2. Kafka Configuration
- **KafkaConfig**: Configures producers and consumers
- **application.properties**: Kafka connection and topic settings

### 3. Event Producer
- **KafkaEventProducerService**: Publishes events to Kafka topics

### 4. Event Consumers
- **FinverseWebhookEventConsumer**: Processes webhook events asynchronously
- **FinverseAuthCallbackEventConsumer**: Processes auth callback events asynchronously

### 5. Updated Controllers
- **FinverseWebhookController**: Now publishes events instead of calling services directly
- **FinverseAuthCallbackController**: Now publishes events instead of calling services directly

## Kafka Topics

| Topic Name                      | Description                  | Event Type                |
| ------------------------------- | ---------------------------- | ------------------------- |
| `finverse-webhook-events`       | Webhook events from Finverse | FinverseWebhookEvent      |
| `finverse-auth-callback-events` | Auth callback events         | FinverseAuthCallbackEvent |

## Configuration

### application.properties
```properties
# Kafka Configuration
spring.kafka.bootstrap-servers=localhost:9092
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.springframework.kafka.support.serializer.JsonSerializer
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.springframework.kafka.support.serializer.JsonDeserializer
spring.kafka.consumer.group-id=flow-backend
spring.kafka.consumer.auto-offset-reset=earliest
spring.kafka.consumer.properties.spring.json.trusted.packages=sg.flow.events

# Kafka Topics
flow.kafka.topics.finverse-webhook=finverse-webhook-events
flow.kafka.topics.finverse-auth-callback=finverse-auth-callback-events
```

## Benefits

1. **Decoupling**: Controllers are decoupled from service implementations
2. **Scalability**: Can easily scale consumers independently
3. **Reliability**: Kafka provides message persistence and retry mechanisms
4. **Monitoring**: Can monitor event flow through Kafka UI (http://localhost:8080)
5. **Fault Tolerance**: Failed events can be retried automatically

## Event Flow

### Webhook Event Flow
1. External service sends webhook to `/finverse/webhooks`
2. `FinverseWebhookController` creates `FinverseWebhookEvent`
3. Event is published to `finverse-webhook-events` topic
4. `FinverseWebhookEventConsumer` processes the event
5. Original service logic is executed asynchronously

### Auth Callback Event Flow
1. External service sends callback to `/finverse/callback`
2. `FinverseAuthCallbackController` creates `FinverseAuthCallbackEvent`
3. Event is published to `finverse-auth-callback-events` topic
4. `FinverseAuthCallbackEventConsumer` processes the event
5. `FinverseQueryService.fetchLoginIdentity()` is called asynchronously

## Monitoring

- Kafka UI is available at http://localhost:8080
- View topics, messages, and consumer groups
- Monitor event processing and any failures

## Development Notes

- Events include unique IDs and timestamps for tracking
- Consumers log processing status for debugging
- Failed events will trigger retry mechanisms
- All original functionality is preserved but executed asynchronously 