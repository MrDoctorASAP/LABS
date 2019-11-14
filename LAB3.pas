uses crt;

//написать task и убрать writeln

const
  abc = ['A'..'Z'];

type
  arr = array ['A'..'Z'] of integer;

type
  chars = array ['A'..'Z'] of char;

procedure Tast;
begin
  Writeln('Лабораторная работа №3.');
  Writeln('Группа 6113. Лаврентьев Андрей. Вариант 14.');
  Writeln('Задание');
  Writeln('В исходном текстовом файле записаны строки, содержашие текст на английском языке.');
  Writeln('Требуется написать программу, которая для каждой строки исходного файла будет');
  Writeln('определять и выводить в результирующий файл буквы, встречающиеся в этой строке');
  Writeln('в порядке уменьшения частоты их встречаемости. Строчные и прописные буквы при этом');
  Writeln('считаются не различимыми. Каждая буква, которая встречается в тексте, должна быть');
  Writeln('выведена ровно один раз. Если какие-то буквы встречаются одинаковое колиество раз,');
  Writeln('то они выводятся в алфавтном порядке. ');
  Writeln();
end;

procedure Shell(var freq: arr; var res: chars);
const
  h: array [1..5] of integer = (9, 5, 3, 2, 1);
var
  x, j, k, v: integer;
  c, t: char;
begin
  for x := 1 to 5 do
  begin
    k := h[x];
    for c := 'A' to Chr(Ord('Z') - k) do 
      if freq[c] < freq[Chr(Ord(c)+k)] then begin
        t := res[c];
        res[c] := res[Chr(Ord(c)+k)];
        res[Chr(Ord(c)+k)] := t;
        
        v := freq[c];
        freq[c] := freq[Chr(Ord(c)+k)];
        freq[Chr(Ord(c)+k)] := v;
      end;
  end;
end;

procedure Alg(var f1, f2: Text);
var
  str: string;
  freq: arr;
  res: chars;
  c: char;
  i: integer;
begin
  Reset(f1);
  Rewrite(f2);
  while not EoF(f1) do
  begin
    for c := 'A' to 'Z' do begin
      freq[c] := 0;
      res[c] := c;
    end;
    Readln(f1, str);
    for i := 1 to Length(str) do
    begin
      if UpCase(str[i]) in abc then
        Inc(freq[UpCase(str[i])]);
    end;
    Shell(freq, res);
    c:= 'A';
    while (( c <= 'Z') and (freq[c] <> 0)) do begin
      Write(f2, res[c]); 
      Inc(c);
    end;
    Writeln(f2, '');
  end;
  Close(f1);
  Close(f2);
end;

var
  fn1, fn2: string;
  f1, f2: Text;

begin
  clrscr;
  Tast;
  Writeln('Введите имя исходного файла: ');
  Readln(fn1);
  if FileExists(fn1) then begin
    Writeln('Введите имя результирующего файла: ');
    Readln(fn2);
    Assign(f1, fn1);
    Assign(f2, fn2);
    Alg(f1, f2);
    Writeln('Успешно.');
  end
  else Writeln('Файла не существует.');
end.