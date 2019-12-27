-- pak_sort.adb

with Ada.Text_IO, Ada.Float_Text_IO, Ada.Numerics.Float_Random;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Numerics.Float_Random ;

-- Zadanie:
-- dopisać treści procedur

package body Pak_Sort is

procedure Put_Wektor(W: Wektor; Kom: String := "") is
begin
  null;	
end Put_Wektor;		

procedure Losuj_Wektor(W: in out Wektor; Max: Float := 100.0) is
begin
  null;
end Losuj_Wektor; 

-- sortowanie bąbelkowe wektora W
procedure Sortuj_BB(W: in out Wektor) is 
begin
  null;  	  	
end Sortuj_BB;			

procedure Scalaj2(W1, W2: Wektor; W: in out Wektor) is
-- scala posortowane wektory W1, W2 do W
begin	
  null;
end Scalaj2;		  

end Pak_Sort;