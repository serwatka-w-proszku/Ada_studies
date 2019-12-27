-----------------------------------------------------------------------
--
--  File:        Alarm.adb
--  Description: System antywlamaniowy
--  Date:        20.01.2017
--  Author:      Jakub Serwatka, Maciej Zdechlikiewicz
--  Mail:        kubaserw@gmail.com, maciek.zdechlikiewicz@gmai.com
-----------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO, NT_Console, Ada.Strings.Fixed, Ada.Real_Time;
use Ada.Text_IO, Ada.Integer_Text_IO, NT_Console, Ada.Strings.Fixed, Ada.Real_Time;

procedure Alarm is
 

 
-- **** Variables ****

   type States is (Standby, Ready, Countdown, Ringing);
   Current_State: States := Standby with atomic;
   Max_Length : constant := 4;
   subtype t_Actual_digit is Integer range 1..Max_Length+1;
   Key : Character := ' ';
   Code : constant String(1..Max_Length) := "7536";
   Exit_program : Boolean := False with atomic;
   Code_Inserted : Boolean := False with atomic;
   Remainded_seconds : Integer := 15 with atomic;
   Running: Boolean := False with atomic;



-- **** Code handling ****  
   
   protected type Code_validator is
      procedure Insert_Digit         
      (temp_char : in Character);
        
      function Get_Inserted_Code return String;

      procedure Code_Reset;
   private
      Inserted_Code : String(1..Max_Length) := "    ";
      ActualDigit : t_Actual_digit := 1;      
   end Code_validator;
   
   protected body Code_validator is
      procedure Insert_Digit (temp_char : in Character) is
      begin
         case temp_char is
            when ASCII.CR =>
               Code_Inserted := true;
            when ASCII.BS =>
               if ActualDigit > 1 then
                  ActualDigit := ActualDigit - 1;
                  Inserted_Code(ActualDigit) := ' ';
               end if;
            when '0'..'9' =>
               if ActualDigit >= 1 and ActualDigit < Max_Length + 1 then                   
                  Inserted_Code(ActualDigit) := temp_char;
                  ActualDigit := ActualDigit + 1;
               end if;
            when others =>
               null;   
         end case;      
      end Insert_Digit;
         
      function Get_Inserted_Code return String is
      begin      
         return Inserted_Code;
      end Get_Inserted_Code;

      procedure Code_Reset is
      begin
         Code_Inserted := False;
         ActualDigit := 1;
         Inserted_Code := "    ";
      end Code_Reset;

   end Code_validator;      
   
   My_Code_validator : Code_validator;



-- **** Countdown tasks ****  

   task Countdown_task is
      entry Start;
      entry Stop;
   end Countdown_task;   
   
   task body Countdown_task is
      subtype counter_type is Integer range 0..15;
      seconds_counter : counter_type := 15;
   begin
      loop
         select
            when not Running =>
               accept Start do
                  Running := True;
               end Start;
         or
            accept Stop;
            Running := False;
            Remainded_seconds := 15;
         or
            terminate;
         end select;

         if Running = True then
            loop
               delay 1.0;
               if seconds_counter = counter_type'First Or Code_Inserted then
                  exit;
               end if;
               seconds_counter := seconds_counter - 1;
               Remainded_seconds := seconds_counter;
            end loop;
            if My_Code_validator.Get_Inserted_Code /= Code or Remainded_seconds = 0 then
               Current_State := Ringing; 
            elsif My_Code_validator.Get_Inserted_Code = Code then
               Current_State := Standby;
            end if;
         elsif Running = False then
            seconds_counter := 15;
         end if;
      end loop;
   exception
      when others => null;
   end Countdown_task;



-- **** Graphic display ****  

   task Display_All;
   task body Display_All is
      Actual_Time : Time := Clock;
      Period : constant Time_Span := Milliseconds (20);
   
      procedure Display (X,Y: in Integer; Text: in String) is
      begin
         Goto_XY(X,Y);
         Put(Text);
      end Display;

      procedure Display_Banner is
      begin
         Clear_Screen(White);
         Set_Cursor (False);
         Set_Foreground(Light_Red);
         Set_Background(White);
         Goto_XY(32,0);
         Put("ALARM SYSTEM");
         Set_Background(yellow);
         Goto_XY(7,6);
         Put("  ");
         Goto_XY(21,6);
         Put("  ");
         Set_Foreground(Black);
         Set_Background(White);
         Goto_XY(5,8);
         Put("Standby");
         Goto_XY(20,8);
         Put("Ready");
         Goto_XY(5,15);
         Put("Enter Code:");
         Goto_XY(40,15);
         Put("Countdown:");
         Goto_XY(0,20);
         Put("Press 's' to activate an alarm");
         GoTo_XY(0,22);
         Put("Press 'a' to rob the house");
      end Display_Banner;
      
      procedure Display_String ( inserted_code : in String; x_pos : in Integer; y_pos : in Integer) is 
      begin
         Set_Background(White);
         Goto_XY(x_pos, y_pos);
         Put(inserted_code);
      end Display_String;

   begin
      Display_Banner;

      loop
         Actual_Time := Actual_Time + Period;
         delay until Actual_Time;
         case Current_State is
            when Standby =>
               Set_Background(Light_red); 
               Display(X => 7, Y => 6, Text => "  ");
               Display(X => 0, Y => 24, Text => "Alarm is now shut down.");
               Set_Background(white); 
               Display(X => 53, Y => 5, Text => "    ");
               Display(X => 52, Y => 6, Text => "      ");
               Display(X => 51, Y => 7, Text => "        ");
               Display(X => 50, Y => 8, Text => "          ");
               Display(X => 54, Y => 9, Text => "  ");
               Display(X => 50, Y => 15, Text => "       ");
               Display(X => 17, Y => 15, Text => "     "); 
            when Ready =>
               Set_Background(yellow); 
               Display(X => 7, Y => 6, Text => "  ");
               Set_Background(white); 
               Display(X => 0, Y => 24, Text => "                        ");
               Set_Background(Light_Green); 
               Display(X => 21, Y => 6, Text => "  ");
            when Countdown =>
               Display_String(My_Code_validator.Get_Inserted_Code, 17, 15);
               Display_String(Remainded_seconds'Img, 52, 15);
               if Remainded_seconds < 10 then
                  Display(X => 54, Y => 15, Text => " "); 
                  Display(X => 55, Y => 15, Text => "s");
                  Display(X => 56, Y => 15, Text => " ");
               elsif Remainded_seconds > 9 then
                  Display(X => 56, Y => 15, Text => "s");
                  Display(X => 55, Y => 15, Text => " ");
               end if;
               Set_Background(yellow);  
               Display(X => 21, Y => 6, Text => "  ");
            when Ringing =>
               Set_Background(Light_red);  
               Display(X => 53, Y => 5, Text => "    ");
               Display(X => 52, Y => 6, Text => "      ");
               Display(X => 51, Y => 7, Text => "        ");
               Display(X => 50, Y => 8, Text => "          ");
               Display(X => 54, Y => 9, Text => "  ");
               Set_Background(white); 
               Display(X => 17, Y => 15, Text => "     ");  
               Set_Background(yellow); 
               Display(X => 21, Y => 6, Text => "  ");
            when others =>
               Current_State := Ringing;
         end case;
      end loop;
   exception
      when others => null;
   end Display_All;



-- **** Keyboard control and state machine**** 
 
   task Keyboard_control;
   task body Keyboard_control is 
   begin
      loop
         Get_Immediate(Key);

         case Current_State is
               when Standby =>
                  Countdown_task.Stop;
                  My_Code_validator.Code_Reset;
               if Key = 's' then
                  Current_State := Ready;
               end if;
            when Ready =>
               if Key = 'a' then
                  Countdown_task.Start;
                  Current_State := Countdown;
               end if;
            when Countdown =>
               if not Code_Inserted and Remainded_seconds > 0 then
                  My_Code_validator.Insert_Digit(Key); 
               end if;
            when Ringing => 
               if Key = 'r' then
                  My_Code_validator.Code_Reset;
                  Countdown_task.Stop;
                  Code_Inserted := FALSE;
                  Current_State := Standby;
               end if;
            when others =>
               Set_Foreground (Light_Red);
               Clear_Screen;
               Exit_program := True;
               exit;
         end case;
      end loop;
   end Keyboard_control;



-- **** Main loop ****  
  
begin
   loop 
      null;
   end loop;
end Alarm;	  	
