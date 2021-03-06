-- ======================================================================
-- DES encryption/decryption testbench
-- tests according to NIST 800-17 special publication
-- Copyright (C) 2011 Torsten Meissner
-------------------------------------------------------------------------
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-- ======================================================================


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity tb_des is
end entity tb_des;


architecture rtl of tb_des is


  type t_array is array (natural range <>) of std_logic_vector(0 to 63);

  constant c_variable_plaintext_known_answers : t_array(0 to 63) :=
    (x"95F8A5E5DD31D900", x"DD7F121CA5015619", x"2E8653104F3834EA",
     x"4BD388FF6CD81D4F", x"20B9E767B2FB1456", x"55579380D77138EF",
     x"6CC5DEFAAF04512F", x"0D9F279BA5D87260", x"D9031B0271BD5A0A",
     x"424250B37C3DD951", x"B8061B7ECD9A21E5", x"F15D0F286B65BD28",
     x"ADD0CC8D6E5DEBA1", x"E6D5F82752AD63D1", x"ECBFE3BD3F591A5E",
     x"F356834379D165CD", x"2B9F982F20037FA9", x"889DE068A16F0BE6",
     x"E19E275D846A1298", x"329A8ED523D71AEC", x"E7FCE22557D23C97",
     x"12A9F5817FF2D65D", x"A484C3AD38DC9C19", x"FBE00A8A1EF8AD72",
     x"750D079407521363", x"64FEED9C724C2FAF", x"F02B263B328E2B60",
     x"9D64555A9A10B852", x"D106FF0BED5255D7", x"E1652C6B138C64A5",
     x"E428581186EC8F46", x"AEB5F5EDE22D1A36", x"E943D7568AEC0C5C",
     x"DF98C8276F54B04B", x"B160E4680F6C696F", x"FA0752B07D9C4AB8",
     x"CA3A2B036DBC8502", x"5E0905517BB59BCF", x"814EEB3B91D90726",
     x"4D49DB1532919C9F", x"25EB5FC3F8CF0621", x"AB6A20C0620D1C6F",
     x"79E90DBC98F92CCA", x"866ECEDD8072BB0E", x"8B54536F2F3E64A8",
     x"EA51D3975595B86B", x"CAFFC6AC4542DE31", x"8DD45A2DDF90796C",
     x"1029D55E880EC2D0", x"5D86CB23639DBEA9", x"1D1CA853AE7C0C5F",
     x"CE332329248F3228", x"8405D1ABE24FB942", x"E643D78090CA4207",
     x"48221B9937748A23", x"DD7C0BBD61FAFD54", x"2FBC291A570DB5C4",
     x"E07C30D7E4E26E12", x"0953E2258E8E90A1", x"5B711BC4CEEBF2EE",
     x"CC083F1E6D9E85F6", x"D2FD8867D50D2DFE", x"06E7EA22CE92708F",
     x"166B40B44ABA4BD6");

  constant c_variable_key_known_answers : t_array(0 to 55) :=
    (x"95A8D72813DAA94D", x"0EEC1487DD8C26D5", x"7AD16FFB79C45926",
     x"D3746294CA6A6CF3", x"809F5F873C1FD761", x"C02FAFFEC989D1FC",
     x"4615AA1D33E72F10", x"2055123350C00858", x"DF3B99D6577397C8",
     x"31FE17369B5288C9", x"DFDD3CC64DAE1642", x"178C83CE2B399D94",
     x"50F636324A9B7F80", x"A8468EE3BC18F06D", x"A2DC9E92FD3CDE92",
     x"CAC09F797D031287", x"90BA680B22AEB525", x"CE7A24F350E280B6",
     x"882BFF0AA01A0B87", x"25610288924511C2", x"C71516C29C75D170",
     x"5199C29A52C9F059", x"C22F0A294A71F29F", x"EE371483714C02EA",
     x"A81FBD448F9E522F", x"4F644C92E192DFED", x"1AFA9A66A6DF92AE",
     x"B3C1CC715CB879D8", x"19D032E64AB0BD8B", x"3CFAA7A7DC8720DC",
     x"B7265F7F447AC6F3", x"9DB73B3C0D163F54", x"8181B65BABF4A975",
     x"93C9B64042EAA240", x"5570530829705592", x"8638809E878787A0",
     x"41B9A79AF79AC208", x"7A9BE42F2009A892", x"29038D56BA6D2745",
     x"5495C6ABF1E5DF51", x"AE13DBD561488933", x"024D1FFA8904E389",
     x"D1399712F99BF02E", x"14C1D7C1CFFEC79E", x"1DE5279DAE3BED6F",
     x"E941A33F85501303", x"DA99DBBC9A03F379", x"B7FC92F91D8E92E9",
     x"AE8E5CAA3CA04E85", x"9CC62DF43B6EED74", x"D863DBB5C59A91A0",
     x"A1AB2190545B91D7", x"0875041E64C570F7", x"5A594528BEBEF1CC",
     x"FCDB3291DE21F0C0", x"869EFD7F9F265A09");

  constant c_permutation_operation_known_answers_keys : t_array(0 to 31) :=
    (x"1046913489980131", x"1007103489988020", x"10071034C8980120",
     x"1046103489988020", x"1086911519190101", x"1086911519580101",
     x"5107B01519580101", x"1007B01519190101", x"3107915498080101",
     x"3107919498080101", x"10079115B9080140", x"3107911598080140",
     x"1007D01589980101", x"9107911589980101", x"9107D01589190101",
     x"1007D01598980120", x"1007940498190101", x"0107910491190401",
     x"0107910491190101", x"0107940491190401", x"19079210981A0101",
     x"1007911998190801", x"10079119981A0801", x"1007921098190101",
     x"100791159819010B", x"1004801598190101", x"1004801598190102",
     x"1004801598190108", x"1002911598100104", x"1002911598190104",
     x"1002911598100201", x"1002911698100101");

  constant c_permutation_operation_known_answers_cipher : t_array(0 to 31) :=
    (x"88D55E54F54C97B4", x"0C0CC00C83EA48FD", x"83BC8EF3A6570183",
     x"DF725DCAD94EA2E9", x"E652B53B550BE8B0", x"AF527120C485CBB0",
     x"0F04CE393DB926D5", x"C9F00FFC74079067", x"7CFD82A593252B4E",
     x"CB49A2F9E91363E3", x"00B588BE70D23F56", x"406A9A6AB43399AE",
     x"6CB773611DCA9ADA", x"67FD21C17DBB5D70", x"9592CB4110430787",
     x"A6B7FF68A318DDD3", x"4D102196C914CA16", x"2DFA9F4573594965",
     x"B46604816C0E0774", x"6E7E6221A4F34E87", x"AA85E74643233199",
     x"2E5A19DB4D1962D6", x"23A866A809D30894", x"D812D961F017D320",
     x"055605816E58608F", x"ABD88E8B1B7716F1", x"537AC95BE69DA1E1",
     x"AED0F6AE3C25CDD8", x"B3E35A5EE53E7B8D", x"61C79C71921A2EF8",
     x"E2F5728F0995013C", x"1AEAC39A61F0A464");

  constant c_substitution_table_test_keys : t_array(0 to 18) :=
    (x"7CA110454A1A6E57", x"0131D9619DC1376E", x"07A1133E4A0B2686",
     x"3849674C2602319E", x"04B915BA43FEB5B6", x"0113B970FD34F2CE",
     x"0170F175468FB5E6", x"43297FAD38E373FE", x"07A7137045DA2A16",
     x"04689104C2FD3B2F", x"37D06BB516CB7546", x"1F08260D1AC2465E",
     x"584023641ABA6176", x"025816164629B007", x"49793EBC79B3258F",
     x"4FB05E1515AB73A7", x"49E95D6D4CA229BF", x"018310DC409B26D6",
     x"1C587F1C13924FEF");

  constant c_substitution_table_test_plain : t_array(0 to 18) :=
    (x"01A1D6D039776742", x"5CD54CA83DEF57DA", x"0248D43806F67172",
     x"51454B582DDF440A", x"42FD443059577FA2", x"059B5E0851CF143A",
     x"0756D8E0774761D2", x"762514B829BF486A", x"3BDD119049372802",
     x"26955F6835AF609A", x"164D5E404F275232", x"6B056E18759F5CCA",
     x"004BD6EF09176062", x"480D39006EE762F2", x"437540C8698F3CFA",
     x"072D43A077075292", x"02FE55778117F12A", x"1D9D5C5018F728C2",
     x"305532286D6F295A");

  constant c_substitution_table_test_cipher : t_array(0 to 18) :=
    (x"690F5B0D9A26939B", x"7A389D10354BD271", x"868EBB51CAB4599A",
     x"7178876E01F19B2A", x"AF37FB421F8C4095", x"86A560F10EC6D85B",
     x"0CD3DA020021DC09", x"EA676B2CB7DB2B7A", x"DFD64A815CAF1A0F",
     x"5C513C9C4886C088", x"0A2AEEAE3FF4AB77", x"EF1BF03E5DFA575A",
     x"88BF0DB6D70DEE56", x"A1F9915541020B56", x"6FBF1CAFCFFD0556",
     x"2F22E49BAB7CA1AC", x"5A6B612CC26CCE4A", x"5F4C038ED12B2E41",
     x"63FAC0D034D9F793");

  signal s_reset     : std_logic := '0';
  signal s_clk       : std_logic := '0';
  signal s_mode      : std_logic := '0';
  signal s_key       : std_logic_vector(0 to 63) := (others => '0');
  signal s_datain    : std_logic_vector(0 to 63) := (others => '0');
  signal s_validin   : std_logic := '0';
  signal s_acceptout : std_logic;
  signal s_dataout   : std_logic_vector(0 to 63);
  signal s_validout  : std_logic;
  signal s_acceptin  : std_logic;


  component des is
    generic (
      design_type : string := "ITER"
    );
    port (
      reset_i     : in  std_logic;
      clk_i       : in  std_logic;
      mode_i      : in  std_logic;
      key_i       : in  std_logic_vector(0 TO 63);
      data_i      : in  std_logic_vector(0 TO 63);
      valid_i     : in  std_logic;
      accept_o    : out std_logic;
      data_o      : out std_logic_vector(0 TO 63);
      valid_o     : out std_logic;
      accept_i    : in  std_logic
    );
  end component des;


begin


  s_clk   <= not(s_clk) after 10 ns;
  s_reset <= '1' after 100 ns;


  teststimuliP : process is
  begin
    -- ENCRYPTION TESTS
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= x"0101010101010101";
    s_datain  <= x"8000000000000000";
    wait until s_reset = '1';
    wait until rising_edge(s_clk);
    -- Variable plaintext known answer test
    for index in c_variable_plaintext_known_answers'range loop
      s_validin <= '1';
      if(index /= 0) then
        s_datain <= '0' & s_datain(0 to 62);
      end if;
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Inverse permutation known answer test
    s_key     <= x"0101010101010101";
    for index in c_variable_plaintext_known_answers'range loop
      s_validin <= '1';
      s_datain  <= c_variable_plaintext_known_answers(index);
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Variable key known answer test
    s_key     <= x"8000000000000000";
    for index in c_variable_key_known_answers'range loop
      s_validin <= '1';
      if(index /= 0) then
        if(index = 7 or index = 14 or index = 21 or index = 28 or index = 35 or
           index = 42 or index = 49) then
          s_key <= "00" & s_key(0 to 61);
        else
          s_key <= '0' & s_key(0 to 62);
        end if;
      end if;
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Permutation operation known answer test
    s_datain <= x"0000000000000000";
    for index in c_permutation_operation_known_answers_keys'range loop
      s_validin <= '1';
      s_key     <= c_permutation_operation_known_answers_keys(index);
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Substitution table known answer test
    for index in c_substitution_table_test_keys'range loop
      s_validin <= '1';
      s_key     <= c_substitution_table_test_keys(index);
      s_datain  <= c_substitution_table_test_plain(index);
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    -- DECRYPTION TESTS
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Variable ciphertext known answer test
    s_key     <= x"0101010101010101";
    for index in c_variable_plaintext_known_answers'range loop
      s_mode    <= '1';
      s_validin <= '1';
      s_datain  <= c_variable_plaintext_known_answers(index);
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Initial permutation known answer test
    s_key     <= x"0101010101010101";
    s_datain  <= x"8000000000000000";
    for index in c_variable_plaintext_known_answers'range loop
      s_mode    <= '1';
      s_validin <= '1';
      if(index /= 0) then
        s_datain <= '0' & s_datain(0 to 62);
      end if;
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Variable key known answer test
    s_key     <= x"8000000000000000";
    for index in c_variable_key_known_answers'range loop
      s_mode    <= '1';
      s_validin <= '1';
      s_datain  <= c_variable_key_known_answers(index);
      if(index /= 0) then
        if(index = 7 or index = 14 or index = 21 or index = 28 or index = 35 or
           index = 42 or index = 49) then
          s_key <= "00" & s_key(0 to 61);
        else
          s_key <= '0' & s_key(0 to 62);
        end if;
      end if;
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Permutation operation known answer test
    for index in c_permutation_operation_known_answers_keys'range loop
      s_mode    <= '1';
      s_validin <= '1';
      s_datain  <= c_permutation_operation_known_answers_cipher(index);
      s_key     <= c_permutation_operation_known_answers_keys(index);
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait for 100 ns;
    wait until rising_edge(s_clk);
    -- Substitution table known answer test
    for index in c_substitution_table_test_keys'range loop
      s_mode    <= '1';
      s_validin <= '1';
      s_key     <= c_substitution_table_test_keys(index);
      s_datain  <= c_substitution_table_test_cipher(index);
      wait until rising_edge(s_clk) and s_acceptout = '1';
    end loop;
    s_mode    <= '0';
    s_validin <= '0';
    s_key     <= (others => '0');
    s_datain  <= (others => '0');
    wait;
  end process teststimuliP;


  testcheckerP : process is
    variable v_plaintext : std_logic_vector(0 to 63) := x"8000000000000000";
  begin
    s_acceptin <= '1';
    wait until s_reset = '1';
    report "# ENCRYPTION TESTS";
    report "# Variable plaintext known answer test";
    for index in c_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = c_variable_plaintext_known_answers(index))
          report "encryption error"
          severity error;
    end loop;
    report "# Inverse permutation known answer test";
    for index in c_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = v_plaintext)
          report "encryption error"
          severity error;
        v_plaintext := '0' & v_plaintext(0 to 62);
    end loop;
    report "# Variable key known answer test";
    for index in c_variable_key_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = c_variable_key_known_answers(index))
          report "encryption error"
          severity error;
    end loop;
    report "# Permutation operation known answer test";
    for index in c_permutation_operation_known_answers_cipher'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = c_permutation_operation_known_answers_cipher(index))
          report "encryption error"
          severity error;
    end loop;
    report "# Substitution table known answer test";
    for index in c_substitution_table_test_cipher'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = c_substitution_table_test_cipher(index))
          report "encryption error"
          severity error;
    end loop;
    report "# DECRYPTION TESTS";
    report "# Variable ciphertext known answer test";
    v_plaintext := x"8000000000000000";
    for index in c_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = v_plaintext)
          report "decryption error"
          severity error;
        v_plaintext := '0' & v_plaintext(0 to 62);
    end loop;
    report "# Initial permutation known answer test";
    for index in c_variable_plaintext_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = c_variable_plaintext_known_answers(index))
          report "decryption error"
          severity error;
    end loop;
    report "# Variable key known answer test";
    for index in c_variable_key_known_answers'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = x"0000000000000000")
          report "decryption error"
          severity error;
    end loop;
    report "# Permutation operation known answer test";
    for index in c_permutation_operation_known_answers_keys'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = x"0000000000000000")
          report "decryption error"
          severity error;
    end loop;
    report "# Substitution table known answer test";
    for index in c_substitution_table_test_cipher'range loop
      wait until rising_edge(s_clk) and s_validout = '1';
        assert (s_dataout = c_substitution_table_test_plain(index))
          report "decryption error"
          severity error;
    end loop;
    report "# Successfully passed all tests";
    assert false;
    wait;
  end process testcheckerP;


  i_des : des
  generic map (
    design_type => "ITER"
  )
  port map (
    reset_i  => s_reset,
    clk_i    => s_clk,
    mode_i   => s_mode,
    key_i    => s_key,
    data_i   => s_datain,
    valid_i  => s_validin,
    accept_o => s_acceptout,
    data_o   => s_dataout,
    valid_o  => s_validout,
    accept_i => s_acceptin
  );


end architecture rtl;
