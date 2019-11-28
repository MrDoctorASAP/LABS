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

procedure PrintFileRecord(fn : string);
var stud : Student;
i : integer;
f : FileRecord;
begin
  if FileExists(fn) then begin
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
end else Writeln('Файл не существует');
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
sub, s : string;
begin
  //DenerateFileRecord;
  //inputFileRecord;
  
  {Readln; Assign(f1,'database'); printFileRecord(f1);
  Readln(sub); Assign(f2, 'result');
  Assign(f3, 'result.txt');
  Alg(f1, f2, f3, sub);
  printFileRecord(f2);{}
  {Task;
  
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
  
  Write('Лабораторная работа № 4. Выполнил Лаврентьев, 6113. 14 Вариант.');
  Write('Выберете действие : ');
  Write('1) Просмотр задания.');
  Write('2) Просмотреть файл записи.')
  Write('3) Редактировать файл записи.')
  Write('4) Получить новый файл записи и текстовый файл.')
  Write('5) Выход');
  Readln(s);
  while s <> '5' do begin
    case s of
      1:Task; 
      2:
      3:
      4:
    end;
  end;
end.