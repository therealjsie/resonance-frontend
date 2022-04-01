FROM node:lts-alpine AS frontend-build-stage

# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
RUN npm run build

FROM nginx:stable-alpine as frontend-runtime-stage
COPY --from=frontend-build-stage /app/dist /usr/share/nginx/html
COPY --from=frontend-build-stage /app/nginx-default.conf /etc/nginx/conf.d/default.conf

# support running as arbitrary user which belongs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]