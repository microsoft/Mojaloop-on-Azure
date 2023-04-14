# Microsoft Mojaloop DFSPID Validation Service

This service validates that the request contains the DFSP ID in the header. If the request contains a valid DFSP ID then the request will pass validation and respond with a 200 OK this is only fo use between the Microsoft Azure API manager.

## Docker Build

In order to build the container:

```shell
docker build -t {devopsroot}/mojaloop-dsfpid-validation:1.0.0 .
```

## Running the api container

To run the api locally for testing the docker-compose can be used as it includes a mock database.

```shell
docker-compose up -d
```

Run the api container without mysql.

```shell
docker run -p 8080:8080 {devopsroot}/mojaloop-dsfpid-validation:lts
```

View swagger:

`http://localhost:8080/swagger`

Run the container and connect it to a mysql database.

```shell
docker run -p 5000:8080 -e "MYSQL_PASSWORD=password" -e "MYSQL_USER=root" -e "MYSQL_DATABASE=sqltest" -e "MYSQL_SERVER=localhost" {devopsroot}/mojaloop-dsfpid-validation:lts
```

### Environment Variables

|   Variable       | Description   | Default   |
|  :-----------:   |:------------: |:------------: |
|MYSQL_PASSWORD    | MySQL database users password. | password |
|MYSQL_USER        | MySQL database user. | root |
|MYSQL_DATABASE    | MySQL database name. | sqltest |
|MYSQL_SERVER      | MySQL database server instance. | localhost |
|MYSQL_PORT        | MySQL database server instance port. | 3306 |
|VALIDATION_QUERY  | Query that's being used to validate the ID (Used for testing without creating a full Mojaloop Cluster). | N/A |

### Health checks

Check if the service is running:
`curl http://localhost:8080/healthz/live`

Check if the data connection to the database is up:
`curl http://localhost:8080/healthz/ready`

## AZURE Api Manager policy example

```xml
<policies>
    <inbound>
        <base />
        <choose>
            <!--
                If a cache miss call external authorizer
            -->
            <when condition="@(!context.Variables.ContainsKey("status"))">
                <!-- Invoke -->
                <send-request mode="new" response-variable-name="authResponse" timeout="10" ignore-error="false">
                    <set-url>https://moja.nitro-corp.com/dfspid/Validate</set-url>
                    <set-method>GET</set-method>
                    <set-header name="X-DFSP-ID" exists-action="override">
                        <value>@(context.Request.Headers.GetValueOrDefault("X-DFSP-ID"))</value>
                    </set-header>
                </send-request>
                <!-- Extract authorization status from authorizer's response -->
                <set-variable name="status" value="@(((IResponse)context.Variables["authResponse"]).StatusCode)" />
            </when>
        </choose>
        <!-- Authorize the request -->
        <choose>
            <when condition="@((int)context.Variables["status"] == 200)" />
            <otherwise>
                <return-response>
                    <set-status code="401" reason="UnAuthorized" />
                    <set-body>@(((IResponse)context.Variables["authResponse"]).Body.As<JObject>(preserveContent: true).ToString())</set-body>
                </return-response>
            </otherwise>
        </choose>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
```
