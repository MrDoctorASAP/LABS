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

procedure Task;
begin
  Writeln('Task...')
end;

procedure PrintFileRecord(f : FileRecord);
var stud : Student;
i : integer;
begin
  Reset(f);
  Writeln('               Имя          Фаммилия   Класс                      Олимпиады');
  Writeln('                                                           Предмет   Баллы   Место');
  Writeln;
  while not Eof(f) do begin
    Read(f, stud);
    Write(stud.name:18, stud.surname:18, stud.classStud:8);
    Writeln(stud.olympiads[1].subject:22, stud.olympiads[1].points:8, stud.olympiads[1].place:8);
    i := 2;
    while (i <= 5) and (stud.olympiads[i].subject <> '') do begin
      Write('                                            ');
      Writeln(stud.olympiads[i].subject:22, stud.olympiads[i].points:8, stud.olympiads[i].place:8);
      i := i + 1;
    end;
    Writeln;
  end;  
  Close(f);
end;

procedure DenerateFileRecord;
var 
fn : string;
f, f2 : FileRecord;
stud, hj : Student;
s,h : string;
code, i, n, p : integer;
begin
  Write('Filename : ');
  Readln(fn);
  Assign(f, fn);
  Rewrite(f);
  Assign(f2, 'database2');
  
  Write('Count : ');
  Readln(s);
  Reset(f2);
  Val(s, n, code);
  while not (Eof(f2)) and (FilePos(f2) < n) do begin
    for i := 1 to 5 do 
      stud.olympiads[i].subject := '';
    Read(f2, hj);
    Writeln(hj.name,' ', hj.surname);
    stud.name := hj.name; stud.surname := hj.surname; stud.classStud := hj.classStud;
    for i := 1 to 5 do begin
      if hj.olympiads[i].subject = '' then break;
      Writeln('  ',hj.olympiads[i].subject);
      stud.olympiads[i].subject := hj.olympiads[i].subject;
      Write('Point : '); Readln(s);
      Val(s, stud.olympiads[i].points, code);
      Write('Place : '); Readln(s);
      Val(s, stud.olympiads[i].place, code);
    end;
    Write(f, stud);
  end;
  Close(f); Close(f2);
end;

procedure InputFileRecord;
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

sub, fn : string;
begin
  //DenerateFileRecord;
  //inputFileRecord;
  
  {Readln; Assign(f1,'database'); printFileRecord(f1);
  Readln(sub); Assign(f2, 'result');
  Assign(f3, 'result.txt');
  Alg(f1, f2, f3, sub);
  printFileRecord(f2);{}
  Task;
  
  Write('Введите имя исходного файла : '); Readln(fn);
  if FileExists(fn) then begin
    Assign(f1, fn);
    Write('Введите имя результирующего файла : '); Readln(fn);
    Assign(f2, fn);
    Write('Введите имя текстового файла : '); Readln(fn);
    Assign(f3, fn);
    Write('Введите предмет : '); Readln(sub);
    Alg(f1, f2, f3, sub);
    Writeln('Исходный файл : ');
    PrintFileRecord(f1);
    Writeln('Результирующий файл : ');
    PrintFileRecord(f2);
  end else 
    Writeln('');
  {}
end.