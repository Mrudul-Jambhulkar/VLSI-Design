-- simple gates with trivial architectures
library IEEE;
use IEEE.std_logic_1164.all;
entity andgate is
port (A, B: in std_ulogic;
prod: out std_ulogic);
end entity andgate;
architecture trivial of andgate is
begin
prod <= A AND B AFTER 344 ps;
end architecture trivial;

library IEEE;
use IEEE.std_logic_1164.all;
entity xorgate is
port (A, B: in std_ulogic;
uneq: out std_ulogic);
end entity xorgate;
architecture trivial of xorgate is
begin
uneq <= A XOR B AFTER 688 ps;
end architecture trivial;

library IEEE;
use IEEE.std_logic_1164.all;
entity abcgate is
port (A, B, C: in std_ulogic;
abc: out std_ulogic);
end entity abcgate;
architecture trivial of abcgate is
begin
abc <= A OR (B AND C) AFTER 444 ps;
end architecture trivial;

-- A + C.(A+B) with a trivial architecture
library IEEE;
use IEEE.std_logic_1164.all;
entity Cin_map_G is
port(A, B, Cin: in std_ulogic;
Bit0_G: out std_ulogic);
end entity Cin_map_G;
architecture trivial of Cin_map_G is
begin
Bit0_G <= (A AND B) OR (Cin AND (A OR B)) AFTER 688 ps;
end architecture trivial;

library ieee ;
use ieee.std_logic_1164.all ;

entity brent_kung is 
port(a,b: in std_logic_vector(31 downto 0);
	  cin: in std_logic;
	  sum: out std_logic_vector(31 downto 0);
	 cout: out std_logic);
end entity brent_kung;

architecture struct of brent_kung is 

signal G0, P0, c_out : std_logic_vector(31 downto 0):= (others => '0');
signal G1, P1 : std_logic_vector(15 downto 0):= (others => '0');
signal G2, P2 : std_logic_vector(7 downto 0):= (others => '0');
signal G3, P3 : std_logic_vector(3 downto 0):= (others => '0');
signal G4, P4 : std_logic_vector(1 downto 0):= (others => '0');
signal G5, P5 : std_logic_vector(0 downto 0):= (others => '0');

       component andgate is
       port (A, B: in std_ulogic;
       prod: out std_ulogic);
        end component andgate;
        
		component xorgate is
      port (A, B: in std_ulogic;
      uneq: out std_ulogic);
      end component xorgate;
		
		component abcgate is
    port (A, B, C: in std_ulogic;
     abc: out std_ulogic);
      end component abcgate;
		
	component Cin_map_G is
     port(A, B, Cin: in std_ulogic;
     Bit0_G: out std_ulogic);
    end component Cin_map_G;
	 
	begin
-----------------------------------------
L0: Cin_map_G port map(A=>a(0), B=>b(0), Cin=>cin, Bit0_G=>G0(0));
L00: xorgate port map(A=>a(0), B=>b(0), uneq=>P0(0));

loop0: for i in 1 to 31 generate
L1: andgate port map(A=>a(i), B=>b(i), prod=>G0(i));

L2: xorgate port map(A=>a(i), B=>b(i), uneq=>P0(i));

end generate;

c_out(0) <= G0(0);

-----------------------------------------

--process
--begin
--L00: Cin_map_G port map(A=>G0(1), B=>P0(1), Cin=>cin, Bit0_G=>G1(0));

loop1: for i in 0 to 15 generate

L3: abcgate port map(A=>G0(2*i+1), B=>P0(2*i+1), C=>G0(2*i), abc=>G1(i));

L4: andgate port map(A=>P0(2*i+1), B=>P0(2*i), prod=>P1(i));

end generate;

c_out(1) <= G1(0);
--end process;
----------------------------------------

--process
--begin
--L01: Cin_map_G port map(A=>G1(1), B=>P1(1), Cin=>cin, Bit0_G=>G2(0));

loop2: for i in 0 to 7 generate

L5: abcgate port map(A=>G1(2*i+1), B=>P1(2*i+1), C=>G1(2*i), abc=>G2(i));

L6: andgate port map(A=>P1(2*i+1), B=>P1(2*i), prod=>P2(i));

end generate;

c_out(3) <= G2(0);
c_out(2) <= G0(2) or (P0(2) and c_out(1));
--end process;
----------------------------------------

--process
--begin
--L02: Cin_map_G port map(A=>G2(1), B=>P2(1), Cin=>cin, Bit0_G=>G3(0));

loop3: for i in 0 to 3 generate

L7: abcgate port map(A=>G2(2*i+1), B=>P2(2*i+1), C=>G2(2*i), abc=>G3(i));

L8: andgate port map(A=>P2(2*i+1), B=>P2(2*i), prod=>P3(i));

end generate;

c_out(7) <= G3(0);
c_out(4) <= G0(4) or (P0(4) and c_out(3));
c_out(5) <= G1(2) or (P1(2) and c_out(3));
--end process;
----------------------------------------

--process
--begin
--L03: Cin_map_G port map(A=>G3(1), B=>P3(1), Cin=>cin, Bit0_G=>G4(0));

loop4: for i in 0 to 1 generate

L9: abcgate port map(A=>G3(2*i+1), B=>P3(2*i+1), C=>G3(2*i), abc=>G4(i));

L10: andgate port map(A=>P3(2*i+1), B=>P3(2*i), prod=>P4(i));

end generate;

c_out(15) <= G4(0);
c_out(6) <= G0(6) or (P0(6) and c_out(5));
c_out(8) <= G0(8) or (P0(8) and c_out(7));
c_out(9) <= G1(4) or (P1(4) and c_out(7));
c_out(11) <= G2(2) or (P2(2) and c_out(7));
--end process;
-----------------------------------------

--process
--begin
L04: abcgate port map(A=>G4(1), B=>P4(1), C=>G4(0), abc=>G5(0));

--L12: andgate port map(A=>P4(1), B=>P4(0), prod=>P5(0));

c_out(31) <= G5(0);
c_out(10) <= G0(10) or (P0(10) and c_out(9));
c_out(12) <= G0(12) or (P0(12) and c_out(11));
c_out(13) <= G1(6) or (P1(6) and c_out(11));
c_out(16) <= G0(16) or (P0(16) and c_out(15));
c_out(17) <= G1(8) or (P1(8) and c_out(15));
c_out(19) <= G2(4) or (P2(4) and c_out(15));
c_out(23) <= G3(2) or (P3(2) and c_out(15));
--end process;
-----------------------------------------

--process
--begin
L13: abcgate port map(A=>G0(14), B=>P0(14), C=>c_out(13), abc=>c_out(14));
L14: abcgate port map(A=>G0(18), B=>P0(18), C=>c_out(17), abc=>c_out(18));
L15: abcgate port map(A=>G0(20), B=>P0(20), C=>c_out(19), abc=>c_out(20));
L16: abcgate port map(A=>G1(10), B=>P1(10), C=>c_out(19), abc=>c_out(21));
L17: abcgate port map(A=>G0(24), B=>P0(24), C=>c_out(23), abc=>c_out(24));
L18: abcgate port map(A=>G1(12), B=>P1(12), C=>c_out(23), abc=>c_out(25));
L19: abcgate port map(A=>G2(6), B=>P2(6), C=>c_out(23), abc=>c_out(27));
--end process;
-----------------------------------------

--process
--begin
L20: abcgate port map(A=>G0(22), B=>P0(22), C=>c_out(21), abc=>c_out(22));
L21: abcgate port map(A=>G0(26), B=>P0(26), C=>c_out(25), abc=>c_out(26));
L22: abcgate port map(A=>G0(28), B=>P0(28), C=>c_out(27), abc=>c_out(28));
L23: abcgate port map(A=>G1(14), B=>P1(14), C=>c_out(27), abc=>c_out(29));
--end process;
------------------------------------------

--process
--begin
L24: abcgate port map(A=>G0(30), B=>P0(30), C=>c_out(29), abc=>c_out(30));
--end process;
------------------------------------------
---Calculation of Sum

sum(0) <= P0(0) xor cin;
cout <= c_out(31);
loop5: for i in 1 to 31 generate
sum(i) <= P0(i) xor c_out(i-1);
end generate;
end struct;