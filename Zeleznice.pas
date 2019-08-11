program Zeleznice;

uses
  crt, mapa_priprava;
type
  Pbod = ^Tbod;
  Tbod = record
    x :integer;
    y :integer;
    dalsi:Pbod;
  end;
var
  klavesa,herni_rezim:char;
  prvnibod,poslednibod,bod,zaradtenhlebod,bod2,bod3:Pbod;
  nalezeno,souvisly_graf,je_kolem_zeleznice,tohle_kolo_mam:boolean;
  pocetcest,interace1,interace2,pocetkoleji,aktualni_vzdalenost_vlacku,i,cislostanice:integer;
  pocetstanic:integer;
  cesta:array of integer;


procedure vypis_pocet_koleji; FORWARD;
procedure nakresli_vlacek(var a:integer; var b:integer); FORWARD;
procedure smaz_vlacek; FORWARD;
procedure menu;
          begin
            clrscr;
            textcolor(yellow);
            writeln('Zeleznice':60);
            textcolor(white);
            writeln;
            writeln;
            writeln;
            writeln('        Herni mody:');
            textcolor(yellow);
            writeln('                   Minimalni cesta <M>');
            textcolor(white);
            writeln('                             Zde mas za ukol spojit dve stanice nejkratsi moznou zeleznici.');
            writeln();
            textcolor(yellow);
            writeln('                   Sandbox         <S>');
            textcolor(white);
            writeln('                              Zde si muzes vygenerovat více stanic, propojit je a sledovat vlacky.');
            writeln();
            writeln('        Prosim zvol si herni mod (M/S):');
            repeat
            herni_rezim:= readkey();
            until (herni_rezim = 's') or (herni_rezim = 'S') or (herni_rezim = 'M') or (herni_rezim = 'm');
          end;
procedure pravidla;
var pocetstanic_uzivatel:char;
begin
  if (herni_rezim = 'M') or (herni_rezim='m') then
    begin
        clrscr;
        pocetStanic:=2;
        writeln;
        writeln;
        writeln;
        writeln;
        textcolor(yellow);
        writeln('Cil':60);
        writeln;
        textcolor(white);
        writeln('        Tvym ukolem je propojit dve stanice minimalnim poctem koleji.');
        writeln('        Pocet koleji je v levem hornim rohu.');
        writeln;
        writeln;
        writeln;
        textcolor(yellow);
        Writeln('Ovladani':62);
        writeln;
        textcolor(white);
        write('                                 ');textcolor(yellow);write('W');textcolor(white);write(' - posun nahoru                       ');textcolor(yellow);write('E');textcolor(white);writeln(' - polozit koleje');
        write('                                 ');textcolor(yellow);write('A');textcolor(white);write(' - posun doleva                       ');textcolor(yellow);write('R');textcolor(white);writeln(' - smazat koleje ');
        write('                                 ');textcolor(yellow);write('S');textcolor(white);write(' - posun dolu                         ');textcolor(yellow);write('C');textcolor(white);writeln(' - rychlomod mod');
        write('                                 ');textcolor(yellow);write('D');textcolor(white);write(' - posun doprava                      ');textcolor(yellow);write('L');textcolor(white);writeln(' - spustit vlak');
        writeln;
        writeln;
        writeln;
        writeln;
        writeln;
        writeln('        Pro pokracovani zmackni jakoukoliv klavesu.');
        readkey;
    end
  else
    begin
        clrscr;
        //pocetStanic:=2;
        writeln;
        writeln;
        writeln;
        writeln;
        textcolor(yellow);
        writeln('Cil':60);
        writeln;
        textcolor(white);
        writeln('        Tvym ukolem je propojit vzdy dve nejblizsi stanice.');
        writeln('        Maximalni pocet koleji je v levem hornim rohu, ale je mozne ho prekrocit.');
        writeln;
        writeln;
        writeln;
        textcolor(yellow);
        Writeln('Ovladani':62);
        writeln;
        textcolor(white);
        write('                                 ');textcolor(yellow);write('W');textcolor(white);write(' - posun nahoru                       ');textcolor(yellow);write('E');textcolor(white);writeln(' - polozit koleje');
        write('                                 ');textcolor(yellow);write('A');textcolor(white);write(' - posun doleva                       ');textcolor(yellow);write('R');textcolor(white);writeln(' - smazat koleje ');
        write('                                 ');textcolor(yellow);write('S');textcolor(white);write(' - posun dolu                         ');textcolor(yellow);write('C');textcolor(white);writeln(' - rychlomod mod');
        write('                                 ');textcolor(yellow);write('D');textcolor(white);write(' - posun doprava                      ');textcolor(yellow);write('L');textcolor(white);writeln(' - spustit vlak');
        writeln;
        writeln;
        writeln;
        writeln;
        writeln;
        writeln('        Nyni zadej pocet stanic od 3 do 9:');
        repeat
        pocetstanic_uzivatel:=readkey;
        case pocetstanic_uzivatel of
             '3': begin pocetstanic:= 3; end;
             '4': begin pocetstanic:= 4; end;
             '5': begin pocetstanic:= 5; end;
             '6': begin pocetstanic:= 6; end;
             '7': begin pocetstanic:= 7; end;
             '8': begin pocetstanic:= 8; end;
             '9': begin pocetstanic:= 9; end;
             else begin gotoxy(9,25);Writeln('Zadej prosim cislo v rozmezi 3 az 9.'); end;
        end;
        until (pocetstanic>2) and (pocetstanic<10);
    end;
end;
procedure upozorneni;
begin
     clrscr;
     Textcolor(yellow);
     writeln;writeln;writeln;writeln;writeln;
     writeln('POZOR':60);
     textcolor(white);
     writeln('        Protoze vlaky jezdici na kolejich jsou siroke, tak se koleje od jedne stanice ke druhe nesmi nijak dotykat.');
     write('          Takoveto zapojeni koleji');textcolor(yellow);write(' JE');textcolor(white);writeln(' povolene:');
     writeln;
     gotoxy(13,10);
     textbackground(White);write('      ');
     textbackground(red);write(' 1');
     textbackground(White);write('      ');
     textbackground(White);write('      ');
     textbackground(black);write('  ');
     textbackground(White);writeln('      ');
     gotoxy(33,11);
     textbackground(red);writeln(' 2');
     writeln;
     writeln;
     writeln;
     textbackground(black);
     write('          Takoveto zapojeni koleji');textcolor(yellow);write(' NENI');textcolor(white);writeln(' povolene:');
     writeln;
     gotoxy(13,17);
     textbackground(White);write('      ');
     textbackground(red);write(' 1');
     textbackground(White);write('      ');
     textbackground(White);write('              ');
     gotoxy(19,18);
     write('  ');
     gotoxy(33,18);
     textbackground(red);writeln(' 2');
     writeln;writeln;writeln;writeln;writeln;
     textbackground(black);
     writeln('        Pokracuj zmacknutim jakekoliv klavesy.');
     readkey;
end;
procedure ukonceni;
begin
  textbackground(black);
  textcolor(white);
  gotoxy(55,15);
  write('Gratuluji.');
  gotoxy(55,16);
  write('Zmacknete cokoliv pro konec.');
  readkey();

end;
procedure pohyb_kurzor;
var
  poh_x,poh_y:integer;
  x,y:integer;
  rychlomod,konec:boolean;
          begin
            x:=3; poh_x:=0;
            y:=2; poh_y:=0;
            rychlomod:=false; konec:=false;
            gotoxy(x,y);
            repeat
                klavesa:=readkey;
                case klavesa of
                     'w': begin poh_y:=-1; poh_x:=0 end;
                     'a': begin poh_x:=-2;poh_y:=0 end;
                     's': begin poh_y:=1;poh_x:=0 end;
                     'd': begin poh_x:=2; poh_y:=0 end;
                     'r': begin
                              if not rychlomod then
                                 begin
                                      poh_x:=0;
                                      poh_y:=0;
                                 end;
                              if map[x,y].koleje = true then
                                 begin
                                      textbackground(green);write('  ');
                                      map[x,y].koleje:=false;
                                      map[x,y].zeme:=true;
                                      inc(pocetkoleji);
                                      if pocetstanic > 2 then
                                      begin
                                        textbackground(LightBlue);
                                        textcolor(yellow);
                                        gotoxy(5,1);
                                        Write('Koleje: max. ',pocetkoleji:3)
                                      end
                                   else
                                       begin
                                         vypis_pocet_koleji;
                                       end;
                                 end;
                          end;
                     'e': begin
                              if not rychlomod then
                                 begin
                                      poh_x:=0;
                                      poh_y:=0;
                                 end;
                              if map[x,y].zeme=true then
                                 begin
                                   textbackground(white);
                                   write('  ');
                                   map[x,y].koleje:=true;
                                   map[x,y].zeme:=false;
                                   dec(pocetkoleji);
                                   if pocetstanic > 2 then
                                      begin
                                        textbackground(LightBlue);
                                        textcolor(yellow);
                                        gotoxy(5,1);
                                        Write('Koleje: max. ',pocetkoleji:3)
                                      end
                                   else
                                       begin
                                         vypis_pocet_koleji;
                                       end;
                                 end;
                          end;
                     'c': begin
                               poh_x:=0;
                               poh_y:=0;
                              if rychlomod then
                                 rychlomod:=false
                              else
                                rychlomod:= true;
                          end;
                     'l': begin
                              konec:=true;
                              poh_x:=0;
                              poh_y:=0;
                         end;
                     #0 : begin
                             klavesa:=readkey;
                             case ord(klavesa) of
                                  72 : begin poh_y:=-1; poh_x:=0 end;
                                  75 : begin poh_x:=-2;poh_y:=0 end;
                                  80 : begin poh_y:=1;poh_x:=0 end;
                                  77: begin poh_x:=2; poh_y:=0 end;
                             end;
                         end;
                     else
                       begin
                            poh_x:=0;
                            poh_y:=0;
                       end;
                end;
                if ((x + poh_x) IN [3..(delka-2)])and ((y+poh_y) IN [2..(sirka-1)]) then
                   begin
                      x:=x + poh_x;
                      y:=y + poh_y;
                      gotoxy(x,y);
                   end;
            until konec=true;
          end;
Procedure velkejezero(sourp_x,sourp_y:integer);
var pocitadlo:integer;
begin
  textbackground(LightBlue);
  pridej_do_mapy_vodu(sourp_x,sourp_y);
  inc(sourp_x,2);
  pridej_do_mapy_vodu(sourp_x,sourp_y);
  inc(sourp_x,2);dec(sourp_y);

  for pocitadlo:=1 to 4 do
      begin

      pridej_do_mapy_vodu(sourp_x,sourp_y);
      dec(sourp_x,2);
      end;
  dec(sourp_y);
  for pocitadlo:=1 to 6 do
      begin
      pridej_do_mapy_vodu(sourp_x,sourp_y);
      inc(sourp_x,2);
      end;
  dec(sourp_x,2);dec(sourp_y);
  for pocitadlo:=1 to 6 do
      begin
      pridej_do_mapy_vodu(sourp_x,sourp_y);
      dec(sourp_x,2);
      end;
  inc(sourp_x,4);dec(sourp_y,1);
  for pocitadlo:=1 to 4 do
      begin
      pridej_do_mapy_vodu(sourp_x,sourp_y);
      inc(sourp_x,2);
      end;
  dec(sourp_x,4);dec(sourp_y);
  pridej_do_mapy_vodu(sourp_x,sourp_y);
  dec(sourp_x,2);
  pridej_do_mapy_vodu(sourp_x,sourp_y);
end;
procedure vytvor_jezera;
var
  jezera_pocitadlo,sour_x,sour_y:integer;
begin
  randomize;
  textbackground(LightBlue);
  for jezera_pocitadlo:=0 to 7 do                                                {1. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*jezera_pocitadlo);
        sour_y:=random(6)+ okraj_y+3;
        velkejezero(sour_x,sour_y);
      end;
  for jezera_pocitadlo:=0 to 7 do                                                {2. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*jezera_pocitadlo);
        sour_y:=random(6)+ okraj_y+10;
        velkejezero(sour_x,sour_y);
      end;
  for jezera_pocitadlo:=0 to 7 do                                                {3. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*jezera_pocitadlo);
        sour_y:=random(6)+ okraj_y+17;
        velkejezero(sour_x,sour_y);
      end;
  for jezera_pocitadlo:=0 to 7 do                                                {4. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*jezera_pocitadlo);
        sour_y:=random(6)+ okraj_y+21;
        velkejezero(sour_x,sour_y);
      end;
end;
procedure nacitani(procenta:integer);
begin
  textbackground(Black);
  textcolor(YELLOW);
  clrscr;
  writeln;
  writeln;
  gotoxy(55,15);
  writeln('Nacitam: ',procenta,' %');
  delay(750);
end;
procedure zarad_do_fronty(var bod:Pbod);
begin
  poslednibod^.dalsi := bod;
  poslednibod := bod;
end;
function vyrad_z_fronty:Pbod;
begin
  if prvnibod <> nil then
     begin
        vyrad_z_fronty := prvnibod;
        prvnibod:=prvnibod^.dalsi;
     end;
end;
procedure podivej_se_na_souradnice(a:integer; b:integer);
begin                                                 //Podívá se na zadanou souradnici vůči právě prohledávané, jestli tam není stanice
  if ((map[bod^.x+a,bod^.y+b].zeme) and (not map[bod^.x+a,bod^.y+b].navstiveno)) then
         begin
            map[bod^.x+a,bod^.y+b].navstiveno:=true;
            map[bod^.x+a,bod^.y+b].vzdalenost := map.[bod^.x,bod^.y].vzdalenost+1;
            new(zaradtenhlebod);
            zaradtenhlebod^.x := bod^.x+a;
            zaradtenhlebod^.y := bod^.y+b;
            zaradtenhlebod^.dalsi:=nil;
            zarad_do_fronty(zaradtenhlebod);
         end
        else if ((bod^.x+a <> stanice[pocetCest].x) and (bod^.y+b <> stanice[pocetcest].y) and (map[bod^.x+a,bod^.y+b].stanice)) then
         begin
            nalezeno:=true;
            map[bod^.x+a,bod^.y+b].navstiveno :=true;
            if map[bod^.x+a,bod^.y+b].vzdalenost <> 0 then
              begin
                 if map[bod^.x+a,bod^.y+b].vzdalenost < (map[bod^.x,bod^.y].vzdalenost + 1) then
                   begin
                        cesta[pocetcest]:= map[bod^.x+a,bod^.y+b].vzdalenost;
                   end
                 else
                     begin
                      cesta[pocetcest]:= map[bod^.x,bod^.y].vzdalenost;
                      map[bod^.x+a,bod^.y+b].vzdalenost:=map[bod^.x,bod^.y].vzdalenost;
                     end;
              end
            else
             begin
               map[bod^.x+a,bod^.y+b].vzdalenost:=map[bod^.x,bod^.y].vzdalenost;
               cesta[pocetcest]:= map[bod^.x,bod^.y].vzdalenost;
             end;
         end;

end;
function spocitejKoleje:integer;
var
  i:integer;
begin
  spocitejKoleje:=0;
  for i:=0 to pocetcest do
      begin
           if cesta[i] = -1 then
              begin
              spocitejKoleje:=0;
              break;
              end
           else
               begin
               spocitejKoleje:= spocitejKoleje+cesta[i];
               end;
      end;
  if pocetstanic > 2 then
     begin
     spocitejKoleje:= (spocitejKoleje div 10) * 10 + 10;
     end;
end;
procedure vypis_pocet_koleji;
begin
 gotoxy(5,1);
 textbackground(LightBlue);
 textcolor(Yellow);
 Write('Koleje: ', pocetkoleji:8);
end;
procedure nakresli_vlacek(var a:integer; var b:integer);
begin
  gotoxy(bod^.x+a,bod^.y+b);
  textbackground(white);
  textcolor(Black);
  Write('XX');
  delay(150);
end;
procedure smaz_vlacek;
begin
  gotoxy(bod3^.x,bod3^.y);
  textbackground(white);
  textcolor(Black);
  Write('  ');
end;
procedure animace_vlacku(a:integer; b:integer);
begin
    if ((map[bod^.x+a,bod^.y+b].koleje) and (not map[bod^.x+a,bod^.y+b].projeto) and (aktualni_vzdalenost_vlacku < (map[bod^.x,bod^.y].vzdalenost+1))) then
         begin
            map[bod^.x+a,bod^.y+b].projeto:=true;
            map[bod^.x+a,bod^.y+b].vzdalenost := map[bod^.x,bod^.y].vzdalenost+1;
            aktualni_vzdalenost_vlacku := map[bod^.x+a,bod^.y+b].vzdalenost;
            nakresli_vlacek(a,b);
            tohle_kolo_mam:=true;
               begin
                    bod2^.x := bod^.x+a;
                    bod2^.y := bod^.y+b;
               end;
            if (map[bod3^.x,bod3^.y].koleje) then
               begin
                  smaz_vlacek;
               end;
         end
    else if (((bod^.x+a <> stanice[cislostanice].x) and (bod^.y+b <> stanice[cislostanice].y)) and (map[bod^.x+a,bod^.y+b].stanice)) then   //hledá se tím vzdy cesta ze stanice n do stanice n+1
         begin
            nalezeno:=true;
            tohle_kolo_mam:=true;
            map[bod^.x+a,bod^.y+b].vzdalenost := map[bod^.x,bod^.y].vzdalenost + 1;
         end;
end;
procedure graf_neni_souvisly;
begin
  textbackground(Black);
  textcolor(white);
  Clrscr;
  gotoxy(40,10);
  Write('Jejda, tak thohle by se hrálo hodně dlouho. Neexistovala cesta z jedné stanice do druhé.');
  gotoxy(40,11);
  Write('Vygeneruji ti novou mapu');
  // smaze queue
  repeat
        bod:=vyrad_z_fronty;
  until (bod^.dalsi = nil) or (bod = bod^.dalsi);
  // nastavi policka jako nenavstivena
  interace1:=1;
    while interace1 <= sirka do
        begin
        interace2:=1;
        while interace2 <= delka do
            begin
               map[interace2,interace1-1].navstiveno := false;
               map[interace2,interace1-1].vzdalenost:=0;
               map[interace2,interace1-1].zeme:= false;
               map[interace2,interace1-1].stanice:= false;
               inc(interace2,2);
            end;
        inc(interace1);
        end;
    souvisly_graf:=false;
end;
begin
  // Vypsani menu
  menu;
  pravidla;
  upozorneni;

  // Zde zacina generovani mapy
  souvisly_graf:=false;
  while souvisly_graf = false do
  begin

  //Inicializace

  souvisly_graf:=true;
  poslednibod := nil;
  prvnibod := nil;
  setLength(map,delka,sirka);
  setLength(stanice,pocetstanic);

  // Nacteni vody
  nastavit_voda;
  nacitani(33);

  // Nacteni zeme
  nastavit_zem;
  nacitani(66);

  // Vygenerovani jezer
  vytvor_jezera;
  nacitani(100);
  clrscr;
  // Vykresleni
  Obarvit;

  // Vygenerovani Stanic a nalezeni nejkratších cest
  begin
  nastavit_stanice(pocetstanic);


  // Ohraniceni stanice vodou - nevykresli se na mapu
  {map[stanice[0].x,stanice[0].y-1].zeme:=false;
  map[stanice[0].x+2,stanice[0].y-1].zeme:=false;
  map[stanice[0].x+2,stanice[0].y].zeme:=false;
  map[stanice[0].x+2,stanice[0].y+1].zeme:=false;
  map[stanice[0].x,stanice[0].y+1].zeme:=false;
  map[stanice[0].x-2,stanice[0].y+1].zeme:=false;
  map[stanice[0].x-2,stanice[0].y].zeme:=false;
  map[stanice[0].x-2,stanice[0].y-1].zeme:=false;}


  // Vynulujou se cesty

  setLength(cesta,pocetstanic);
  for pocetcest:=0 to (pocetstanic-1)do
      begin
        cesta[pocetcest]:=-1;
      end;

  // postupne hledani nejkratsich cest mezi stanicemi

  for pocetcest:=0 to pocetstanic-2 do
      begin
            if souvisly_graf = true then
            begin
                new(bod);
                prvnibod := bod;
                poslednibod:=bod;
                bod^.x :=stanice[pocetcest].x;
                bod^.y :=stanice[pocetcest].y;
                bod^.dalsi := nil;
                nalezeno := false;
                zarad_do_fronty(bod);
                souvisly_graf:=true;
                interace1:=0;

                // najde vzdalenost nejblizzsi stanice od te s cislem pocetcest (vzdalenost se uklada do pole cesta[pocetcest])

                repeat
                      bod2:= bod;
                      bod:=vyrad_z_fronty;
                      if (interace1 > 2) and (bod=bod2) then   // tahle podminka kontroluje jestli se dá z jednej stanice dostat do druej
                         begin
                            bod:=nil;
                            souvisly_graf:=false;
                         end;
                      if bod <> nil then
                       begin
                            podivej_se_na_souradnice(0,-1);
                            podivej_se_na_souradnice(2,-1);
                            podivej_se_na_souradnice(2,0);
                            podivej_se_na_souradnice(2,1);
                            podivej_se_na_souradnice(0,1);
                            podivej_se_na_souradnice(-2,1);
                            podivej_se_na_souradnice(-2,0);
                            podivej_se_na_souradnice(-2,-1);
                       end;
                      inc(interace1);
                until nalezeno or (bod = nil);


                // smaze queue
                repeat
                      bod:=vyrad_z_fronty;
                until (bod^.dalsi = nil) or (bod = bod^.dalsi);


                //nastavi policka jako nenavstivena
                interace1:=1;
                  while interace1 <= sirka do
                      begin
                      interace2:=1;
                      while interace2 <= delka do
                          begin
                          if ((map[interace2,interace1-1].zeme)) then
                             begin
                             map[interace2,interace1-1].navstiveno := false;
                             map[interace2,interace1-1].vzdalenost:=0;
                             end;
                          if (map[interace2,interace1-1].stanice) then
                             begin
                             map[interace2,interace1-1].navstiveno:=false;
                             end;
                          inc(interace2,2);
                          end;
                      inc(interace1);
                      end;


                //Rozhodne, co delat, kdyz graf neni souvisly
                if souvisly_graf = false then
                   begin
                    graf_neni_souvisly;
                   end;
                end;
      end;
  end;
  end;

  // Vypsání informací ve hře

  pocetkoleji := spocitejKoleje;
  if pocetstanic > 2 then
     begin
     gotoxy(5,1);
     textbackground(LightBlue);
     textcolor(Yellow);
     Write('Koleje: max. ',pocetkoleji:3);
     end
  else
     begin
     vypis_pocet_koleji;
     end;

  // Zde hrac vytvori trat

  if pocetstanic = 2 then
     begin
     je_kolem_zeleznice:=false;
          while (pocetkoleji<>0) or (je_kolem_zeleznice = false) do
              begin
              pohyb_kurzor;
              je_kolem_zeleznice:=true;
              // overi se jestli je kolem všech stanic zeleznice, pokud jsou jen 2 (kontroluje i jeslti je pouzity spravny pocet koleji)
              for i:=0 to pocetstanic-1 do
                  begin
                  if ((pocetkoleji = 0) and (je_kolem_zeleznice))then
                     begin
                         if map[stanice[i].x,stanice[i].y-1].koleje or
                            map[stanice[i].x+2,stanice[i].y-1].koleje or
                            map[stanice[i].x+2,stanice[i].y].koleje or
                            map[stanice[i].x+2,stanice[i].y+1].koleje or
                            map[stanice[i].x,stanice[i].y+1].koleje or
                            map[stanice[i].x-2,stanice[i].y+1].koleje or
                            map[stanice[i].x-2,stanice[i].y].koleje or
                            map[stanice[i].x-2,stanice[i].y-1].koleje then
                               begin
                               je_kolem_zeleznice:=true
                               end
                         else
                             begin
                             je_kolem_zeleznice:=false;
                             end;
                      end;
                   if ((je_kolem_zeleznice = false) or (pocetkoleji <> 0)) then
                       begin // napise se poznamka hraci at to predela
                       gotoxy(5,30);
                       textbackground(LightBLue);
                       textColor(Yellow);
                       Write('Zkust to znovu.');
                       end;
                  end;
              end;
     end;
  if pocetstanic > 2 then
      begin
      je_kolem_zeleznice:=false;
          while (je_kolem_zeleznice = false) do
              begin
              pohyb_kurzor;
              je_kolem_zeleznice:=true;
              // overi se jestli je kolem všech stanic zeleznice, pokud jich je vic jak 2
              for i:=0 to pocetstanic-1 do
                  begin
                  if (je_kolem_zeleznice)then
                     begin
                         if map[stanice[i].x,stanice[i].y-1].koleje or
                            map[stanice[i].x+2,stanice[i].y-1].koleje or
                            map[stanice[i].x+2,stanice[i].y].koleje or
                            map[stanice[i].x+2,stanice[i].y+1].koleje or
                            map[stanice[i].x,stanice[i].y+1].koleje or
                            map[stanice[i].x-2,stanice[i].y+1].koleje or
                            map[stanice[i].x-2,stanice[i].y].koleje or
                            map[stanice[i].x-2,stanice[i].y-1].koleje then
                               begin
                               je_kolem_zeleznice:=true
                               end
                         else
                             begin
                             je_kolem_zeleznice:=false;
                             end;
                      end;
                   if (je_kolem_zeleznice = false) then
                       begin // napise se poznamka hraci at to predela
                       gotoxy(5,30);
                       textbackground(LightBLue);
                       textColor(Yellow);
                       Write('Zkust to znovu.');
                       end;
                  end;
              end;
      end;

  // Smaze poznamku hraci
  gotoxy(5,30);
  textbackground(LightBLue);
  textColor(Yellow);
  Write('               ');

  // Animace vláčku

  begin
       new(bod);
       new(bod3);
       new(bod2);
       for i:=0 to pocetstanic-1 do
           begin
           aktualni_vzdalenost_vlacku:=0;
           randomize;
           cislostanice:=i;
                bod3^.x :=stanice[cislostanice].x;
                bod3^.y :=stanice[cislostanice].y;
                bod^.x :=stanice[cislostanice].x;
                bod^.y :=stanice[cislostanice].y;
                nalezeno := false;

                // Provadi Animaci vlacku z jedne stanice do druhe;
                repeat
                    if not tohle_kolo_mam then
                      animace_vlacku(0,-1);
                    if not tohle_kolo_mam then
                      animace_vlacku(2,-1);
                    if not tohle_kolo_mam then
                      animace_vlacku(2,0);
                    if not tohle_kolo_mam then
                      animace_vlacku(2,1);
                    if not tohle_kolo_mam then
                      animace_vlacku(0,1);
                    if not tohle_kolo_mam then
                      animace_vlacku(-2,1);
                    if not tohle_kolo_mam then
                      animace_vlacku(-2,0);
                    if not tohle_kolo_mam then
                      animace_vlacku(-2,-1);
                    if not nalezeno then
                         begin
                              bod3^.x:=bod^.x;
                              bod3^.y:=bod^.y;
                              bod^.x:=bod2^.x;
                              bod^.y:=bod2^.y;
                         end;
                      tohle_kolo_mam:=false;
                until nalezeno;

                //VlacekDojede
                smaz_vlacek;
                bod3^.x:=bod^.x;
                bod3^.y:=bod^.y;
                smaz_vlacek;

                //koleje se nastavi jako nenavstivene
                begin
                  interace1:=1;
                  while interace1 <= sirka do
                      begin
                      interace2:=1;
                      while interace2 <= delka do
                          begin
                          if (map[interace2,interace1-1].koleje) then
                             begin
                             map[interace2,interace1-1].projeto := false;
                             end;
                          inc(interace2,2);
                          end;
                      inc(interace1);
                      end;
                end;
           end;
  end;
ukonceni;
end.
