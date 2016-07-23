//-------------------------------------------------------------
//  Nom Document : GFBULLE.JS
//  Auteur       : G.Ferraz
//  Objet        : Info Bulle...
//  Création     : 01.12.2003
//-------------------------------------------------------------
//  Mise à Jour  : 29.05.2006
//  Objet        : Compatibilité IE6 et DOCTYPE
//  -----------------------------------------------------------
//  Mise à Jour  : 21.06.2006
//  Objet        : Prise en compte des <SELECT>
//  -----------------------------------------------------------
//  Mise à Jour  : 15.09.2006
//  Objet        : Amélioration et modif suite à commentaires
//  -----------------------------------------------------------
var DOM = (document.getElementById ? true : false);
var IE  = (document.all && !DOM ? true : false);
var NAV_OK   = ( DOM || IE );
var NETSCAPE = ( navigator.appName == 'Netscape');
var EXPLORER = ( navigator.appName == 'Microsoft Internet Explorer');
var OPERA    = ( window.opera ? true : false);
var Mouse_X;          // Position X en Cours de la Mouse
var Mouse_Y;          // Position Y en Cours de la Mouse
var TopIndex = 1;     // Z-Index interne
var Decal_X  = -10;   // Décalage X entre Pointeur Mouse et Bulle
var Decal_Y  = -10;   // Décalage Y entre Pointeur Mouse et Bulle
var bBULLE   = false; // Flag Affichage de la Bulle
// Flag pour présence Select sous IE
var bSELECT  = ( navigator.appName =='Microsoft Internet Explorer') && !OPERA;

//-- Pour Test mode Cadre
var ZObjet = new RECT();   // Zone pour MouseMove
var ZBulle = new RECT();
var bCADRE = false;        // Flag Affichage du Cadre
var bINIT  = false;
var Fenetre = new RECT();
//=========================
// Définition pour le Cadre
//=========================
function RECT(){
  this.Left   =0;
  this.Top    =0;
  this.Right  =0;
  this.Bottom =0;
  this.InitRECT = RECT_Set; 
  this.PtInRECT = RECT_PtIn; 
}
//-------------------------------------------
function RECT_Set( left_, top_, larg_, haut_){
  with( this){
    Left   = ( left_ ? left_ : -1);
    Top    = ( top_  ? top_  : -1);
    Right  = Left + ( larg_ ? (larg_ -1): 0);
    Bottom = Top  + ( haut_ ? (haut_ -1): 0);
  }
}
//-------------------------
function RECT_PtIn( x_, y_){
  with( this){
    return(( x_ > Left) && ( x_ < Right) && ( y_ > Top ) && ( y_ < Bottom));
    if( x_ < Left || x_ > Right)  return( false);
    if( y_ < Top  || y_ > Bottom) return( false);
    return( true);
  }
}
//---------------------
function GetObjet(div_){
  if( DOM) return document.getElementById(div_);
  if( IE)  return document.all[div_];
  return( null);
}
//-----------------------------
function ObjWrite( div_, html_){
  var Obj = GetObjet( div_);
  if( Obj)
    Obj.innerHTML = html_;
}
//-----------------------
function Get_DimFenetre(){
  var L_Doc;
  var H_Doc;
  var DocRef;
  
  with( Fenetre){
    if( window.innerWidth){
      with( window){
        Left   = pageXOffset;
        Top    = pageYOffset;
        Right  = innerWidth;
        Bottom = innerHeight;

        if( NETSCAPE){
          L_Doc = document.body.offsetWidth;
          H_Doc = document.body.offsetHeight;
        }
        else{
          L_Doc = document.body.clientWidth;
          H_Doc = document.body.clientHeight;
        }
        if( Right  > L_Doc) Right  = L_Doc;
        if( Bottom > H_Doc) Bottom = H_Doc;
      }
    }
    else{ // Cas Explorer à part
      if( document.documentElement && document.documentElement.clientWidth)
        DocRef = document.documentElement;
      else
        DocRef = document.body;

      with( DocRef){
        Left   = scrollLeft;
        Top    = scrollTop;
        Right  = clientWidth;
        Bottom = clientHeight;
      }
    }
    //-- limite Maxi Fenêtre Affichage
    Right  += Left;
    Bottom += Top;
  }
}
//------------------------------------
function ObjShowAll( div_, x_, y_, z_){
  var B_Obj = GetObjet( div_);
  var F_Obj = GetObjet( 'F' +div_);
  var MaxX, MaxY;
  var Haut, Larg;
  var SavY = y_;

  if( B_Obj){
    //-- Récup. dimension du DIV
    if( NETSCAPE){
      Larg = B_Obj.offsetWidth;
      Haut = B_Obj.offsetHeight;
    }
    else{
      Larg = B_Obj.scrollWidth;
      Haut = B_Obj.scrollHeight;
    }
    with( Fenetre){
      //-- Réajuste dimension fenêtre
      MaxX = Right  - Larg;
      MaxY = Bottom - Haut;

      //-- Application Bornage
      if( x_ > MaxX) x_ = MaxX;
      if( x_ < Left) x_ = Left;
      if( y_ > MaxY) y_ = MaxY;
      if( y_ < Top)  y_ = Top;
    }
    //-- si en bas On réajuste
    //-- pour que la bulle ne prenne pas le focus
    if( y_== MaxY){
      var DeltaY = MaxY -SavY;
      y_ = MaxY - DeltaY -Haut -2*Decal_Y;
    }
    //-- On place la Bulle
    if( bSELECT){//-- Ajout pour SELECT sous IE
      with(F_Obj.style){
        left       = x_ +"px";
        top        = y_ +"px";
        zIndex     = z_-1;
        visibility = "visible";
      }
    }
    with(B_Obj.style){
      left       = x_ +"px";
      top        = y_ +"px";
      zIndex     = z_;
      visibility = "visible";
    }
    //-- Affectation Zone du Rectangle
    ZBulle.InitRECT( x_, y_, Larg, Haut);
  }
}
//-- 15.09.2006 ------------------------
// Ajout Fonction Add_Event
//--------------------------------------
function Add_Event( obj_, event_, func_, mode_){
  if( obj_.addEventListener)
    obj_.addEventListener( event_, func_, mode_? mode_:false);
  else
    obj_.attachEvent( 'on'+event_, func_);
}
//-- 15.09.2006 ------------------------
// Utilisation de Add_Event
//--------------------------------------
function Init_Bulle(){
  //-- Pour les SELECT on supprime l'événement hérite
  var Obj = document.body.getElementsByTagName('SELECT');
  if( Obj && Obj.length){
    for(var i=0; i < Obj.length; i++){
      if( Obj[i].size == 1){
        for(var k=0; k < Obj[i].options.length; k++){
          Add_Event( Obj[i].options[k], 'mousemove', BulleHide);
        }
      }
      Add_Event( Obj[i], 'mousedown', BulleHide);
      Add_Event( Obj[i], 'scroll', BulleHide);
    }
  }
  else 
    bSELECT = false; // Pas de SELECT dans le document
  bINIT =true;
}
////////////////////////////
// mode Cadre Indépendant //
////////////////////////////
//------------------------
function CadreWrite( txt_){
  var Html;
  var B_Obj = GetObjet( 'Bulle');
  var F_Obj = GetObjet( 'FBulle');
  if( !bINIT) Init_Bulle();
  if( B_Obj){
    //-- Récup dimension d'affichage
    Get_DimFenetre();
    Decal_X = -10;  // Decalage dans de la Bulle
    Decal_Y = -10;
    Html  = "<TABLE BORDER='1' BORDERCOLOR='#808080' CELLSPACING=0 CELLPADDING=2 BGCOLOR='#C0C0C0'>";
    Html += "<TR><TD class='Bulle' NOWRAP>";
    Html += txt_;
    Html += "</TD></TR></TABLE>";
    B_Obj.innerHTML = Html;

    if( bSELECT){ //-- Ajout pour SELECT sous IE
      with(F_Obj.style){
        height = B_Obj.offsetHeight;
        width  = B_Obj.offsetWidth;
        left   = B_Obj.offsetLeft;
        top    = B_Obj.offsetTop;
      }
    }
    //-- On affiche le résultat
    ObjShowAll('Bulle', Mouse_X +Decal_X, Mouse_Y +Decal_Y, 1000);
    bCADRE= true;
    return( true);
  }
  return(false);
}
////////////////////////////
// mode Bulle Indépendant //
////////////////////////////
//-- 15.09.2006 ------------------------
// Ajout paramètre x_ et y_
//--------------------------------------
function BulleWrite( txt_, x_, y_){
  var B_Obj = GetObjet( 'Bulle');
  var F_Obj = GetObjet( 'FBulle');
  var Html;
  if( !bINIT) Init_Bulle();
  if( B_Obj){
    //-- Récup dimension d'affichage
    Get_DimFenetre();
    // Decalage hors de la Bulle
    Decal_X =( x_ ? x_: 5);//    Decal_X = 5 par défaut
    Decal_Y =( y_ ? y_: 5);//    Decal_Y = 5 par défaut
    //-- Ecriture de la Bulle 
    Html  = "<TABLE BORDER=0 CELLSPACING=0><TR><TD BGCOLOR='#0000c0'>";
    Html += "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=4 WIDTH='100%' BGCOLOR='#FFFFE8'>";
    Html += "<TR><TD class='Bulle' NOWRAP>";
    Html += txt_;
    Html += "</TD></TR></TABLE></TD></TR></TABLE>";
    B_Obj.innerHTML = Html;
    //-- Ajout pour SELECT sous IE
    if( bSELECT){
      with(F_Obj.style){
        height = B_Obj.offsetHeight;
        width  = B_Obj.offsetWidth;
        left   = B_Obj.offsetLeft;
        top    = B_Obj.offsetTop;
      }
    }
    //-----------------------------------------//
    // IMPORTANT on n'affiche pas la Bulle     //
    // l'événement MouseOver va avec MouseMove //
    //-----------------------------------------//
    // ObjShowAll('Bulle', Mouse_X +Decal_X, Mouse_Y +Decal_Y, 1000);
    bBULLE= true;
    return( true);
  }
 return(false);
}
//------------------
function BulleHide(){
  var B_Obj = GetObjet( 'Bulle');
  var F_Obj = GetObjet( 'FBulle');

  if( bSELECT){ //-- Ajout pour SELECT sous IE
    F_Obj.style.height = 0 +"px";
  }
  with(B_Obj){
    innerHTML        = "&nbsp;"
    style.left       = -1000 +"px";
    style.top        = -1000 +"px";
    style.zIndex     = 0;
    style.visibility = "hidden";
  }
  //-- Pose les Flags
  bCADRE = false;
  bBULLE = false;
  return(true);
}
//------------------------------------
function WhereMouse(e){
  var DocRef;
  var Obj  = null;
  var bRECT= true;
  //-- On traque les hybrides
  if( e && e.target){
    Mouse_X = e.pageX;
    Mouse_Y = e.pageY;
    Obj     = e.target;
    //-- Spécifique FireFox
    if( Obj.boxObject){
      with( Obj){
        //-- La Zone de prise en compte
        ZObjet.InitRECT( boxObject.x, boxObject.y, boxObject.width, boxObject.height);
      }
      //-- Barre de défilement et autre sous FireFox
      Obj = e.originalTarget;
      if( Obj)
        if( Obj.prefix =="xul"){
          BulleHide();
          return( true);
        }
      //-- Test pour SELECT sous FireFox
      bRECT = ZObjet.PtInRECT( Mouse_X, Mouse_Y);
    }
  }//-- Endif NETSCAPE
  else{
    if( document.documentElement && document.documentElement.clientWidth)
      DocRef = document.documentElement;
    else
      DocRef = document.body;

    Mouse_X = event.clientX +DocRef.scrollLeft;
    Mouse_Y = event.clientY +DocRef.scrollTop;
  }

  if( bBULLE)
    if( bRECT)
      ObjShowAll('Bulle', Mouse_X +Decal_X, Mouse_Y +Decal_Y, 1000);

  if( bCADRE)// on ne move pas on test juste si dans Rect
    if( !ZBulle.PtInRECT( Mouse_X, Mouse_Y))
      BulleHide();

  return( true);
}
//== INITIALISATION ==================================
//-- 15.09.2006 ------------------------
// Ajout Fonction Add_Event
// Permet de faire autre chose...
//--------------------------------------
//document.onmousemove = WhereMouse;
Add_Event( document, 'mousemove', WhereMouse);

//-- Création STYLE Bulle et DIV----------------------
var Html;
  //-- On met du style pour la bulle
  Html  = '<STYLE TYPE="text/css">';
  Html += '.Bulle{cursor:default;color:#000000;font-size:13px;font-family:Verdana;}';
  Html += '</STYLE>';
  document.write( Html);
  //-- Création du DIV Bulle
  Html ='<div id="Bulle" style="position:absolute; left:auto; top:auto; width:auto; height:auto; z-index:0; visibility:hidden"></div>';
  if( bSELECT) //-- Ajout pour SELECT sous IE
    Html +='<iframe id="FBulle" style="position:absolute;visibility:hidden;border:0px;" frameborder="0" scrolling="no">&nbsp;</iframe>';
  document.write( Html);
//-- EOF ------------------------------------------------------


