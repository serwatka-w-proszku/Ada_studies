-- losd4

with Ada.Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

procedure Losd4 is
  type Los is new Integer range 0..10;
  package Los_Liczby is new Ada.Numerics.Discrete_Random(Los);
  use Los_Liczby;

  Wart : Los := 0;
  Gen: Generator; -- z pakietu Los_Znak
begin
  Reset(Gen);
  for I in 1..10 loop
    Wart := Random(Gen);
    Put_Line("Wylosowalem: >" & Wart'Img & "<");
  end loop;
end Losd4;
