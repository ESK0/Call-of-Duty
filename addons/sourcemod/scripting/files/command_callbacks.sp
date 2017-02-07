public Action Command_Class(int client, int args)
{
  if(IsValidClient(client))
  {
    Menu_ClassList(client);
  }
  return Plugin_Handled;
}
public Action Command_Vlastnosti(int client, int args)
{
  if(IsValidClient(client))
  {
    Menu_Attributes(client);
  }
  return Plugin_Handled;
}
public Action Command_Drop(int client, int args)
{
  if(IsValidClient(client))
  {
    int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
    int iWeaponIndex;
    if(IsValidEntity(weapon))
    {
      iWeaponIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
    }
    if(iWeaponIndex == 49)
    {
      return Plugin_Continue;
    }
    else
    {
      if(i_gCurrentItem[client] != Item_None)
      {
        Client_RemoveItemEffect(client);
        PrintToChat(client, "%s Zahodil jsem item %s", CHAT_TAG, ItemNames[i_gCurrentItem[client]]);
        i_gCurrentItem[client] = Item_None;
      }
      else
      {
        PrintToChat(client, "%s Nemáš žádný item", CHAT_TAG);
      }
    }

  }
  return Plugin_Handled;
}
public Action Command_Cod(int client, int args)
{
  if(IsValidClient(client))
  {
    Menu_Cod(client);
  }
  return Plugin_Handled;
}
public Action Command_ClassInfo(int client, int args)
{
  if(IsValidClient(client))
  {
    Menu_ClassInfo(client);
  }
  return Plugin_Handled;
}
public Action Command_Item(int client, int args)
{
  if(IsValidClient(client))
  {
    switch(i_gCurrentItem[client])
    {
      case Item_None: PrintToChat(client, "%s Nevlastníš žádný item! Zabíjej protihráče k získání itemu", CHAT_TAG);
      case Item_Boty: PrintToChat(client, "%s Boty – Tvé kroky nejsou slyšet", CHAT_TAG);
      case Item_DoubleVesta: PrintToChat(client, "%s 2x Vesta – Dostaneš dvojtou vestu", CHAT_TAG);
      case Item_SpecialVesta: PrintToChat(client, "%s Special Vesta – Si víc odolný vůči granátům a explozím", CHAT_TAG);
      case Item_VeteranKnife: PrintToChat(client, "%s Veteran Knife – Zásah s knife způsobuje dvojté poškození", CHAT_TAG);
      case Item_ShockEnemy: PrintToChat(client, "%s Shock enemy – Když někoho napadneš do zad, zranení jsou 2x silnější", CHAT_TAG);
      case Item_NinjaCloak: PrintToChat(client, "%s Ninja Cloak – Jsi částečně neviditelný", CHAT_TAG);
      case Item_Morfin: PrintToChat(client, "%s Morfin – 1/3 šance, že se po smrti znovu narodíš", CHAT_TAG);
      case Item_UltraKnife: PrintToChat(client, "%s Ultra knife – Každý zásah s knife zabije enemy", CHAT_TAG);
      case Item_DeagleMaster: PrintToChat(client, "%s Deagle master – Každý zásah s knive způsobuje 2x poškození", CHAT_TAG);
      case Item_BigGrenade: PrintToChat(client, "%s Big Grenade – Okamžíté zabití protivníka s HE granátem", CHAT_TAG);
      case Item_NinjaStep: PrintToChat(client, "%s Ninja step – Dvojtý skok", CHAT_TAG);
      case Item_SecretMil: PrintToChat(client, "%s Secret Mil – Tvoje zranení jsou snížené o 1/3. Máš 1/3 šanci na oslepení nepřítele", CHAT_TAG);
      case Item_AwpSniper: PrintToChat(client, "%s AWP Sniper - Okamžité zabití s AWP", CHAT_TAG);
      case Item_Adrenalin: PrintToChat(client, "%s Adrenalin – Za každé zabití protivníka získáš +30HP", CHAT_TAG);
      case Item_Chuck: PrintToChat(client, "%s Chuck - Za každé zabití protivníka se ti doplní zásobník a +20HP", CHAT_TAG);
      case Item_XPMaster: PrintToChat(client, "%s XP Master – Za každé zabití protivníka získáš 2x víc XP", CHAT_TAG);
      case Item_NasaVesta: PrintToChat(client, "%s NASA Vesta – Tvůj armor se zvětší na 250, vydržíš víc!", CHAT_TAG);
      case Item_Veteran: PrintToChat(client, "%s Veterán – Dostaneš každé kolo +50HP a trošku pomalejší běh", CHAT_TAG);
      case Item_PrvniPomoc: PrintToChat(client, "%s První pomoc – Tlačíkem E si okamžítě doplníte HP", CHAT_TAG);
      case Item_TitanBox: PrintToChat(client, "%s Titan box – Každý zásah způsobí o +10dmg víc poškození", CHAT_TAG);
      case Item_PlukSwitch: PrintToChat(client, "%s Pluk switch – Každý zásah způsobí o +15dmg víc poškození", CHAT_TAG);
      case Item_Nanosuit: PrintToChat(client, "%s Nanosuit – Stisknutím tlačítka E dojde na 4 sekundy k úplné neviditelnosti", CHAT_TAG);
      case Item_Recruit: PrintToChat(client, "%s Recruit – Dostaneš na záčátku kola +50HP a pomalejší běh", CHAT_TAG);
      case Item_ReflectArm: PrintToChat(client, "%s Reflect Arm – 1/3 šance na odražení poškození", CHAT_TAG);
      case Item_CptBook: PrintToChat(client, "%s Cpt.book – Si imunní vůči 3 střelám nepřítele", CHAT_TAG);
      case Item_FlyModul: PrintToChat(client, "%s Stisknutím kláves E a SPACE použíješ Fly Modul,s kterým skočíš do dálky", CHAT_TAG);
      case Item_AntiGravity: PrintToChat(client, "%s AntiGravity – Budeš mít nízkou gravitaci, doskočíš vysoko", CHAT_TAG);
      case Item_Klobouk: PrintToChat(client, "%s Klobouk – Po stisknutí klávesy E dojde k úplnému doplnéní HP na 250HP", CHAT_TAG);
      case Item_GhostHelm: PrintToChat(client, "%s Ghost Helm – Dostaneš imunitu vůči 3 střelám do hlavy", CHAT_TAG);
      case Item_BunnyHoper: PrintToChat(client, "%s BunnyHoper – Skáčeš bunnyhop držením mezerníku", CHAT_TAG);
      case Item_M4Style: PrintToChat(client, "%s M4 Style – Dostaneš M4 pro postavu (Aktivace pomocí E)", CHAT_TAG);
    }
  }
  return Plugin_Handled;
}
public Action Command_Exp(int client, int args)
{
  /*char arg[10];
  GetCmdArg(args, arg, sizeof(arg));
  Client_AddClassExp(client);*/
  i_gCurrentItem[client] = Item_NinjaCloak;
  f_ClientItemStart[client] = GetGameTime();
  Client_CreateItemEffect(client);
  return Plugin_Handled;
}
public Action Command_Level(int client, int args)
{
  char arg[10];
  GetCmdArg(args, arg, sizeof(arg));
  int level = StringToInt(arg);
  i_gClientClassLvl[client][i_gCurrentClass[client]] = level;
  return Plugin_Handled;
}
public Action Command_GiveItem(int client, int args)
{
  if(IsValidClient(client))
  {
    Menu_PridatItem(client);
  }
  return Plugin_Handled;
}
