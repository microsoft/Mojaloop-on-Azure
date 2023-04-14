using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Net.Http;
using System.Net;
using Newtonsoft.Json.Linq;

namespace Mojaloop.DFSPID.Function{
    public static class Mojaloop_dfspid_function{
        [FunctionName("Mojaloop_dfspid_function")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log){
            log.LogInformation("C# HTTP trigger function processed a request.");
            if(string.IsNullOrEmpty(req.Headers["X-DFSP-ID"]))
                return new ObjectResult(new HttpResponseMessage(HttpStatusCode.Unauthorized) { ReasonPhrase = "Failed to authenticate: Header Missing." }){StatusCode=401};
            int id = default(int);
            if (!int.TryParse(req.Headers["X-DFSP-ID"].ToString(), out id))
                return new ObjectResult(new HttpResponseMessage(HttpStatusCode.Unauthorized) { ReasonPhrase = "Failed to authenticate: Invalid data." }){StatusCode=401};
            bool isValidId = false;
            using(MySql.Data.MySqlClient.MySqlConnection connection = new MySql.Data.MySqlClient.MySqlConnection(
                $"SERVER={(Environment.GetEnvironmentVariable("MYSQL_SERVER")!=null? Environment.GetEnvironmentVariable("MYSQL_SERVER"):"localhost")};" +
                $"PORT={(Environment.GetEnvironmentVariable("MYSQL_DATABASE")!=null?Environment.GetEnvironmentVariable("MYSQL_DATABASE"):"3306")};" +
                $"DATABASE={(Environment.GetEnvironmentVariable("MYSQL_DATABASE")!=null?Environment.GetEnvironmentVariable("MYSQL_DATABASE"):"sqltest")};" +
                $"UID={(Environment.GetEnvironmentVariable("MYSQL_USER")!=null?Environment.GetEnvironmentVariable("MYSQL_USER"):"root")};" +
                $"PASSWORD={(Environment.GetEnvironmentVariable("MYSQL_PASSWORD")!=null?Environment.GetEnvironmentVariable("MYSQL_PASSWORD"):"Password")};")){
                try{
                    connection.Open();
                    string query = "SELECT * FROM  participant WHERE participantId = @ID";
                    using(MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(query,connection)){
                        cmd.Parameters.Add("@ID", MySql.Data.MySqlClient.MySqlDbType.Int32);
                        cmd.Parameters["@ID"].Value = id;
                        using(MySql.Data.MySqlClient.MySqlDataReader dataReader = cmd.ExecuteReader()){
                            if(dataReader.HasRows)
                                isValidId = true;
                            dataReader.Close();
                        }
                    }
                }catch(MySql.Data.MySqlClient.MySqlException ex){
                    log.LogError(ex.Message);
                    string msg = default(string);
                    switch (ex.Number){
                        case 0:
                            msg = $"Data-Error: Something Went wrong during connection, Please try again later or contact the Administrator.";
                        break;
                        case 1045:
                            msg = $"Data-Error: Something Went wrong during connection, Please try again later or contact the Administrator.";
                        break;
                        default:
                            msg = $"Data-Error: Something Went wrong during Validation, Please try again later or contact the Administrator.";
                        break;
                    }
                    return new ObjectResult(new HttpResponseMessage(HttpStatusCode.InternalServerError){ReasonPhrase=msg}){StatusCode=500};
                }
                finally{
                    try{
                        connection.Close();
                    }catch (MySql.Data.MySqlClient.MySqlException ex){
                        log.LogError(ex.Message);
                    }
                }
            }
            if(!isValidId)
                return new ObjectResult(new HttpResponseMessage(HttpStatusCode.Unauthorized) { ReasonPhrase = "Failed to authenticate." }){StatusCode=401};
            string responseMessage = $"{{\"X-DFSP-ID-VALID\":\"true\",\"X-DFSP-ID\":\"{id}\"}}";
            return new OkObjectResult(JObject.Parse(responseMessage));
        }
    }
}