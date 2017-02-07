public void MySql_Connect()
{
  db = SQL_Connect("hsfadverts",true, db_error, sizeof(db_error));
  if(db == null)
  {
    SQL_GetError(db, db_error, sizeof(db_error));
    SetFailState("\n\n\n[Call of Duty] Cannot connect to the DB: %s\n\n\n", db_error);
  }
  /* CREATE TABLE IF NOT EXISTS callofduty (id INT(32) NOT NULL DEFAULT NULL AUTO_INCREMENT, steamid VARCHAR(128) NOT NULL, info_sniper VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_rusher VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0',
  info_sharpshooter VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_protector VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_makarov VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_firesupport VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0',
  info_demolitions VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_cptsoap VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_ghost VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_sapper VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0',
  info_commando VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_rambo VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_cptprice VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', info_engineer VARCHAR(64) NOT NULL DEFAULT '0;0;0;0;0;0;0', PRIMARY KEY(id))*/

  SQL_Query(db, "SET CHARACTER SET utf8");
  PrintToServer("[Call of Duty] Connected to MySQL successfuly!");
}
public void MySql_LoadClient(int client)
{
  char steamid[32];
  char e_steamid[32];
  GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
  ExplodeSteamId(steamid,e_steamid,sizeof(e_steamid));
  Format (db_query, sizeof(db_query), "SELECT * FROM callofduty WHERE steamid='%s'", e_steamid);
  SQL_TQuery(db, MySql_OnLoadPlayer, db_query, client);
}
public void MySql_OnLoadPlayer(Handle owner, Handle query, const char[] error, any client)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[Call of Duty] MySql-Query failed! Error: %s\n\n\n", error);
  }
  else
  {
    b_ClientVerified[client] = false;
    char steamid[32];
    char e_steamid[32];
    GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
    ExplodeSteamId(steamid,e_steamid,sizeof(e_steamid));
    if(!SQL_FetchRow(query))
    {
      Handle datapack = CreateDataPack();
      WritePackCell(datapack, client);
      WritePackString(datapack, e_steamid);
      Format(db_query, sizeof(db_query), "INSERT INTO callofduty (steamid) VALUES ('%s')",e_steamid);
      SQL_TQuery(db, MySql_OnInsertPlayerToDB, db_query, datapack);
    }
    else
    {
      Format (db_query, sizeof(db_query), "SELECT * FROM callofduty WHERE steamid='%s'", e_steamid);
      SQL_TQuery(db, MySql_OnLoadPlayerPost, db_query, client);
    }
  }
  CloseHandle(query);
}
public void MySql_OnInsertPlayerToDB(Handle owner, Handle query, const char[] error, any datapack)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[FurienGO] MySql-Query failed! Error: %s\n\n\n", error);
  }
  else
  {
    char e_steamid[32];
    ResetPack(datapack);
    int client = ReadPackCell(datapack);
    ReadPackString(datapack, e_steamid, sizeof(e_steamid));
    Format (db_query, sizeof(db_query), "SELECT * FROM callofduty WHERE steamid='%s'", e_steamid);
    SQL_TQuery(db, MySql_OnLoadPlayerPost, db_query, client);
  }
  CloseHandle(query);
}
public void MySql_OnLoadPlayerPost(Handle owner, Handle query, const char[] error, any client)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[[Call of Duty] MySql-Query failed! Error: %s\n\n\n", error);
  }
  else
  {
    if(SQL_FetchRow(query))
    {
      char sClientData[32];
      char sClientDataExploded[7][32];
      for(int i = 2; i < 16; i++)
      {
        SQL_FetchString(query, i, sClientData, sizeof(sClientData))
        ExplodeString(sClientData, ";", sClientDataExploded, sizeof(sClientDataExploded), sizeof(sClientDataExploded[]));
        i_gClientClassLvl[client][view_as<ClassType>(i-1)] = StringToInt(sClientDataExploded[0]);
        i_gClientClassExp[client][view_as<ClassType>(i-1)] = StringToInt(sClientDataExploded[1]);
        for(int x; x < view_as<int>(Attri_Count); x++)
        {
          i_gClientClassAttributes[client][view_as<ClassType>(i-1)][view_as<ClassAttributes>(x)] = StringToInt(sClientDataExploded[x+2]);
        }
        i_gClientClassAttributesPoints[client][view_as<ClassType>(i-1)] = StringToInt(sClientDataExploded[6]);
      }
      b_ClientVerified[client] = true;
    }
  }
  CloseHandle(query);
}
stock void MySql_SaveClient(int client)
{
  if(b_ClientVerified[client] == true)
  {
    char steamid[32];
    char e_steamid[32];

    char sClientData[15][64]
    GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
    ExplodeSteamId(steamid,e_steamid,sizeof(e_steamid));
    for(int i = 1 ; i < view_as<int>(Class_Count); i++)
    {
      Format(sClientData[i], sizeof(sClientData), "%i;%i;%i;%i;%i;%i;%i",
        i_gClientClassLvl[client][view_as<ClassType>(i)],
        i_gClientClassExp[client][view_as<ClassType>(i)],
        i_gClientClassAttributes[client][view_as<ClassType>(i)][view_as<ClassAttributes>(0)],
        i_gClientClassAttributes[client][view_as<ClassType>(i)][view_as<ClassAttributes>(1)],
        i_gClientClassAttributes[client][view_as<ClassType>(i)][view_as<ClassAttributes>(2)],
        i_gClientClassAttributes[client][view_as<ClassType>(i)][view_as<ClassAttributes>(3)],
        i_gClientClassAttributesPoints[client][view_as<ClassType>(i)]);
    }
    Format(db_query, sizeof(db_query), "UPDATE callofduty SET info_sniper='%s', info_rusher='%s', info_sharpshooter='%s', info_protector='%s', info_makarov='%s', info_firesupport='%s', info_demolitions='%s', info_cptsoap='%s', info_ghost='%s', info_sapper='%s', info_commando='%s', info_rambo='%s', info_cptprice='%s', info_engineer='%s' WHERE steamid='%s'", sClientData[1], sClientData[2], sClientData[3], sClientData[4], sClientData[5], sClientData[6], sClientData[7], sClientData[8], sClientData[9], sClientData[10], sClientData[11], sClientData[12], sClientData[13], sClientData[14], e_steamid);
    if(db != null)
    {
      SQL_TQuery(db, MySql_OnSaveClient, db_query, client);
    }
  }
}
public void MySql_OnSaveClient(Handle owner, Handle query, const char[] error, any money)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[FurienGO] MySql-Query failed! Error: %s\n\n\n", error);
  }
  CloseHandle(query);
}
