# Stage 1: Build Flutter web app
FROM ghcr.io/cirruslabs/flutter:3.41.5 AS build

WORKDIR /app
COPY complexion_ai_app/ .

RUN flutter pub get

ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY

RUN flutter build web --release \
    --dart-define=SUPABASE_URL=${SUPABASE_URL} \
    --dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}

# Stage 2: Serve with nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY complexion_ai_app/nginx.conf /etc/nginx/templates/default.conf.template

ENV PORT=8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
