FROM alpine:latest
RUN apk update && apk upgrade && apk add nginx
RUN mkdir -p /run/nginx && mkdir -p /usr/share/nginx
RUN chown -R nginx:nginx /var/lib/nginx && chown -R nginx:nginx /usr/share/nginx
COPY ./index.html /usr/share/nginx
COPY ./nginx.conf /etc/nginx 
EXPOSE 8080
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
