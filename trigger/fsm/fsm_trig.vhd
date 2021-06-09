library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fsm_trig is
	generic(DATA_WIDTH : natural := 32
		);
	
	port(
	clk : in std_logic;		
	rst : in std_logic;
	
	-- AXI_REGISTERS INPUT / OUTPUTS --
	axi_fsm_state : out std_logic_vector (DATA_WIDTH-1 downto 0);
	axi_fsm_flags : in std_logic_vector (DATA_WIDTH-1 downto 0);
	axi_fsm_control : in std_logic_vector (DATA_WIDTH-1 downto 0);
	
	
	
	--trig_en : in std_logic;	  -- trigger enable, global flag      ---->> stworzyc mozliwosc wyzwolenia tylko jednego zdjecia, oraz tryb ci¹g³y, teraz jest to œrednio zrobione bo 
	----   jest mo¿liwoœc zatrzaœniêcia w trybie internal, external
 										
	
	init_done : in std_logic; -- flag done from initialization
	rst_done : in std_logic;  -- reset done flag  
	ld_done : in std_logic;   -- scheduler done flag
	spi_done : in std_logic;     -- spi done flag
	spi_last : in std_logic; 	 -- last data transfer from spi
	
	--acq_done : in std_logic;     -- acquisition done flag
	acq_ready : in std_logic;
	
	
	-- output signals state machine
	init_state : out std_logic;
	seq_rst_state : out std_logic;
	idle_mode_state : out std_logic;
	load_data_state : out std_logic;
	spi_state : out std_logic;
	spi_transfer_state : out std_logic;
	internal_mode_state : out std_logic;
	external_mode_state : out std_logic;
	acq_image_state : out std_logic
	);
	
end fsm_trig;


architecture fsm of fsm_trig is

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


-- pewne flagi zostana ustawione podczas load_data_s

--flag set from load_data--
signal spi_diff_in : std_logic;
signal cmp_f_in : std_logic;
signal soft_f_in : std_logic;
signal exp_flag_in : std_logic;
signal bit_mode_in : std_logic_vector(1 downto 0);
--signal bit_mode_1_in : std_logic_vector(1 downto 0);

-- state  outputs --
--signal init_state_s : std_logic;


type mem is array (natural range <>) of
	std_logic_vector (DATA_WIDTH - 1 downto 0);


begin

-- blad!! --	   		  							-- dodaæ flagê która bêdzie odpowiadaæ za
--spi_diff_in <= spi_diff;			    -- wykonane zdjêcia z tymi samymi ustawieniami											
--cmp_f_in <= cmp_f;					    -- lub ró¿nymi
--test_f_in <= test_f;
--exp_flag_in <= exp_flag;  
-- with select?				


	
fms_process : process(clk, trig_soft, trig_cmp)

type trig_state is (
init_s,
idle_s,
seq_rst_s,
load_data_s,
spi_s, spi_transfer_s,
comp_mode_s, soft_mode_s,
internal_mode_s, external_mode_s,
acq_image_s );

variable state : trig_state := init_s;

--INIT variables--
variable init_start_v : std_logic := '1';
variable spi_active_v : std_logic := '0';
variable spi_ready_v : std_logic := '0';
--variable spi_done_all_v : std_logic := '0';

variable trig_en_v : std_logic := '0';

variable exp_f_v : std_logic := '0';
--variable bit_mode : std_logic := '0';		-- changing bit more, wait 1 us after upload spi settings

variable init_state_v : std_logic := '1'; 
variable seq_rst_state_v : std_logic := '0'; 
variable idle_mode_state_v : std_logic := '0';
variable load_data_state_v : std_logic := '0';
variable spi_state_v : std_logic := '0';
variable spi_transfer_state_v : std_logic := '0';
variable internal_mode_state_v : std_logic := '0';
variable external_mode_state_v : std_logic := '0';
variable acq_image_state_v : std_logic := '0';

--variable init_state_s : std_logic := '0';

begin
	 
	
if rising_edge(clk) then
	if rst = '0' then
		state := init_s;
		--ld_done <= '0';
		init_start_v := '1';
		spi_diff_in <= '1';
		cmp_f_in <= '1';
		soft_f_in <= '0';
		exp_flag_in <= '0';
		bit_mode_in <= "00"; -- stworzyc rejest przsuwny (1:0) -> ustawia flage spi_diff gdy jest roznica w ustawieniach
		--bit_mode_1_in <= "00";
	else
		case state is 
			-- INIT_S STATE --
			-- TBD --
			when init_s =>
				init_state_v := '1';
				
				if(init_start_v = '1' and init_done = '1')	then
					state := seq_rst_s;
					init_state_v := '0';
					seq_rst_state_v := '1';
				end if;
 			
				-- SEQ_RES_N STATE --
			when seq_rst_s =>
			--seq_rst_state_v := '1'; 
			
			if(rst_done = '1') then
				state := idle_s;
				seq_rst_state_v := '0';
				idle_mode_state_v := '1';
			end if;
				
			-----------------------	
			-- IDLE_S STATE
			when idle_s =>  						--- w idle mode sprawdzac flage stanu idle, wtedy mozna wykonac scheduler lub trigger zdjêcia !!!!
				idle_mode_state_v := '1';
				
				trig_en_v := trig_soft xor trig_cmp;
				
				if(ld_active = '1' and trig_en_v = '0') then   -- rising_edge(ld_active)
					state := load_data_s;
					idle_mode_state_v := '0';
					load_data_state_v := '1';
				
				elsif(trig_soft = '1' and trig_en_v = '1' and ld_active = '0' and cmp_f_in = '0' and soft_f_in = '1') then --rising_edge(trig_soft)
					state := soft_mode_s;
					idle_mode_state_v := '0';
					exp_f_v := '0';
					
				elsif(trig_cmp = '1' and trig_en_v = '1' and ld_active = '0' and cmp_f_in = '1' and soft_f_in = '0') then  -- rising_edge(trig_cmp)
					state := comp_mode_s;
					idle_mode_state_v := '0';
					exp_f_v := exp_flag_in;
										
				elsif(rst_active = '1' and trig_en_v = '0') then     -- rising_edge(rst_active)
					state := seq_rst_s;
					idle_mode_state_v := '0';
					seq_rst_state_v := '1';
				else
					state := idle_s;
				end if;
			
			-- LOAD_DATA_S STATE --	
			when load_data_s =>
			load_data_state_v := '1';
			
			if(ld_done = '1') then
				state := idle_s;
				load_data_state_v := '0';
				idle_mode_state_v := '1';
				-- WYPE£NIC REJESTRY FLAG
				spi_diff_in <= spi_diff;
				cmp_f_in <= cmp_f;				 -- dodac fsm_control : in std_logic_vector (31 downto 0)
				soft_f_in <= soft_f;
				exp_flag_in <= exp_flag; -- -->> gdzie reset tych flag ?
				bit_mode_in <= bit_mode_in;
			end if;

			
			-- SOFTWARE_MODE_S STATE --	
			when soft_mode_s => 
			state := spi_s;
			spi_state_v := '1';
			--internal_mode_state_v := '1';
			
			-- COMP_MODE_S STATE --
			when comp_mode_s => 
			state := spi_s;
			spi_state_v := '1';
				--internal_mode_state_v := '1';
		
			-- SPI_S STATE --	
			when spi_s =>
			spi_state_v := '1';
			-- tutaj uwzglêdniæ iloœæ przesy³anych danych przez SPI
			
			if(spi_last = '1') then
				spi_diff_in <= '0';
			end if;
			
			if(spi_done = '0' and spi_last = '0' and spi_diff_in = '1') then
				state := spi_transfer_s;
				spi_transfer_state_v := '1';
				spi_state_v := '0';
				
			elsif(spi_diff_in = '0')	then   -- pomyslec nad logika przejscia
				if(exp_f_v = '0') then
					state := internal_mode_s;
					internal_mode_state_v := '1';
					spi_state_v := '0';
				else
					state := external_mode_s;
					external_mode_state_v := '1'; 
					spi_state_v := '0';
				end if;				
			else
				state := spi_s;
			end if;
			
			-- SPI_TRANSFER_S STATE --
			when spi_transfer_s =>
				spi_transfer_state_v := '1';
			
			if(spi_done = '1') then
				state := spi_s;
				spi_transfer_state_v := '0';
				spi_state_v := '1';
			end if;
			
			-- INTERNAL_MODE_S STATE --
			when internal_mode_s => 
			internal_mode_state_v := '1';
			
			if(acq_ready = '1') then
				state := acq_image_s;
				internal_mode_state_v := '0';
				acq_image_state_v := '1';
			end if;
			
			-- EXPOSURE_MODE_S STATE --
			when external_mode_s => 
			external_mode_state_v := '1';
			
			if(acq_ready = '1') then
				state := acq_image_s;
				external_mode_state_v := '0';
				acq_image_state_v := '1';
			end if;
			
			-- ACQ_IMAGE_S STATE --
			when acq_image_s =>
			acq_image_state_v := '1';
			
			if(acq_done = '1') then
				state := idle_s;
				idle_mode_state_v := '1';
				acq_image_state_v := '0';
			end if;
			
			
		end case;
		end if;
		
	end if;
	
	
	init_state <= init_state_v;
	axi_fsm_state(0) <= init_state_v;
	
	seq_rst_state <= seq_rst_state_v;
	axi_fsm_state(1) <= seq_rst_state_v;
	
	idle_mode_state <= idle_mode_state_v;
	axi_fsm_state(2) <= idle_mode_state_v;
	
	load_data_state <= load_data_state_v;
	axi_fsm_state(3) <= load_data_state_v;
	
	spi_state <= spi_state_v;
	axi_fsm_state(4) <= spi_state_v;
	
	spi_transfer_state <= spi_transfer_state_v;
	axi_fsm_state(5) <= spi_transfer_state_v;
	
	internal_mode_state <= internal_mode_state_v;
	axi_fsm_state(6) <= internal_mode_state_v;
	
	external_mode_state <= external_mode_state_v;
	axi_fsm_state(7) <= external_mode_state_v;
	
	acq_image_state <= acq_image_state_v;
	axi_fsm_state(8) <= acq_image_state_v;
	
	
end process;

	
end fsm;
