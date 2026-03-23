# Stage 1: Build Flutter web app
FROM ghcr.io/cirruslabs/flutter:3.41.5 AS build

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web --release --no-wasm-dry-run

# Stage 2: Serve with nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/templates/default.conf.template

ENV PORT=8080

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
