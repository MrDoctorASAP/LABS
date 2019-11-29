uses crt;

type
  Olympiad = record 
    subject: string[20];
    points: integer;
    place: integer;
  end;
  
  Student = record
    name: string[16];
    surname: string[16];
    classStud: string[3];
    olympiads: array [1..5] of Olympiad;
  end;
  
  FileRecord = file of Student;

procedure Task;
begin
  Writeln('В файле хранится информация об учениках школы: имя, фамилия, класс (номер и буква)');
  Writeln('и список олимпиад (не более 5), в которых участвовал каждый ученик: предмет,');
  Writeln('количество баллов, место, занятое на олимпиаде. В новый файл переписать');
  Writeln('информацию об учениках, участвовавших в олимпиаде по заданному предмету');
  Writeln('Вывести в текстовый файл фамилии учеников, чей средний балл по олимпиадам');
  Writeln('больше среднего по школе.');
  Writeln('');
end;

procedure PrintFileRecord(var f: FileRecord);
var
  stud: Student;
  i, n: integer;
begin
  Reset(f);
  Writeln('  №               Имя          Фаммилия   Класс                      Олимпиады');
  Writeln('                                                              Предмет   Баллы   Место');
  Writeln;
  n := 1;
  while not Eof(f) do
  begin
    Read(f, stud);
    Write(n:3, stud.name:18, stud.surname:18, stud.classStud:8);
    Writeln(stud.olympiads[1].subject:22, stud.olympiads[1].points:8, stud.olympiads[1].place:8);
    i := 2;
    while (i <= 5) and (stud.olympiads[i].subject <> '') do
    begin
      Write('                                               ');
      Writeln(stud.olympiads[i].subject:22, stud.olympiads[i].points:8, stud.olympiads[i].place:8);
      i := i + 1;
    end;
    Writeln; 
    n := n + 1;
  end;  
  Close(f);
end;

procedure Alg1(var f1: FileRecord; var f2: FileRecord; subject: string);
var stud: Student;
i : integer;
begin
  Reset(f1); Rewrite(f2);
  while not Eof(f1) do
  begin
    Read(f1, stud);
    i := 1;
    while (i <= 5) and (stud.olympiads[i].subject <> '') do
    begin
      if stud.olympiads[i].subject = subject then 
        Write(f2, stud);
        i := i + 1;
    end;
  end;
  Close(f1); Close(f2);
end;

procedure Alg2(var f1: FileRecord; var f3: Text);
var 
c, i : integer;
m, u : real;
stud : Student;
begin
  Reset(f1); Rewrite(f3);
  c := 0;
  while not Eof(f1) do
  begin
    c := c + 1;
    Read(f1, stud);
    i := 1;
    u := 0;
    while (i <= 5) and (stud.olympiads[i].subject <> '') do
    begin
      u := u + stud.olympiads[i].points;
      i := i + 1;
    end;
    m := m + u / (i - 1); 
  end;
  m := m / c;
  Seek(f1, 0);
  Rewrite(f3);
  while not Eof(f1) do
  begin
    Read(f1, stud);
    i := 1;
    u := 0;
    while (i <= 5) and (stud.olympiads[i].subject <> '') do
    begin
      u := u + stud.olympiads[i].points;
      i := i + 1;
    end;
    if u / (i - 1) >= m then Writeln(f3, stud.surname);
  end;
  Close(f1); Close(f3);
end;


procedure AppendRecord(f: FileRecord);
var
  s: string;
  n, i, code, p: integer;
  stud: Student;
begin
  clrscr;
  Reset(f);
  Seek(f, FileSize(f));
  Writeln('Добавлене записи');
  Write('Имя : '); Readln(s);
  stud.name := s;
  Write('Фаммилия : '); Readln(s);
  stud.surname := s;
  Write('Класс : '); Readln(s);
  stud.classStud := s;
  Write('Количество олимпиад ( <= 5) : '); Readln(s);
  Val(s, n, code);
  if (code = 0) and (n <= 5) then
    for i := 1 to n do
    begin
      Write('   Предмет : ');
      Readln(s);
      stud.olympiads[i].subject := s;
      
      Write('   Баллы : ');
      Readln(s);
      p := 0;
      Val(s, p, code);
      stud.olympiads[i].points := p;
      
      Write('   Место : ');
      Readln(s);
      p := 0;
      Val(s, p, code);
      stud.olympiads[i].place := p;
      
      Writeln;
      
    end
  else 
    Writeln('Неверное значение');
  Write(f, stud);
end;

procedure DeleteRecord(var f: FileRecord; n: integer);
var
  stud: Student;
begin
  Reset(f);
  if(0 < n) and (n <= FileSize(f)) then begin
    Seek(f, FileSize(f) - 1);
    Read(f, stud);
    Seek(f, n - 1);
    Write(f, stud);
    Seek(f, FileSize(f) - 1);
    Truncate(f);
  end else Writeln('Неверное значение');
  Close(f);
end;

procedure printText(var f : Text);
var s: string;
begin
  Reset(f);
  while not Eof(f) do begin 
    Readln(f,s);
    Writeln(s);
  end;
  Close(f);
end;

procedure EditRecord(var f: FileRecord; n: integer);
var
  stud: Student;
  s: string;
  i, code, p: integer;
begin
  Reset(f);
  if(0 < n) and (n <= FileSize(f)) then begin
    Seek(f, n - 1);
    Writeln('Введите новые данные (оставте пустым - без измений): ');
    Read(f, stud);
    Write('Имя : '); Readln(s);
    if s <> '' then stud.name := s;
    Write('Фаммилия : '); Readln(s);
    if s <> '' then stud.surname := s;
    Write('Класс : '); Readln(s);
    if s <> '' then stud.classStud := s;
    Write('Количество олимпиад ( <= 5) : '); Readln(s);
    if s <> '' then begin
      Val(s, n, code);
      for i := 1 to 5 do 
        stud.olympiads[i].subject := '';
      if (code = 0) and (n <= 5) then
        for i := 1 to n do
        begin
          Write('   Предмет : ');
          Readln(s);
          stud.olympiads[i].subject := s;
          
          Write('   Баллы : ');
          Readln(s);
          p := 0;
          Val(s, p, code);
          stud.olympiads[i].points := p;
          
          Write('   Место : ');
          Readln(s);
          p := 0;
          Val(s, p, code);
          stud.olympiads[i].place := p;
          
          Writeln;
          
        end
      else 
        Writeln('Неверное значение');
    end;
  end else Writeln('Неверное значение');
  Close(f);
  DeleteRecord(f, n);
  Reset(f);
  Seek(f, FileSize(f));
  Write(f, stud);
  Close(f);
end;

procedure menu;
begin
  Writeln('Лабораторная работа № 4. Выполнил Лаврентьев, 6113. 14 Вариант.');
  Writeln('Меню');
  Writeln('1) Просмотр задания');
  Writeln('2) Создать файл записи');
  Writeln('3) Редактировать файл записи');
  Writeln('4) Получить новый файл записи');
  Writeln('5) Получить новый текстовый');
  Writeln('6) Просмотреть файл записи');
  Writeln('7) Просмотреть текстовый файл');
  Writeln('8) Удалить файл');
  Writeln('9) Выход');
  Write('Выберете действие : ');
end;

var
  f1, f2: FileRecord;
  f3: Text;
  sub, s, fn: string;
  c, cc: char;
  i: integer;

begin  
  Menu();
  Readln(c);
  while c <> '9' do
  begin
    case c of
      '1': begin
        ClrScr;
        Task;
        Writeln('Нажмите Enter для возвращения в меню...');
        Readln;
      end;
      '2':
        begin
          ClrScr;
          Write('Введите имя файла : '); Readln(fn);
          if FileExists(fn) then begin
            Write('Файл существует. Перезаписать его? (y/n) : ');
            Readln(s);
            if s = 'y' then begin
              Assign(f1, fn);
              Rewrite(f1);
              Close(f1);
            end;
          end else begin
            Assign(f1, fn);
            Rewrite(f1);
            Close(f1);
          end;
          Writeln('Нажмите Enter для возвращения в меню...');
          Readln;
        end;
      '3':
        begin
          ClrScr;
          Write('Введите имя файла : '); Readln(fn);
          if FileExists(fn) then begin
            Assign(f1, fn);
            PrintFileRecord(f1);
            Writeln('Редактирование файла');
            Writeln('1) Добавить запись');
            Writeln('2) Удалить запись');
            Writeln('3) Редактировать запись');
            Writeln('4) Завершить редактирование');
            Write('Выберете действие : ');
            Readln(cc);
            while cc <> '4' do
            begin
              case cc of
                '1': AppendRecord(f1); 
                '2':
                  begin
                    Write('Введите номер записи : ');
                    Readln(i);
                    DeleteRecord(f1, i);
                  end;
                '3':
                  begin
                    Write('Введите номер записи : ');
                    Readln(i);
                    EditRecord(f1, i);
                  end;
              end;
              ClrScr;
              PrintFileRecord(f1);
              Writeln('Редактирование файла');
              Writeln('1) Добавить запись');
              Writeln('2) Удалить запись');
              Writeln('3) Редактировать запись');
              Writeln('4) Завершить редактирование');
              Write('Выберете действие : ');
              Readln(cc);
            end;
          end;
          Writeln('Нажмите Enter для возвращения в меню...');
          Readln;
        end;
      '4':
        begin
          ClrScr;
          Write('Введите имя исходного файла : '); Readln(fn);
          if FileExists(fn) then begin
            Assign(f1, fn);
            Write('Введите имя результирующего файла : '); Readln(fn);
            Assign(f2, fn);
            Write('Введите предмет : '); Readln(sub);
            Alg1(f1, f2, sub);
            Writeln('Успешно');
          end else Writeln('Файла не существует.');
          Writeln('Нажмите Enter для возвращения в меню...');
          Readln;
        end;
      '5':
        begin
          ClrScr;
          Write('Введите имя исходного файла : '); Readln(fn);
          if FileExists(fn) then begin
            Assign(f1, fn);
            Write('Введите имя результирующего файла : '); Readln(fn);
            Assign(f3, fn);
            Alg2(f1, f3);
            Writeln('Успешно');
          end else Writeln('Файла не существует.');
        Writeln('Нажмите Enter для возвращения в меню...');
          Readln;
        end;
        
      '6': begin
          ClrScr;
          Write('Введите имя файла : '); Readln(fn);
          if FileExists(fn) then begin
            Assign(f1, fn);
            PrintFileRecord(f1);
          end else Writeln('Файла не существует.');
        Writeln('Нажмите Enter для возвращения в меню...');
          Readln;
        end;
      '7': begin
        begin
          ClrScr;
          Write('Введите имя файла : '); Readln(fn);
          if FileExists(fn) then begin
            Assign(f3, fn);
            PrintText(f3);
          end else Writeln('Файла не существует.');
        Writeln('Нажмите Enter для возвращения в меню...');
          Readln;
        end;
      end;
      '8' : begin
        ClrScr;
          Write('Введите имя файла : '); Readln(fn);
          if FileExists(fn) then begin
            Assign(f3, fn);
            Erase(f3);
            Writeln('Файл удалён');
          end else Writeln('Файла не существует.');
        Writeln('Нажмите Enter для возвращения в меню...');
          Readln;
      end;
    end;
    ClrScr;
    Menu();
    Readln(c);
  end;
end.