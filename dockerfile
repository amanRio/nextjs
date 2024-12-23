# Use Node.js 20 as the base image for building
FROM node:20 AS builder

# Pass environment variables for the build process
ARG NODE_ENV
ARG BUILD_FLAG

# Disable the Nx Daemon
ENV NX_DAEMON=false

# Set the working directory for the build process
WORKDIR /app/builder

COPY . .

# Run the build commands for each application
RUN npm install
RUN npm run build 

# Use a lightweight Node.js 20 image for the final stage
FROM node:20-slim

# Set the working directory for the application
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/builder ./

# Set the environment variable for production
ENV NODE_ENV=$NODE_ENV

# Expose the application port (optional, uncomment if needed)
EXPOSE 3000

# Set the command to start the application
CMD ["npm", "start"]
