# FROM node:18-alpine as build

# ENV HOME=/home/app
# WORKDIR $HOME

# COPY package.json ./
# RUN npm install --only=prod --silent

# COPY . /home/app
# RUN npm run build

# # production environment
# FROM nginx:1.16.0-alpine

# COPY --from=build /home/app /usr/share/nginx/html
# # RUN rm /ets/nginx/conf.d/default.conf
# # COPY nginx/nginx.conf /etc/nginx/conf.d
# COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]


# stage1 as builder
FROM node:10-alpine as builder

# copy the package.json to install dependencies
COPY package.json package-lock.json ./

# Install the dependencies and make the folder
RUN npm install && mkdir /react-ui && mv ./node_modules ./react-ui

WORKDIR /react-ui

COPY . .

# Build the project and copy the files
RUN npm run build


FROM nginx:alpine

#!/bin/sh

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /react-ui/build /usr/share/nginx/html

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]