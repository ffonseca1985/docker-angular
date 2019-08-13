FROM node:alpine as builder

COPY  package.json package-lock.json ./

RUN npm install && mkdir /ng-app && mv ./node_modules ./ng-app

WORKDIR /ng-app

COPY . .

RUN npm run build --prod --output-path=dist

FROM nginx:alpine

COPY nginx/default.conf /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /ng-app/dist/teste-docker /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]

