uses crt;

type Olympiad = record 
  subject : string[20];
  points : integer;
  place : integer;
end;

Student = record
  name : string[16];
  surname : string[16];
  classStud : string[3];
  olympiads : array [1..5] of Olympiad;
end;

FileRecord = file of Student;

procedure task;
begin
  
end;

procedure printFileRecord(f : FileRecord);
var stud : Student;
y, i : integer;
begin
  Reset(f);
  Writeln(' Имя             Фаммилия        Класс             Олимпиады');
  Writeln('                                        Предмет            Баллы  Место');
  Writeln;
  while not Eof(f) do begin
    Read(f, stud);
    y := WhereY; 
    i := 1;
    Write(' ',stud.name);
    GotoXY(18, y);
    Write(stud.surname);
    GotoXY(34, y);
    Write(stud.classStud);
    GotoXY(0, y);
    while (i <= 5) and (stud.olympiads[i].subject <> '') do begin
      y := WhereY;
      GotoXY(41, y);
      Write(stud.olympiads[i].subject);
      GotoXY(60, y);
      Write(stud.olympiads[i].points);
      GotoXY(67, y);
      Write(stud.olympiads[i].place);
      i := i+1;
      Writeln;
    end;
    Writeln;
    Writeln;
  end;
  Close(f);
end;

procedure inputFileRecord;
var 
fn : string;
f : FileRecord;
stud : Student;
s : string;
code, i, n, p : integer;
begin
  Write('Filename : ');
  Readln(fn);
  Assign(f, fn);
  Rewrite(f);
  Write('Name: ');
  Readln(s);
  while s <> '0' do begin
    for i := 1 to 5 do 
      stud.olympiads[i].subject := '';
    n := 0;
    code := 0;
    i := 0;
    stud.name := s;
    
    Write('Surname : ');
    Readln(s);
    stud.surname := s;
    
    Write('Class : ');
    Readln(s);
    stud.classStud := s;
    
    Write('Count of olympiad (<= 5) : ');
    Readln(s);
    Val(s, n, code);
    if (code = 0) and (n <= 5) then
      for i := 1 to n do begin
        Write('   subject : ');
        Readln(s);
        stud.olympiads[i].subject := s;
        
        Write('   points : ');
        Readln(s);
        p := 0;
        Val(s, p, code);
        stud.olympiads[i].points := p;
        
        Write('   place : ');
        Readln(s);
        p := 0;
        Val(s, p, code);
        stud.olympiads[i].place := p;
      end;
    
    Write(f, stud);
    
    Write('Name: ');
    Readln(s);
    
      
  end;
  Close(f);
end;

procedure Alg(var f1 : FileRecord; var f2 : FileRecord; var f3: Text; subject: string);
var stud : Student;
i, c: integer;
m, u : double;
begin
  Reset(f1); Rewrite(f2);
  c := 0;
  while not Eof(f1) do begin
    c := c + 1;
    Read(f1, stud);
    i := 1;
    u := 0;
    while (i <= 5) and (stud.olympiads[i].subject <> '') do begin
      if stud.olympiads[i].subject = subject then 
        Write(f2, stud);
      u := u + stud.olympiads[i].points;
      i:=i+1;
    end;
    m := m + u/(i - 1); 
  end;
  m := m/c;
  Close(f2);
      Writeln('Middle Main : ',m);
  Seek(f1, 0);
  Rewrite(f3);
  while not Eof(f1) do begin
    Read(f1, stud);
    i := 1;
    u := 0;
    while (i <= 5) and (stud.olympiads[i].subject <> '') do begin
      u := u + stud.olympiads[i].points;
      i := i + 1;
    end;
    Writeln(stud.surname, ' : ', u/(i - 1));
    if u/(i - 1) >= m then Writeln(f3, stud.surname);
  end;
  Close(f1); Close(f3);
end;

var
f1, f2: FileRecord;
f3 : Text;
sub : string;
begin
  //inputFileRecord;
  Readln; Assign(f1,'database'); printFileRecord(f1);
  Readln(sub); Assign(f2, 'result');
  Assign(f3, 'result.txt');
  Alg(f1, f2, f3, sub);
  printFileRecord(f2);
  
end.