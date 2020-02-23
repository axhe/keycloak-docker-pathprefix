# keycloak-docker-pathprefix
Keycloak docker image that allows deploying it under a custom path prefix like /keycloak. This allows you to deploy keycloak together with other applications in a single nginx.

Also this docker image adds a healthcheck for using it with docker-swarm.

This is setup through the added environment variable KEYCLOAK_PATH_PREFIX, see the example below on how to use it.

## Deploy with docker swarm

    docker stack deploy keycloak --compose-file docker-compose.yml 

## docker-compose.yml (for docker swarm)

    version: "3.3"

    services:
    postgres-keycloak:
        image: postgres:11
        environment:
            POSTGRES_DB: keycloak
            POSTGRES_USER: keycloak
            POSTGRES_PASSWORD_FILE: "/run/secrets/postgres-keycloak-password"
        volumes:
        - /mnt/data/container-data/postgres-keycloak/:/var/lib/postgresql/data
        networks:
        - default
        secrets:
        - postgres-keycloak-password


    keycloak:
        image: heax/keycloak-pathprefix:latest
        environment:
            KEYCLOAK_PATH_PREFIX: keycloak
            PROXY_ADDRESS_FORWARDING: "true"
            DB_VENDOR: POSTGRES
            DB_ADDR: postgres-keycloak
            DB_DATABASE: keycloak
            DB_USER: keycloak
            DB_SCHEMA: public
            DB_PASSWORD_FILE: "/run/secrets/postgres-keycloak-password"
            KEYCLOAK_USER: admin
            KEYCLOAK_PASSWORD_FILE: "/run/secrets/keycloak-admin-password"
        # Uncomment the line below if you want to specify JDBC parameters. The parameter below is just an example, and it shouldn't be used in production without knowledge. It is highly recommended that you read the PostgreSQL JDBC driver documentation in order to use it.
        #JDBC_PARAMS: "ssl=true"
        networks:
        - default
        ports:
        - 8080:8080
        secrets:
        - postgres-keycloak-password
        - keycloak-admin-password
    
    networks:
        default:

    secrets:
        postgres-keycloak-password:
            external: true
        keycloak-admin-password:
            external: true

## nginx.conf example

    location /keycloak/ {
        proxy_pass          http://keycloak_host:port/keycloak/;
        proxy_set_header    Host               $host;
        proxy_set_header    X-Real-IP          $remote_addr;
        proxy_set_header    X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Host   $host;
        proxy_set_header    X-Forwarded-Server $host;
        proxy_set_header    X-Forwarded-Port   $server_port;
        proxy_set_header    X-Forwarded-Proto  $scheme;

        # required for some of the larger tokens
        proxy_buffer_size          128k;
        proxy_buffers              4 256k;
        proxy_busy_buffers_size    256k;
    }