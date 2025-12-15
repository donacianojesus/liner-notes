# Liner Notes Backend

A Spring Boot REST API for Liner Notes - a music journaling application with intentional sharing.

## Tech Stack

- **Java 17**
- **Spring Boot 3.2.1**
- **PostgreSQL** - Primary database
- **Redis** - Caching layer
- **JWT** - Authentication
- **Flyway** - Database migrations
- **Maven** - Build tool

## Project Structure

```
src/main/java/com/linernotes/
├── config/          # Configuration classes (Security, Redis, CORS)
├── controller/      # REST API endpoints
├── service/         # Business logic
├── repository/      # JPA repositories
├── model/           # Entity classes
├── dto/             # Data Transfer Objects
├── security/        # JWT utilities
├── exception/       # Exception handling
└── integration/     # External API clients (Spotify)
```

## Setup Instructions

### Prerequisites

1. **Java 17** or higher installed
2. **Maven** installed
3. **PostgreSQL** installed and running
4. **Redis** installed and running (optional for initial setup)

### Step 1: Database Setup

Create a PostgreSQL database:

```sql
CREATE DATABASE linernotes;
```

### Step 2: Configure Application Properties

Edit `src/main/resources/application.properties`:

```properties
# Update these values
spring.datasource.username=
spring.datasource.password=

# Add Spotify API credentials
spotify.client.id=
spotify.client.secret=

# Generate a secure JWT secret
jwt.secret=
```

### Step 3: Install Dependencies

```bash
mvn clean install
```

### Step 4: Run the Application

```bash
mvn spring-boot:run
```

The API will start on `http://localhost:8080`

### Step 5: Verify Setup

Test the API:

```bash
curl http://localhost:8080/api/test/hello
```

Expected response:
```json
{
  "message": "Liner Notes API is running!",
  "timestamp": "2025-12-15T...",
  "status": "OK"
}
```

## Database Schema

Flyway will automatically create these tables on first run:

- `users` - User accounts
- `albums` - Cached Spotify album metadata
- `journal_entries` - Private music reflections
- `public_posts` - Shared journal entries (one per day limit)
- `user_saved_posts` - Bookmarked posts

## Security

- JWT-based authentication (stateless)
- BCrypt password encryption
- CORS configured for frontend origins
- Rate limiting with Bucket4j (to be implemented)

## API Endpoints (Planned)

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login and get JWT token

### Journal Entries (Private)
- `POST /api/journal` - Create journal entry
- `GET /api/journal` - Get user's journal entries
- `PUT /api/journal/{id}` - Update journal entry
- `DELETE /api/journal/{id}` - Delete journal entry

### Public Feed
- `POST /api/posts/share` - Share journal entry (once per day)
- `GET /api/posts/feed` - Get public feed (chronological/random)
- `POST /api/posts/{id}/save` - Bookmark a post
- `GET /api/posts/saved` - Get saved posts

### Spotify Integration
- `GET /api/spotify/search?q={query}` - Search albums
- `GET /api/spotify/album/{id}` - Get album details

## Testing

```bash
# Run tests
mvn test

# Run with coverage
mvn test jacoco:report
```

## Build for Production

```bash
mvn clean package
java -jar target/liner-notes-backend-0.0.1-SNAPSHOT.jar
```

## Next Steps

1. Initial project setup
2. Implement authentication (JWT)
3. Create journal entry endpoints
4. Implement Spotify API integration
5. Create public sharing logic
6. Add Redis caching
7. Deploy to AWS

## Environment Variables (Production)

```bash
SPRING_DATASOURCE_URL=
SPRING_DATASOURCE_USERNAME=
SPRING_DATASOURCE_PASSWORD=
SPRING_DATA_REDIS_HOST=
JWT_SECRET=
SPOTIFY_CLIENT_ID=
SPOTIFY_CLIENT_SECRET=
```

## Troubleshooting

### Database connection fails
- Verify PostgreSQL is running: `pg_isready`
- Check credentials in `application.properties`

### Redis connection fails
- Start Redis: `redis-server`
- Or disable Redis temporarily in config

### Port 8080 already in use
- Change port in `application.properties`: `server.port=8081`
