program Zeleznice;

uses
  crt, Mapa_priprava;
type
  PBod = ^TBod;
  TBod = record
    x :integer;
    y :integer;
    dalsi:PBod;
  end;
var
  key,herniMod:char;
  PrvniBod,PosledniBod,bod,zaradtenhlebod,bod2,bod3:PBod;
  Nalezeno,SouvislyGraf,JeKolemZeleznice,TohleKoloMam:boolean;
  PocetCest,interace1,interace2,PocetKoleji,AktualniVzdalenostVlacku,i,CisloStanice:integer;
  PocetStanic:integer;
  cesta:array of integer;


procedure vypisPocetKoleji; FORWARD;
procedure NakresliVlacek(var a:integer; var b:integer); FORWARD;
procedure SmazVlacek; FORWARD;
procedure Menu_screen;
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
            herniMod:= readkey();
            until (herniMod = 's') or (herniMod = 'S') or (herniMod = 'M') or (herniMod = 'm');
          end;
procedure pravidla_screen;
var PocetStanic_Uzivatel:char;
begin
  if (herniMod = 'M') or (herniMod='m') then
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
        write('                                 ');textcolor(yellow);write('S');textcolor(white);write(' - posun dolu                         ');textcolor(yellow);write('C');textcolor(white);writeln(' - drag mod');
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
        write('                                 ');textcolor(yellow);write('S');textcolor(white);write(' - posun dolu                         ');textcolor(yellow);write('C');textcolor(white);writeln(' - drag mod');
        write('                                 ');textcolor(yellow);write('D');textcolor(white);write(' - posun doprava                      ');textcolor(yellow);write('L');textcolor(white);writeln(' - spustit vlak');
        writeln;
        writeln;
        writeln;
        writeln;
        writeln;
        writeln('        Nyni zadej pocet stanic od 3 do 9:');
        repeat
        PocetStanic_Uzivatel:=readkey;
        case PocetStanic_Uzivatel of
             '3': begin PocetStanic:= 3; end;
             '4': begin PocetStanic:= 4; end;
             '5': begin PocetStanic:= 5; end;
             '6': begin PocetStanic:= 6; end;
             '7': begin PocetStanic:= 7; end;
             '8': begin PocetStanic:= 8; end;
             '9': begin PocetStanic:= 9; end;
             else begin gotoxy(9,25);Writeln('Zadej prosim cislo v rozmezi 3 az 9.'); end;
        end;
        until (PocetStanic>2) and (PocetStanic<10);
    end;
end;
procedure Warning_screen;
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
procedure Ending_screen;
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
  mov_x,mov_y:integer;
  x,y:integer;
  drag,quit:boolean;
          begin
            x:=3; mov_x:=0;
            y:=2; mov_y:=0;
            drag:=false; quit:=false;
            gotoxy(x,y);
            repeat
                key:=readkey;
                case key of
                     'w': begin mov_y:=-1; mov_x:=0 end;
                     'a': begin mov_x:=-2;mov_y:=0 end;
                     's': begin mov_y:=1;mov_x:=0 end;
                     'd': begin mov_x:=2; mov_y:=0 end;
                     'r': begin
                              if not drag then
                                 begin
                                      mov_x:=0;
                                      mov_y:=0;
                                 end;
                              if map[x,y].track = true then
                                 begin
                                      textbackground(green);write('  ');
                                      map[x,y].track:=false;
                                      map[x,y].ground:=true;
                                      inc(PocetKoleji);
                                      if PocetStanic > 2 then
                                      begin
                                        textbackground(LightBlue);
                                        textcolor(yellow);
                                        gotoxy(5,1);
                                        Write('Koleje: max. ',PocetKoleji:3)
                                      end
                                   else
                                       begin
                                         VypisPocetKoleji;
                                       end;
                                 end;
                          end;
                     'e': begin
                              if not drag then
                                 begin
                                      mov_x:=0;
                                      mov_y:=0;
                                 end;
                              if map[x,y].ground=true then
                                 begin
                                   textbackground(white);
                                   write('  ');
                                   map[x,y].track:=true;
                                   map[x,y].ground:=false;
                                   dec(PocetKoleji);
                                   if PocetStanic > 2 then
                                      begin
                                        textbackground(LightBlue);
                                        textcolor(yellow);
                                        gotoxy(5,1);
                                        Write('Koleje: max. ',PocetKoleji:3)
                                      end
                                   else
                                       begin
                                         VypisPocetKoleji;
                                       end;
                                 end;
                          end;
                     'c': begin
                               mov_x:=0;
                               mov_y:=0;
                              if drag then
                                 drag:=false
                              else
                                drag:= true;
                          end;
                     'l':
                         begin
                              quit:=true;
                              mov_x:=0;
                              mov_y:=0;
                         end;
                     else
                       begin
                            mov_x:=0;
                            mov_y:=0;
                       end;
                end;
                if ((x + mov_x) IN [3..(delka-2)])and ((y+mov_y) IN [2..(sirka-1)]) then
                   begin
                      x:=x + mov_x;
                      y:=y + mov_y;
                      gotoxy(x,y);
                   end;
            until quit=true;
          end;
Procedure Velke_jezero(sourp_x,sourp_y:integer);
var counter:integer;
begin
  textbackground(LightBlue);
  Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
  inc(sourp_x,2);
  Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
  inc(sourp_x,2);dec(sourp_y);

  for counter:=1 to 4 do
      begin

      Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
      dec(sourp_x,2);
      end;
  dec(sourp_y);
  for counter:=1 to 6 do
      begin
      Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
      inc(sourp_x,2);
      end;
  dec(sourp_x,2);dec(sourp_y);
  for counter:=1 to 6 do
      begin
      Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
      dec(sourp_x,2);
      end;
  inc(sourp_x,4);dec(sourp_y,1);
  for counter:=1 to 4 do
      begin
      Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
      inc(sourp_x,2);
      end;
  dec(sourp_x,4);dec(sourp_y);
  Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
  dec(sourp_x,2);
  Pridej_Do_Mapy_Vodu(sourp_x,sourp_y);
end;
procedure Vytvor_jezera;
var
  ponds_counter,sour_x,sour_y:integer;
begin
  randomize;
  textbackground(LightBlue);
  for Ponds_counter:=0 to 7 do                                                {1. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*Ponds_counter);
        sour_y:=random(6)+ okraj_y+3;
        Velke_jezero(sour_x,sour_y);
      end;
  for Ponds_counter:=0 to 7 do                                                {2. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*Ponds_counter);
        sour_y:=random(6)+ okraj_y+10;
        Velke_jezero(sour_x,sour_y);
      end;
  for Ponds_counter:=0 to 7 do                                                {3. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*Ponds_counter);
        sour_y:=random(6)+ okraj_y+17;
        Velke_jezero(sour_x,sour_y);
      end;
  for Ponds_counter:=0 to 7 do                                                {4. rada jezirek}
      begin
        sour_x:=2*random(6)+ okraj_x +(14*Ponds_counter);
        sour_y:=random(6)+ okraj_y+21;
        Velke_jezero(sour_x,sour_y);
      end;
end;
procedure Nacitani(percents:integer);
begin
  textbackground(Black);
  textcolor(YELLOW);
  clrscr;
  writeln;
  writeln;
  gotoxy(55,15);
  writeln('LOADING: ',percents,' %');
  delay(750);
end;
procedure Enqueue(var bod:PBod);
begin
  PosledniBod^.dalsi := bod;
  PosledniBod := bod;
end;
function Dequeue:PBod;
begin
  if PrvniBod <> nil then
     begin
        Dequeue := PrvniBod;
        PrvniBod:=PrvniBod^.dalsi;
     end;
end;
procedure podivejSeNaSouradnice(a:integer; b:integer);
begin                                                 //Podívá se na zadanou souradnici vůči právě prohledávané, jestli tam není stanice
  if ((map[bod^.x+a,bod^.y+b].ground) and (not map[bod^.x+a,bod^.y+b].visited)) then
         begin
            map[bod^.x+a,bod^.y+b].visited:=true;
            map[bod^.x+a,bod^.y+b].vzdalenost := map.[bod^.x,bod^.y].vzdalenost+1;
            new(zaradtenhlebod);
            zaradtenhlebod^.x := bod^.x+a;
            zaradtenhlebod^.y := bod^.y+b;
            zaradtenhlebod^.dalsi:=nil;
            Enqueue(zaradtenhlebod);
         end
        else if ((bod^.x+a <> stanice[pocetCest].x) and (bod^.y+b <> stanice[PocetCest].y) and (map[bod^.x+a,bod^.y+b].station)) then
         begin
            nalezeno:=true;
            map[bod^.x+a,bod^.y+b].visited :=true;
            if map[bod^.x+a,bod^.y+b].vzdalenost <> 0 then
              begin
                 if map[bod^.x+a,bod^.y+b].vzdalenost < (map[bod^.x,bod^.y].vzdalenost + 1) then
                   begin
                        cesta[PocetCest]:= map[bod^.x+a,bod^.y+b].vzdalenost;
                   end
                 else
                     begin
                      cesta[PocetCest]:= map[bod^.x,bod^.y].vzdalenost;
                      map[bod^.x+a,bod^.y+b].vzdalenost:=map[bod^.x,bod^.y].vzdalenost;
                     end;
              end
            else
             begin
               map[bod^.x+a,bod^.y+b].vzdalenost:=map[bod^.x,bod^.y].vzdalenost;
               cesta[PocetCest]:= map[bod^.x,bod^.y].vzdalenost;
             end;
         end;

end;
function spocitejKoleje:integer;
var
  i:integer;
begin
  spocitejKoleje:=0;
  for i:=0 to PocetCest do
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
  if PocetStanic > 2 then
     begin
     spocitejKoleje:= (spocitejKoleje div 10) * 10 + 10;
     end;
end;
procedure vypisPocetKoleji;
begin
 gotoxy(5,1);
 textbackground(LightBlue);
 textcolor(Yellow);
 Write('Koleje: ', PocetKoleji:8);
end;
procedure NakresliVlacek(var a:integer; var b:integer);
begin
  gotoxy(bod^.x+a,bod^.y+b);
  textbackground(white);
  textcolor(Black);
  Write('XX');
  delay(150);
end;
procedure SmazVlacek;
begin
  gotoxy(bod3^.x,bod3^.y);
  textbackground(white);
  textcolor(Black);
  Write('  ');
end;
procedure AnimaceVlacku(a:integer; b:integer);
begin
    if ((map[bod^.x+a,bod^.y+b].track) and (not map[bod^.x+a,bod^.y+b].projeto) and (AktualniVzdalenostVlacku < (map[bod^.x,bod^.y].vzdalenost+1))) then
         begin
            map[bod^.x+a,bod^.y+b].projeto:=true;
            map[bod^.x+a,bod^.y+b].vzdalenost := map[bod^.x,bod^.y].vzdalenost+1;
            AktualniVzdalenostVlacku := map[bod^.x+a,bod^.y+b].vzdalenost;
            NakresliVlacek(a,b);
            TohleKoloMam:=true;
               begin
                    bod2^.x := bod^.x+a;
                    bod2^.y := bod^.y+b;
               end;
            if (map[bod3^.x,bod3^.y].track) then
               begin
                  SmazVlacek;
               end;
         end
    else if (((bod^.x+a <> stanice[CisloStanice].x) and (bod^.y+b <> stanice[CisloStanice].y)) and (map[bod^.x+a,bod^.y+b].station)) then   //hledá se tím vzdy cesta ze stanice n do stanice n+1
         begin
            nalezeno:=true;
            tohlekolomam:=true;
            map[bod^.x+a,bod^.y+b].vzdalenost := map[bod^.x,bod^.y].vzdalenost + 1;
         end;
end;
procedure GrafNeniSouvislyHandler;
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
        bod:=Dequeue;
  until (bod^.dalsi = nil) or (bod = bod^.dalsi);
  // nastavi policka jako nenavstivena
  interace1:=1;
    while interace1 <= sirka do
        begin
        interace2:=1;
        while interace2 <= delka do
            begin
               map[interace2,interace1-1].visited := false;
               map[interace2,interace1-1].vzdalenost:=0;
               map[interace2,interace1-1].ground:= false;
               map[interace2,interace1-1].station:= false;
               inc(interace2,2);
            end;
        inc(interace1);
        end;
    SouvislyGraf:=false;
end;
begin
  // Vypsani menu
  menu_screen;
  pravidla_screen;
  warning_screen;

  // Zde zacina generovani mapy
  SouvislyGraf:=false;
  while SouvislyGraf = false do
  begin

  //Inicializace

  SouvislyGraf:=true;
  PosledniBod := nil;
  PrvniBod := nil;
  setLength(map,delka,sirka);
  setLength(stanice,PocetStanic);

  // Nacteni vody
  nastavit_voda;
  Nacitani(33);

  // Nacteni zeme
  nastavit_zem;
  Nacitani(66);

  // Vygenerovani jezer
  Vytvor_jezera;
  Nacitani(100);
  clrscr;
  // Vykresleni
  Obarvit;

  // Vygenerovani Stanic a nalezeni nejkratších cest
  begin
  nastavit_stanice(PocetStanic);


  // Ohraniceni stanice vodou - nevykresli se na mapu
  {map[stanice[0].x,stanice[0].y-1].ground:=false;
  map[stanice[0].x+2,stanice[0].y-1].ground:=false;
  map[stanice[0].x+2,stanice[0].y].ground:=false;
  map[stanice[0].x+2,stanice[0].y+1].ground:=false;
  map[stanice[0].x,stanice[0].y+1].ground:=false;
  map[stanice[0].x-2,stanice[0].y+1].ground:=false;
  map[stanice[0].x-2,stanice[0].y].ground:=false;
  map[stanice[0].x-2,stanice[0].y-1].ground:=false;}


  // Vynulujou se cesty

  setLength(cesta,PocetStanic);
  for PocetCest:=0 to (PocetStanic-1)do
      begin
        cesta[PocetCest]:=-1;
      end;

  // postupne hledani nejkratsich cest mezi stanicemi

  for PocetCest:=0 to PocetStanic-2 do
      begin
            if SouvislyGraf = true then
            begin
                new(bod);
                PrvniBod := bod;
                PosledniBod:=bod;
                bod^.x :=stanice[PocetCest].x;
                bod^.y :=stanice[PocetCest].y;
                bod^.dalsi := nil;
                nalezeno := false;
                Enqueue(bod);
                SouvislyGraf:=true;
                interace1:=0;

                // najde vzdalenost nejblizzsi stanice od te s cislem PocetCest (vzdalenost se uklada do pole cesta[PocetCest])

                repeat
                      bod2:= bod;
                      bod:=Dequeue;
                      if (interace1 > 2) and (bod=bod2) then   // tahle podminka kontroluje jestli se dá z jednej stanice dostat do druej
                         begin
                            bod:=nil;
                            SouvislyGraf:=false;
                         end;
                      if bod <> nil then
                       begin
                            podivejSeNaSouradnice(0,-1);
                            podivejSeNaSouradnice(2,-1);
                            podivejSeNaSouradnice(2,0);
                            podivejSeNaSouradnice(2,1);
                            podivejSeNaSouradnice(0,1);
                            podivejSeNaSouradnice(-2,1);
                            podivejSeNaSouradnice(-2,0);
                            podivejSeNaSouradnice(-2,-1);
                       end;
                      inc(interace1);
                until nalezeno or (bod = nil);


                // smaze queue
                repeat
                      bod:=Dequeue;
                until (bod^.dalsi = nil) or (bod = bod^.dalsi);


                //nastavi policka jako nenavstivena
                interace1:=1;
                  while interace1 <= sirka do
                      begin
                      interace2:=1;
                      while interace2 <= delka do
                          begin
                          if ((map[interace2,interace1-1].ground)) then
                             begin
                             map[interace2,interace1-1].visited := false;
                             map[interace2,interace1-1].vzdalenost:=0;
                             end;
                          if (map[interace2,interace1-1].station) then
                             begin
                             map[interace2,interace1-1].visited:=false;
                             end;
                          inc(interace2,2);
                          end;
                      inc(interace1);
                      end;


                //Rozhodne, co delat, kdyz graf neni souvisly
                if SouvislyGraf = false then
                   begin
                    grafNeniSouvislyHandler;
                   end;
                end;
      end;
  end;
  end;

  // Vypsání informací ve hře

  PocetKoleji := spocitejKoleje;
  if PocetStanic > 2 then
     begin
     gotoxy(5,1);
     textbackground(LightBlue);
     textcolor(Yellow);
     Write('Koleje: max. ',PocetKoleji:3);
     end
  else
     begin
     vypisPocetKoleji;
     end;

  // Zde hrac vytvori trat

  if PocetStanic = 2 then
     begin
     JeKolemZeleznice:=false;
          while (PocetKoleji<>0) or (JeKolemZeleznice = false) do
              begin
              pohyb_kurzor;
              JeKolemZeleznice:=true;
              // overi se jestli je kolem všech stanic zeleznice, pokud jsou jen 2 (kontroluje i jeslti je pouzity spravny pocet koleji)
              for i:=0 to PocetStanic-1 do
                  begin
                  if ((pocetkoleji = 0) and (JeKolemZeleznice))then
                     begin
                         if map[stanice[i].x,stanice[i].y-1].track or
                            map[stanice[i].x+2,stanice[i].y-1].track or
                            map[stanice[i].x+2,stanice[i].y].track or
                            map[stanice[i].x+2,stanice[i].y+1].track or
                            map[stanice[i].x,stanice[i].y+1].track or
                            map[stanice[i].x-2,stanice[i].y+1].track or
                            map[stanice[i].x-2,stanice[i].y].track or
                            map[stanice[i].x-2,stanice[i].y-1].track then
                               begin
                               JeKolemZeleznice:=true
                               end
                         else
                             begin
                             JeKolemZeleznice:=false;
                             end;
                      end;
                   if ((JeKolemZeleznice = false) or (PocetKoleji <> 0)) then
                       begin // napise se poznamka hraci at to predela
                       gotoxy(5,30);
                       textbackground(LightBLue);
                       textColor(Yellow);
                       Write('Zkust to znovu.');
                       end;
                  end;
              end;
     end;
  if PocetStanic > 2 then
      begin
      JeKolemZeleznice:=false;
          while (JeKolemZeleznice = false) do
              begin
              pohyb_kurzor;
              JeKolemZeleznice:=true;
              // overi se jestli je kolem všech stanic zeleznice, pokud jich je vic jak 2
              for i:=0 to PocetStanic-1 do
                  begin
                  if (JeKolemZeleznice)then
                     begin
                         if map[stanice[i].x,stanice[i].y-1].track or
                            map[stanice[i].x+2,stanice[i].y-1].track or
                            map[stanice[i].x+2,stanice[i].y].track or
                            map[stanice[i].x+2,stanice[i].y+1].track or
                            map[stanice[i].x,stanice[i].y+1].track or
                            map[stanice[i].x-2,stanice[i].y+1].track or
                            map[stanice[i].x-2,stanice[i].y].track or
                            map[stanice[i].x-2,stanice[i].y-1].track then
                               begin
                               JeKolemZeleznice:=true
                               end
                         else
                             begin
                             JeKolemZeleznice:=false;
                             end;
                      end;
                   if (JeKolemZeleznice = false) then
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
       for i:=0 to PocetStanic-1 do
           begin
           AktualniVzdalenostVlacku:=0;
           randomize;
           CisloStanice:=i;
                bod3^.x :=stanice[CisloStanice].x;
                bod3^.y :=stanice[CisloStanice].y;
                bod^.x :=stanice[CisloStanice].x;
                bod^.y :=stanice[CisloStanice].y;
                nalezeno := false;

                // Provadi Animaci vlacku z jedne stanice do druhe;
                repeat
                    if not TohleKoloMam then
                      AnimaceVlacku(0,-1);
                    if not TohleKoloMam then
                      AnimaceVlacku(2,-1);
                    if not TohleKoloMam then
                      AnimaceVlacku(2,0);
                    if not TohleKoloMam then
                      AnimaceVlacku(2,1);
                    if not TohleKoloMam then
                      AnimaceVlacku(0,1);
                    if not TohleKoloMam then
                      AnimaceVlacku(-2,1);
                    if not TohleKoloMam then
                      AnimaceVlacku(-2,0);
                    if not TohleKoloMam then
                      AnimaceVlacku(-2,-1);
                    if not nalezeno then
                         begin
                              bod3^.x:=bod^.x;
                              bod3^.y:=bod^.y;
                              bod^.x:=bod2^.x;
                              bod^.y:=bod2^.y;
                         end;
                      TohleKoloMam:=false;
                until nalezeno;

                //VlacekDojede
                SmazVlacek;
                bod3^.x:=bod^.x;
                bod3^.y:=bod^.y;
                SmazVlacek;

                //koleje se nastavi jako nenavstivene
                begin
                  interace1:=1;
                  while interace1 <= sirka do
                      begin
                      interace2:=1;
                      while interace2 <= delka do
                          begin
                          if (map[interace2,interace1-1].track) then
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
Ending_screen;
end.
