with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;

procedure Konwerter is
    Wynik : Float;

    function conv (Stopnie : Float) return Float is
       begin
       Wynik := (Stopnie-32.0)/1.8;
--      Put_Line(Stopnie'Img & "stopni fahrenheita, to" & Wynik'Img & "stopni celsjusza");
       return Wynik;
    end conv;

    begin
    Put_Line("stopni celsjusza" & Integer(conv(90.0))'Img);

end Konwerter;
