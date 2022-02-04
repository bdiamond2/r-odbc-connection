##This file shows how to connect to InfoAccess with odbc.

library(getPass)
library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)

user <- ""
pass <- getPass()

#ODBC connection
myconn.infoaccess <-  DBI::dbConnect(odbc::odbc(),"INFOACCESS",
                                     uid=user, pwd=pass)

myconn.infoaccess.direct <-  DBI::dbConnect(odbc::odbc(),"InfoAccess",
                                    uid=user, pwd=pass,  
                                    Driver= "Oracle in OraClient12Home1",
                                    DBQ = "ccr-scan1.doit.wisc.edu:1521/dwhp_pdb_srv.doit.wisc.edu",
                                    Schema = "UW")

rm(pass)

query <- "SELECT DISTINCT
                      UW.RETENTION_AWARDS_MAIN.ID,
                      UW.RETENTION_AWARDS_MAIN.AWARD_COMPLETION_TERM,
                      UW.RETENTION_AWARDS_PLAN.AWARD_PLAN_CODE
                    FROM
                        UW.RETENTION_AWARDS_MAIN
                        INNER JOIN UW.RETENTION_AWARDS_PLAN ON UW.RETENTION_AWARDS_PLAN.ID = UW.RETENTION_AWARDS_MAIN.ID
                                    AND UW.RETENTION_AWARDS_PLAN.AWARD_NUMBER = UW.RETENTION_AWARDS_MAIN.AWARD_NUMBER
                    WHERE   UW.RETENTION_AWARDS_MAIN.CAREER = 'UGRD'
                    AND     UW.RETENTION_AWARDS_MAIN.AWARD_COMPLETION_TERM = '1212'"
                                            

#InfoAccess Query
infoaccess.awards <- DBI::dbGetQuery(myconn.infoaccess,query)


