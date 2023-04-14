# Azure Function

Install the Azure function plugin on vscode to easily debug this function.

## Configure Function

See step guide to configure appsettings for a function.

https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings?tabs=portal

### Available settings:

|   Variable       | Description   | Default   |
|  :-----------:   |:------------: |:------------: |
|MYSQL_PASSWORD    | MySQL database users password. | password |
|MYSQL_USER        | MySQL database user. | root |
|MYSQL_DATABASE    | MySQL database name. | sqltest |
|MYSQL_SERVER      | MySQL database server instance. | localhost |
|MYSQL_PORT        | MySQL database server instance port. | 3306 |

docker compose included for a local mysql to test against.

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