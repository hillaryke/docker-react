# Build Phase
FROM node:alpine as builder
WORKDIR '/app'
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Run and production phase environment
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html

# to make react-router work with nginx
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
