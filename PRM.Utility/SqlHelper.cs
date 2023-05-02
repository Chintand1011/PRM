using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
namespace PatientPortal.DataLayer
{
    public static class SqlHelper
    {
        
        /// Execute Procedure using Procedure name and Dictionary Parameters.
        public static object ExecuteScalarProcedureParams(string procName, Dictionary<string, object> cmdParams)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                    conn.Open();
                    var sqlCommand = new SqlCommand(procName, conn) { CommandType = CommandType.StoredProcedure };

                    foreach (var param in cmdParams)
                    {
                        sqlCommand.Parameters.AddWithValue(param.Key, param.Value);
                    }
                    return sqlCommand.ExecuteScalar();
                }
            }
            catch (Exception ex)
            {
                ex.Data.Add("SqlData", GetSqlInformation(procName, cmdParams));
                throw ex;
            }
        }

        /// Get result in Datatable by passing Procedure Name and Dictionary Parameters.
        public static DataTable ExecuteDataTableProcedureParams(string procName, Dictionary<string, object> cmdParams)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                    conn.Open();
                    var sqlCommand = new SqlCommand(procName, conn) { CommandType = CommandType.StoredProcedure };

                    foreach (var param in cmdParams)
                    {
                        sqlCommand.Parameters.AddWithValue(param.Key, param.Value);
                    }
                    var dataTable = new DataTable();
                    var dataAdapter = new SqlDataAdapter(sqlCommand);
                    dataAdapter.Fill(dataTable);
                    return dataTable;  
                }
            }
            catch (Exception ex)
            {
                ex.Data.Add("SqlData", GetSqlInformation(procName, cmdParams));
                throw ex;
            }
        }

        /// Get result in DataReader by passing Procedure Name and Dictionary Parameters.
        /// Depreciated 9/1/2016. DataReader should be closed immediately after use, and thus we pass back Datatable instead. Use ExecuteDataTableProcedureParams(). - JHV
        //public static SqlDataReader ExecuteDataTableProcedureParams(string procName, Dictionary<string, object> cmdParams)
        //{
        //    try
        //    {
        //        using (SqlConnection conn = new SqlConnection())
        //        {
        //            conn.ConnectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        //            conn.Open();
        //            var sqlCommand = new SqlCommand(procName, conn) { CommandType = CommandType.StoredProcedure };

        //            foreach (var param in cmdParams)
        //            {
        //                sqlCommand.Parameters.AddWithValue(param.Key, param.Value);
        //            }

        //            return sqlCommand.ExecuteReader();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ex.Data.Add("SqlData", GetSqlInformation(procName, cmdParams));
        //        throw ex;
        //    }
        //}

        private static string GetSqlInformation(string procName, Dictionary<string, object> cmdParams)
        {
            var sqlData = "exec " + procName;
            sqlData = cmdParams.Aggregate(sqlData, (current, param) => current + string.Format(" {0} = '{1}',", param.Key, param.Value));
            return sqlData.Substring(0,sqlData.Length-1);
        }

        public static string GetSqlData(IDictionary data)
        {
            var sqlInformation = "N/A";
            if (data.Count > 0)
                foreach (var sqlError in from DictionaryEntry sqlError in data select sqlError)
                {
                    sqlInformation = sqlError.Value.ToString();
                }

            return sqlInformation;
        }
    }
}
