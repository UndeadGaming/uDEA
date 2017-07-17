// Handle map

// Must have barrier of size 8+ on wither side of the world!!!


// Handle the tile sprites

static String folderBack = "/Assets/Graphics/Base pack/";
static String folderBase = "/Assets/Graphics/Base Pack/Tiles/";
static String folderIce  = "/Assets/Graphics/Ice expansion/Tiles/";

static String[][] tileData = new String[][] {
  
  // Background //
  /* 000 */ {"bg", "/Assets/Graphics/Base pack/bg.png"},
  
  // Grass tiles //
  /* 001 */ {"grass",                   folderBase + "grass.png"},
  /* 002 */ {"grassCenter",             folderBase + "grassCenter.png"},
  /* 003 */ {"grassCenter_rounded",     folderBase + "grassCenter_rounded.png"},
  /* 004 */ {"grassCliffLeft",          folderBase + "grassCliffLeft.png"},
  /* 005 */ {"grassCliftLeftAlt",       folderBase + "grassCliffLeftAlt.png"},
  /* 006 */ {"grassCliffRight",         folderBase + "grassCliffRight.png"},
  /* 007 */ {"grassCliffRightAlt",      folderBase + "grassCliffRightAlt.png"},
  /* 008 */ {"grassHalf",               folderBase + "grassHalf.png"},
  /* 009 */ {"grassHalfLeft",           folderBase + "grassHalfLeft.png"},
  /* 010 */ {"grassHalfMid",            folderBase + "grassHalfMid.png"},
  /* 011 */ {"grassHalfRight",          folderBase + "grassHalfRight.png"},
  /* 012 */ {"grassHillLeft",           folderBase + "grassHillLeft.png"},
  /* 013 */ {"grassHillLeft2",          folderBase + "grassHillLeft2.png"},
  /* 014 */ {"grassHillRight",          folderBase + "grassHillRight.png"},
  /* 015 */ {"grassHillRight2",         folderBase + "grassHillRight2.png"},
  /* 016 */ {"grassLedgeLeft",          folderBase + "grassLedgeLeft.png"},
  /* 017 */ {"grassLedgeRight",         folderBase + "grassLedgeRight.png"},
  /* 018 */ {"grassLeft",               folderBase + "grassLeft.png"},
  /* 019 */ {"grassMid",                folderBase + "grassMid.png"},
  /* 020 */ {"grassRight",              folderBase + "grassRight.png"},
  
  // Boxes //
  /* 021 */ {"box",                     folderBase + "box.png"},
  /* 022 */ {"boxAlt",                  folderBase + "boxAlt.png"},
  /* 023 */ {"boxCoin",                 folderBase + "boxCoin.png"},
  /* 024 */ {"boxCoin_disabled",        folderBase + "boxCoin_disabled.png"},
  /* 025 */ {"boxCoinAlt",              folderBase + "boxCoinAlt.png"},
  /* 026 */ {"boxCoinAlt_disabled",     folderBase + "boxCoinAlt_disabled.png"},
  /* 027 */ {"boxEmpty",                folderBase + "boxEmpty.png"},
  /* 028 */ {"boxExplosive",            folderBase + "boxExplosive.png"},
  /* 029 */ {"boxExplosive_disabled",   folderBase + "boxExplosive_disabled.png"},
  /* 030 */ {"boxExplosiveAlt",         folderBase + "boxExplosiveAlt.png"},
  /* 031 */ {"boxItem",                 folderBase + "boxItem.png"},
  /* 032 */ {"boxItem_disabled",        folderBase + "boxItem_disabled.png"},
  /* 033 */ {"boxItemAlt",              folderBase + "boxItemAlt.png"},
  /* 034 */ {"boxItemAlt_disabled",     folderBase + "boxItemAlt_disabled.png"},
  /* 035 */ {"boxWarning",              folderBase + "boxWarning.png"},
  
  // Doors //
  /* 036 */ {"door_closedTop",          folderBase + "door_closedTop.png"},
  
  // Elemental Blocks //
  /* 037 */ {"iceBlock",                folderIce + "iceBlock.png"},
  
  /* 038 */ {"door_closedMid",          folderBase + "door_closedMid.png"},
  
  //TUNDRA BLocks
  /* 039 */ {"tundra",                  folderIce + "tundra.png"},
  /* 040 */ {"tundraCenter",            folderIce + "tundraCenter.png"},
  /* 041 */ {"tundraCliffLeft",         folderIce + "tundraCliffLeft.png"},
  /* 042 */ {"tundraCliffLeftAlt",      folderIce + "tundraCliffLeftAlt.png"},
  /* 043 */ {"tundraCliff Right",       folderIce + "tundraCliffRight.png"},
  /* 044 */ {"tundraCliffRightAlt",     folderIce + "tundraCliffRightAlt.png"},
  /* 045 */ {"tundraLeft",              folderIce + "tundraLeft.png"},
  /* 046 */ {"tundraMid",               folderIce + "tundraMid.png"},
  /* 047 */ {"tundraRight",             folderIce + "tundraRight.png"},
  
  //Castle
  /* 048 */ {"castleCenter",            folderBase + "castleCenter.png"},
  /* 049 */ {"castleLeft",              folderBase + "castleLeft.png"},
  /* 050 */ {"castleMid",               folderBase + "castleMid.png"},
  /* 051 */ {"castleRight",             folderBase + "castleRight.png"},
  /* 052 */ {"liquidWater",             folderBase + "liquidWater.png"},
  /* 053 */ {"castleBackground",        folderBase + "castleBackground.png"},
  /* 054 */ {"castleCliffLeft",         folderBase + "castleCliffLeft.png"},
  /* 055 */ {"castleCliffRight",        folderBase + "castleCliffRight.png"},
 
};