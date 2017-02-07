public void Menu_Attributes(int client)
{
  char buffer[32];
  Menu menu = CreateMenu(m_Attributes);
  menu.SetTitle("- Vlastnost  [%iB] -", i_gClientClassAttributesPoints[client][i_gCurrentClass[client]]);
  Format(buffer, sizeof(buffer), "Intellect [%i]", i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Intellect]);
  menu.AddItem("intellect", buffer, i_gClientClassAttributesPoints[client][i_gCurrentClass[client]] < 1?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  Format(buffer, sizeof(buffer), "Life [%i]", i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Life]);
  menu.AddItem("life", buffer, i_gClientClassAttributesPoints[client][i_gCurrentClass[client]] < 1?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  Format(buffer, sizeof(buffer), "Strenght [%i]", i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Strength]);
  menu.AddItem("strenght", buffer, i_gClientClassAttributesPoints[client][i_gCurrentClass[client]] < 1?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  Format(buffer, sizeof(buffer), "Condition [%i]", i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Condition]);
  menu.AddItem("condition", buffer, i_gClientClassAttributesPoints[client][i_gCurrentClass[client]] < 1?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_ClassList(int client)
{
  char id[3];
  char buffer[64];
  char temp[32];
  char level[24];
  char lvlnum[3];
  Menu menu = CreateMenu(m_ClassList);
  menu.SetTitle("- Zvolte si Class -");
  for(int i = 1; i < view_as<int>(Class_Count); i++)
  {
    IntToString(i_gClientClassLvl[client][view_as<ClassType>(i)],lvlnum, sizeof(lvlnum))
    IntToString(i, id, sizeof(id));
    Format(level, sizeof(level), "[Level: %s]", i_gClientClassLvl[client][view_as<ClassType>(i)] == i_LevelMax?"MAX":lvlnum);
    Format(temp, sizeof(temp), "%s %s", ClassNames[i], (ClassVIP[i] > 0?(ClassVIP[i] == 2?(IsClientVIP(client, g_AccType[ACC_EVIP])?"[AKTIVNÍ]":"[Pouze pro EVIP]"):(ClassVIP[i] == 1?(IsClientVIP(client, g_AccType[ACC_VIP])?"[AKTIVNÍ]":"[Pouze pro VIP]"):"")):"[AKTIVNÍ]"));
    Format(buffer, sizeof(buffer), "%s %s", ClassVIP[i] > 0?(IsClientVIP(client, g_AccType[ClassVIP[i]])?(i_gCurrentClass[client] == view_as<ClassType>(i)?temp:ClassNames[i]):temp):i_gCurrentClass[client] == view_as<ClassType>(i)?temp:ClassNames[i], ClassVIP[i] > 0?(IsClientVIP(client, g_AccType[ClassVIP[i]])?level:""):level);
    menu.AddItem(id, buffer, ClassVIP[i] > 0?(IsClientVIP(client, g_AccType[ClassVIP[i]])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED):i_gCurrentClass[client] == view_as<ClassType>(i)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  }
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_Cod(int client)
{
  Menu menu = CreateMenu(m_Cod);
  menu.SetTitle("Herní menu (/cod)");
  menu.AddItem("class", "Změnit postavu");
  menu.AddItem("classinfo", "Popis postav");
  menu.AddItem("iteminfo", "Popis Itemů");
  menu.AddItem("gameinfo", "Popis hry");
  menu.AddItem("settings", "Nastavení");
  menu.AddItem("vip", "VIP Aktivace");
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_Settings(int client)
{
  Menu menu = CreateMenu(m_settings);
  menu.SetTitle("Herní menu (/cod)");
  menu.AddItem("fastmenu", i_Settings[client][Settings_FastMenu] == 0?"Fast Menu [ ZAPNUTO ]":"Fast Menu [ VYPNUTO ]");
  menu.AddItem("music", i_Settings[client][Settings_Music] == 0?"Music [ ZAPNUTO ]":"Music [ VYPNUTO ]");
  menu.AddItem("hud", i_Settings[client][Settings_Hud] == 0?"Hud [ ZAPNUTO ]":"Hud [ VYPNUTO ]");
  menu.ExitBackButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_ClassInfo(int client)
{
  char id[3];
  Menu menu = CreateMenu(m_classinfo);
  menu.SetTitle("Vlastnosti postav");
  for(int i = 1; i < view_as<int>(Class_Count); i++)
  {
    IntToString(i, id, sizeof(id));
    menu.AddItem(id,ClassNames[i]);
  }
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_PridatItem(int client)
{
  Menu menu = CreateMenu(m_pridatitem);
  menu.SetTitle("- Přidat Item -");

  char sItem[32];
  for(int i = 1; i < view_as<int>(Item_Count); i++)
  {
    IntToString(i, sItem, sizeof(sItem));
    menu.AddItem(sItem, ItemNames[i]);
  }
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
