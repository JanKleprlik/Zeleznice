unit mapa_priprava;

interface

uses crt;

type
     Tproperty = record
       vzdalenost:integer;
       zeme,koleje,stanice,navstiveno,projeto:boolean;
     end;
     Tstanice = record
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
procedure nastavit_stanice(pct_stanic:integer);
procedure nastavit_zem;
procedure pridej_do_mapy_zem(sourm_x,sourm_y:integer);
procedure pridej_do_mapy_vodu(sourm_x,sourm_y:integer);
procedure obarvit;
function podivej_se_okolo_souradnic(var sour_x, sour_y:integer):boolean;

implementation
procedure pridej_do_mapy_zem(sourm_x,sourm_y:integer);
begin
   map[sourm_x,sourm_y].zeme:=true;
end;
Procedure pridej_do_mapy_vodu(sourm_x,sourm_y:integer);
begin
   map[sourm_x,sourm_y].zeme:=false;
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
              pridej_do_mapy_vodu(sour_x,sour_y-1);
              sour_x:=sour_x+2;
              end;
        sour_y:=sour_y+1;
        end;
end;
procedure nastavit_stanice(pct_stanic:integer);
var sour_x,sour_y,pocitac_stanic,i:integer;
  muze:boolean;
begin
  textbackground(Red);
  randomize;
  pocitac_stanic:=0;
  repeat
    sour_x:=2*random(56)+7;
    sour_y:=random(20)+5;
    muze:=true;
    if (map[sour_x,sour_y].zeme and not podivej_se_okolo_souradnic(sour_x,sour_y))then
       begin
       if pocitac_stanic > 0 then
          begin
              for i:=1 to pocitac_stanic do                                            //forcyklus na kontrolu, aby se dve stanice nespawnuly na stejne x-ove nebo y-ove souradnici
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
       if ((pocitac_stanic = 0) or (muze = true))then                              // vytvoreni stanice
            begin
               map[sour_x,sour_y].stanice:=true;
               map[sour_x,sour_y].zeme:=false;
               map[sour_x,sour_y].vzdalenost:=0;
               stanice[pocitac_stanic].x:=sour_x;
               stanice[pocitac_stanic].y:=sour_y;
               gotoxy(sour_x,sour_y);
               write(' ',pocitac_stanic+1);
               inc(pocitac_stanic);
             end;
       end;
  until pocitac_stanic=pct_stanic;
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
                  pridej_do_mapy_zem(sour_x,sour_y);
                end;

          end;
      inc(sour_x,2);
  end;
end;
procedure obarvit;
var souro_x,souro_y:integer;
begin
  souro_y:=1;
    while souro_y <= sirka do
        begin
        souro_x:=1;
        while souro_x <= delka do
            begin
            if map[souro_x,souro_y-1].zeme = true then
               begin
               textbackground(Green);
               gotoxy(souro_x,souro_y);
               write('  ');
               end
            else
                begin
                textbackground(LightBlue);
                gotoxy(souro_x,souro_y);
                write('  ');
                end;
            inc(souro_x,2);
            end;
        inc(souro_y);
        end;
end;
function podivej_se_okolo_souradnic(var sour_x, sour_y:integer):boolean;
begin
  if map[sour_x,sour_y-1].stanice or
     map[sour_x+2,sour_y-1].stanice or
     map[sour_x+2,sour_y].stanice or
     map[sour_x+2,sour_y+1].stanice or
     map[sour_x,sour_y+1].stanice or
     map[sour_x-2,sour_y+1].stanice or
     map[sour_x-2,sour_y].stanice or
     map[sour_x-2,sour_y-1].stanice then
        begin
        podivej_se_okolo_souradnic:=true
        end
  else
      begin
      podivej_se_okolo_souradnic:=false;
      end;
end;

end.

