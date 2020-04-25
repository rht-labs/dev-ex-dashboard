FROM registry.access.redhat.com/rhscl/nginx-112-rhel7
COPY . $HOME
CMD ["nginx", "-g", "daemon off;"]
