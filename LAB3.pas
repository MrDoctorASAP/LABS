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
    for c := 'A' to Chr(Ord('Z') - k) do //check z - k
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
    Writeln('1) reading line of file');
    Readln(f1, str);
    for i := 1 to Length(str) do
    begin
      Writeln('2) Цикл1 i = ',i, 'текущая буква - ', str[i]);
      if UpCase(str[i]) in abc then
        Inc(freq[UpCase(str[i])]);
    end;
    Writeln('4)Сортировка шелла ');
    Shell(freq, res);
    Writeln('5) Начало строки в файл записи в файл');
    c:= 'A';
    while (( c <= 'Z') and (freq[c] <> 0)) do begin
      Writeln('6) Выполнение записи буквы ', c, ' в файл');
      Write(f2, res[c]); 
      Inc(c);
    end;
    Writeln(f2, '');
    Writeln('7) Конец записи строки в файл');
  end;
  Close(f1);
  Close(f2);
  Writeln('8) Конец алгоритма');
end;

var
  fn1, fn2: string;
  f1, f2: Text;

begin
  clrscr;
  Writeln(' ' in abc);
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