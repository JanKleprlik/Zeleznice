unit Mapa_priprava;

interface

uses crt;

type
     Tproperty = record
       vzdalenost:integer;
       ground,track,station,visited,projeto:boolean;
     end;
     TStanice = record
       x,y:integer;
     end;

var
  map:array of array of Tproperty;
  stanice:array of Tstanice;
const
  sirka = 30;
  delka = 120;
  okraj_x = 5;
  okraj_y = 3;
  jednicka = 1;
procedure nastavit_voda;
procedure nastavit_stanice(PCT_STANIC:integer);
procedure nastavit_zem;
procedure Pridej_Do_Mapy_Zem(sourm_x,sourm_y:integer);
procedure Pridej_Do_Mapy_Vodu(sourm_x,sourm_y:integer);
procedure Obarvit;
function PodivejSeOkoloSouradnic(var sour_x, sour_y:integer):boolean;

implementation
procedure Pridej_Do_Mapy_Zem(sourm_x,sourm_y:integer);
begin
   map[sourm_x,sourm_y].ground:=true;
end;
Procedure Pridej_Do_Mapy_Vodu(sourm_x,sourm_y:integer);
begin
   map[sourm_x,sourm_y].ground:=false;
end;
procedure nastavit_voda;
var sour_x,sour_y:integer;
begin
  textbackground(LightBlue);
  sour_y:=1;
  while sour_y<=sirka do
        begin
        sour_x:=1;
        while sour_x<=delka do
              begin
              Pridej_Do_Mapy_Vodu(sour_x,sour_y-1);
              sour_x:=sour_x+2;
              end;
        sour_y:=sour_y+1;
        end;
end;
procedure nastavit_stanice(PCT_STANIC:integer);
var sour_x,sour_y,station_counter,i:integer;
  muze:boolean;
begin
  textbackground(Red);
  randomize;
  station_counter:=0;
  repeat
    sour_x:=2*random(56)+7;
    sour_y:=random(20)+5;
    muze:=true;
    if (map[sour_x,sour_y].ground and not PodivejSeOkoloSouradnic(sour_x,sour_y))then
       begin
       if station_counter > 0 then
          begin
              for i:=1 to station_counter do                                            //forcyklus na kontrolu, aby se dve stanice nespawnuly na stejne x-ove nebo y-ove souradnici
                  if muze then
                  begin
                      if ((sour_x=stanice[i-1].x) or (sour_y=stanice[i-1].y))then
                        begin
                             muze:=false;
                             break;
                        end
                      else
                          begin
                             muze:=true;
                          end;
                  end;
          end;
       if ((station_counter = 0) or (muze = true))then                              // vytvoreni stanice
            begin
               map[sour_x,sour_y].station:=true;
               map[sour_x,sour_y].ground:=false;
               map[sour_x,sour_y].vzdalenost:=0;
               stanice[station_counter].x:=sour_x;
               stanice[station_counter].y:=sour_y;
               gotoxy(sour_x,sour_y);
               write(' ',station_counter+1);
               inc(station_counter);
             end;
       end;
  until station_counter=PCT_STANIC;
end;
procedure nastavit_zem;
var sour_x,sour_y:integer;
begin
  textbackground(Green);
  sour_x:=okraj_x;
  while sour_x<=(delka-okraj_x) do
  begin
      for sour_y:=okraj_y to (sirka-okraj_y+1) do
          begin
             if (((sour_x IN [okraj_x..(okraj_x+5)] ) and (sour_y IN [okraj_y,(sirka-okraj_y+1)])) or
                ((sour_x IN [okraj_x..(okraj_x+3)] ) and (sour_y IN [(okraj_y+1),(sirka-okraj_y)])) or
                ((sour_x IN [okraj_x..(okraj_x+1)] ) and (sour_y IN [(okraj_y+2),(sirka-okraj_y-1)])) or
                ((sour_x IN [(delka-okraj_x-5)..(delka-okraj_x)] ) and (sour_y IN [okraj_y,(sirka-okraj_y+1)])) or
                ((sour_x IN [(delka-okraj_x-3)..(delka-okraj_x)] ) and (sour_y IN [(okraj_y+1),(sirka-okraj_y)])) or
                ((sour_x IN [(delka-okraj_x-1)..(delka-okraj_x)] ) and (sour_y IN [(okraj_y+2),(sirka-okraj_y-1)])))
             then else
                begin
                  Pridej_Do_Mapy_Zem(sour_x,sour_y);
                end;

          end;
      inc(sour_x,2);
  end;
end;
procedure Obarvit;
var sourO_x,sourO_y:integer;
begin
  sourO_y:=1;
    while sourO_y <= sirka do
        begin
        sourO_x:=1;
        while sourO_x <= delka do
            begin
            if map[sourO_x,sourO_y-1].ground = true then
               begin
               textbackground(Green);
               gotoxy(sourO_x,sourO_y);
               write('  ');
               end
            else
                begin
                textbackground(LightBlue);
                gotoxy(sourO_x,sourO_y);
                write('  ');
                end;
            inc(sourO_x,2);
            end;
        inc(sourO_y);
        end;
end;
function PodivejSeOkoloSouradnic(var sour_x, sour_y:integer):boolean;
begin
  if map[sour_x,sour_y-1].station or
     map[sour_x+2,sour_y-1].station or
     map[sour_x+2,sour_y].station or
     map[sour_x+2,sour_y+1].station or
     map[sour_x,sour_y+1].station or
     map[sour_x-2,sour_y+1].station or
     map[sour_x-2,sour_y].station or
     map[sour_x-2,sour_y-1].station then
        begin
        PodivejSeOkoloSouradnic:=true
        end
  else
      begin
      PodivejSeOkoloSouradnic:=false;
      end;
end;

end.

