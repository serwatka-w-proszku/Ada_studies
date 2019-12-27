-- Test_Int
-- materiały dydaktyczne
-- Jacek Piwowarczyk

with Ada.Synchronous_Task_Control, Ada.Text_IO, Int_Pak;
use Ada.Synchronous_Task_Control, Ada.Text_IO, Int_Pak;

procedure Test_Int is
  
  task ZadInt ; 
  
  task body ZadInt is
  begin
    Set_False(Sem_Bin);
    Put_Line("Początek");
    loop
      Suspend_Until_True(Sem_Bin);
      Set_False(Sem_Bin); --?
      Put_Line("Przerwanie !!!!"); 
    end loop; 
  exception 
   when others=> Put_Line("Blad zadania!"); 
  end ZadInt; 
    
begin
  Put_Line("kill -SIGUSR1 <psid>, Ctrl+C Koniec");
end Test_Int;  