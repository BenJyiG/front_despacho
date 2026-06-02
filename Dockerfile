# Stage 1: Build (Construcción del proyecto)
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production (Servidor web ligero y seguro)
FROM nginx:alpine AS runner

# Copiar los archivos compilados desde el stage builder al directorio de Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Modificar permisos para usar usuario NO ROOT por seguridad (IE1)
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx

# Cambiar al usuario sin privilegios
USER nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
