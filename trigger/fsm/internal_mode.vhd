library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity internal_mode is
	
	port(
	clk : in std_logic;
	rst_n : in std_logic;
	
	internal_active : in std_logic;
	bit_mode : in std_logic_vector (1 downto 0);
	
	internal_done : out std_logic;
	frame_req : out std_logic
	
	);
	
end internal_mode;


architecture internal of internal_mode is


-- bit mode --	 		-- at least #bits * LVDS_CLK_FREQ cycle
-- 00 -> 12b mode --
-- 01 -> 10b mode --
-- 10 -> 8b mode --

begin

process(clk, bit_mode, internal_active)

variable cnt : integer range 0 to 5 := 0;
variable cnt_value : integer range 0 to 5 := 4;
variable frame_req_v : std_logic := '0';
variable internal_done_v : std_logic := '0';
variable xxx : std_logic := '0';

begin
	if rising_edge(clk) then
		if rst_n = '0' then
			internal_done_v := '0';
			frame_req_v := '0';
		else
			if(bit_mode = "00") then
				cnt_value := 4;   -- 600/150 = 4 (12) (cnt := 3 + 1)
				
			elsif(bit_mode = "01") then
				cnt_value := 3;    -- 600/150 = 4 (10) (cnt := 3)
				
			elsif(bit_mode = "10") then
				cnt_value := 3;   -- 600/150 = 4 (8) (cnt := 2 + 1)
			end if;
			
			if internal_active = '1' then
				
				xxx := '1';
				
				if(cnt < cnt_value) then
					cnt := cnt + 1;
					--frame_req_v := '1';
					internal_done_v := '0';
				else
					cnt := 0;
					--frame_req_v := '0';
					internal_done_v := '1';
				end if;
			else
				xxx := '0';
				cnt := 0;
				internal_done_v := '0';
			end if;
			
			if xxx  = '1' and cnt < cnt_value then
				frame_req_v := '1';
			else
				frame_req_v := '0';
			end if;
			
		end if;
	end if;
	
	frame_req <= frame_req_v;
	internal_done <= internal_done_v;
					


end process;

end internal;