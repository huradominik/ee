library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fsm_trig_tb is
end fsm_trig_tb;




architecture testBench of fsm_trig_tb is




--signal inputs
signal clk : std_logic;		
signal rst : std_logic;

signal axi_fsm_state : std_logic_vector (9-1 downto 0);
signal axi_fsm_flags : std_logic_vector (6-1 downto 0);
signal axi_fsm_control : std_logic_vector (5-1 downto 0);
	
--signal trig_en : std_logic;	  -- trigger enable, global flag 

	
signal init_done : std_logic; -- flag done from initialization
signal rst_done : std_logic;  -- reset done flag 
signal ld_done : std_logic;   -- scheduler done flag
signal spi_done : std_logic;     -- spi done flag
signal spi_last : std_logic; -- spi all transfer data done


signal acq_ready : std_logic;
	

	-- output signals state machine
signal init_state : std_logic;
signal seq_rst_state : std_logic;
signal idle_mode_state : std_logic;
signal load_data_state : std_logic;
signal spi_state : std_logic;
signal spi_transfer_state : std_logic;
signal internal_mode_state : std_logic;
signal external_mode_state : std_logic;
signal acq_image_state : std_logic;


--axi alias --
--aliast fsm_control--
alias rst_active : std_logic is axi_fsm_control(0); -- reset request from control device 
alias ld_active : std_logic is axi_fsm_control(1);   -- scheduler request
alias trig_cmp : std_logic is axi_fsm_control(2);   -- trigger flag from time comparator
alias trig_soft : std_logic is axi_fsm_control(3);	-- software flag for trigger image
alias acq_done : std_logic is axi_fsm_control(4); -- temporary

--aliast fsm_flags--  --settings flag--
alias spi_diff : std_logic is axi_fsm_flags(0);	 -- different settings spi flag -- set when last spi value differ with actual value
alias cmp_f : std_logic is axi_fsm_flags(1);		 -- compare mode flag
alias soft_f : std_logic is axi_fsm_flags(2);	 -- soft mode trigger
alias exp_flag : std_logic is axi_fsm_flags(3);	 -- exposure mode flag , internal = '0' , external = '1'
alias bit_mode : std_logic_vector(1 downto 0) is axi_fsm_flags(5 downto 4);	-- 8 / 10 / 12 bit mode for cmv12000

begin

clk_gen_inst : entity work.clk_gen	
	generic map(BASE_TIME => 10 ns)
	port map(clk_out => clk);
	
fsm_inst : entity work.fsm_trig 
	port map(

	clk => clk,		
	rst => rst,
	
	axi_fsm_control(0) => rst_active,
	axi_fsm_control(1) => ld_active,
	axi_fsm_control(2) => trig_cmp,
	axi_fsm_control(3) => trig_soft,
	axi_fsm_control(4) => acq_done,
	
	axi_fsm_flags(0) =>	spi_diff,
	axi_fsm_flags(1) =>	cmp_f,
	axi_fsm_flags(2) =>	soft_f,
	axi_fsm_flags(3) =>	exp_flag,
	axi_fsm_flags(5 downto 4) => bit_mode, 
	
	axi_fsm_state => axi_fsm_state,
		
	init_done => init_done, 
	rst_done => rst_done,
	ld_done => ld_done,
	spi_done => spi_done, 
	spi_last => spi_last,
	
	acq_ready => acq_ready,
	

	-- output signals state machine
	init_state => init_state,
	seq_rst_state => seq_rst_state,
	idle_mode_state => idle_mode_state,
	load_data_state => load_data_state,
	spi_state => spi_state,
	spi_transfer_state => spi_transfer_state,
	internal_mode_state =>internal_mode_state,
	external_mode_state => external_mode_state,
	acq_image_state => acq_image_state
	);
	
	
	process
	begin
			  
	init_done <= '0'; 
	rst_active <= '0';
	rst_done <= '0';
	ld_active <= '0';
	ld_done <= '0';
	spi_done <= '0'; 
	spi_last <= '0';
	acq_done <= '0';
	acq_ready <= '0';
	bit_mode <= "00";
	
	--settings flag--
	spi_diff <= '0';
	cmp_f <= '0';
	soft_f <= '0';
	exp_flag <= '0';
	
	--trig_en <= '0';
	trig_soft <= '0';
	trig_cmp <= '0';
	rst <= '0';
	
	--GLOBAL RESET--
	wait for 35 ns;
	rst <= '0';
	wait for 10 ns;
	rst <= '1';
------------------------	
	spi_diff <= '1';
	cmp_f <= '1';
	soft_f <= '1';
	exp_flag <= '1';
------------------------	
	-- INITIALIZATION TEST--
	wait for 30ns;
	init_done <= '1';
	wait for 10 ns;
	init_done <= '0';
	wait for 10ns;
	rst_done <= '1';
	wait for 10ns;
	rst_done <= '0';

------------------------	
	spi_diff <= '0';
	cmp_f <= '0';
	soft_f <= '0';
	exp_flag <= '0';
------------------------
	-- SEQUENCE RESET TEST--
	wait for 20 ns;
	rst_active <= '1';
	wait for 20 ns;
	--rst_active <= '0';
	rst_done <= '1';
	wait for 10ns;
	rst_done <= '0';
	wait for 50ns;
	rst_active <= '0';
	wait for 30 ns;
	rst_active <= '1';
	wait for 30 ns;
	rst_done <= '1';
	
	
	--LOAD DATA TEST--
	wait for 10ns;
	ld_active <= '1';
	wait for 10ns; 
	-- load flags
	spi_diff <= '1';
	cmp_f <= '0';
	soft_f <= '1';
	--exp_flag <= '1';
	
	wait for 30ns;
	ld_done <= '1';
	wait for 10ns;
	ld_done <= '0';
	wait for 20 ns;
	
	ld_active <= '0';
	wait for 10ns;
	ld_active <= '1';
	wait for 10ns;
	ld_done <= '1';
	wait for 10ns;
	ld_done <= '0';
	ld_active <= '0';
	wait for 50ns;
	
	
	-- TRIGGER ENABLE--   -- dopisaæ !trig_en ---->> IDLE_S
	trig_soft <= '1';
	wait for 20ns;
	trig_soft <= '0';
	wait for 20ns;
	--SPI TEST--
	spi_diff <= '1';
	wait for 20 ns;
	
	for I in 0 to 3 loop
		wait for 20 ns;
		spi_done <= '1';
		wait for 10 ns;
		spi_done <= '0';
	end loop;
	spi_last <= '1';
	wait for 40 ns;
	spi_last <= '0';
	wait for 40ns;
	
	-- ACQ TEST
	acq_ready <= '1';
	wait for 100 ns;
	acq_ready <= '0';
	acq_done <= '1';
	wait for 10 ns;
	acq_done <= '0';
	wait for 40ns;
	
	-- NEW FRAME --> test mode --
	trig_soft <= '1';
	
	wait for 30 ns;
	trig_soft <= '1';
	--spi_diff <= '0';
	wait for 50 ns;
	trig_soft <= '0';
	wait for 40ns;
	
		
	acq_ready <= '1';
	wait for 20 ns;
	acq_ready <= '0';
	wait for 10ns;
	acq_done <= '1';
	wait for 10 ns;
	acq_done <= '0';
	wait for 50ns;
	
	trig_soft <= '1';
	wait for 10ns;
	trig_soft <= '0';
	wait for 50ns;
	wait for 20 ns;
	acq_ready <= '1';
	wait for 20 ns;
	acq_ready <= '0';
	wait for 40ns;
	acq_done <= '1';
	
	
	
	
	
	wait for 100ns;
	end process;
	
			
	
end testBench;
