-- int_pak.adb
-- materiały dydaktyczne
-- Jacek Piwowarczyk

package body Int_Pak is
  
  protected body Obsluga is
    procedure Obsluga_Przerwania is
    begin
      Set_True(Sem_Bin);
    end Obsluga_Przerwania;
  end Obsluga;

end Int_Pak;    