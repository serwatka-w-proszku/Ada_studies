-- int_pak.ads
-- materiały dydaktyczne
-- Jacek Piwowarczyk

with Ada.Synchronous_Task_Control, Ada.Interrupts, Ada.Interrupts.Names;
use Ada.Synchronous_Task_Control, Ada.Interrupts, Ada.Interrupts.Names;

package Int_Pak is

  Sem_Bin: Suspension_Object;
  
  protected Obsluga is
    procedure Obsluga_Przerwania;
    pragma Attach_Handler(Obsluga_Przerwania, SIGUSR1);
  end  Obsluga;
  
end Int_Pak;  