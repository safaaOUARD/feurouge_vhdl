library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity feu_tricolore is
    Port (
        CLK  : in  STD_LOGIC;   -- Horloge 1 Hz
        RST  : in  STD_LOGIC;   -- Reset actif haut
        -- Route A
        R_A  : out STD_LOGIC;
        O_A  : out STD_LOGIC;
        V_A  : out STD_LOGIC;
        -- Route B
        R_B  : out STD_LOGIC;
        O_B  : out STD_LOGIC;
        V_B  : out STD_LOGIC
    );
end feu_tricolore;

architecture Behavioral of feu_tricolore is

    -- Définition des états
    type etat_type is (S0, S1, S2, S3);
    --  S0 : Route A = VERT  (10s), Route B = ROUGE
    --  S1 : Route A = ORANGE (3s), Route B = ROUGE
    --  S2 : Route A = ROUGE,       Route B = VERT  (10s)
    --  S3 : Route A = ROUGE,       Route B = ORANGE (3s)

    signal etat     : etat_type := S0;
    signal compteur : integer range 0 to 23 := 0;

begin

    -- Processus séquentiel : gestion de l'état et du compteur
    process(CLK, RST)
    begin
        if RST = '1' then
            etat     <= S0;
            compteur <= 0;

        elsif rising_edge(CLK) then
            case etat is

                when S0 =>                   -- VERT A (10 secondes)
                    if compteur = 9 then
                        compteur <= 0;
                        etat     <= S1;
                    else
                        compteur <= compteur + 1;
                    end if;

                when S1 =>                   -- ORANGE A (3 secondes)
                    if compteur = 2 then
                        compteur <= 0;
                        etat     <= S2;
                    else
                        compteur <= compteur + 1;
                    end if;

                when S2 =>                   -- VERT B (10 secondes)
                    if compteur = 9 then
                        compteur <= 0;
                        etat     <= S3;
                    else
                        compteur <= compteur + 1;
                    end if;

                when S3 =>                   -- ORANGE B (3 secondes)
                    if compteur = 2 then
                        compteur <= 0;
                        etat     <= S0;
                    else
                        compteur <= compteur + 1;
                    end if;

            end case;
        end if;
    end process;

    -- Processus combinatoire : affectation des sorties
    process(etat)
    begin
        -- Valeurs par défaut (tout rouge = sécurité)
        R_A <= '1'; O_A <= '0'; V_A <= '0';
        R_B <= '1'; O_B <= '0'; V_B <= '0';

        case etat is
            when S0 =>           -- Route A : VERT  / Route B : ROUGE
                V_A <= '1'; R_A <= '0';
                R_B <= '1';

            when S1 =>           -- Route A : ORANGE / Route B : ROUGE
                O_A <= '1'; R_A <= '0';
                R_B <= '1';

            when S2 =>           -- Route A : ROUGE  / Route B : VERT
                R_A <= '1';
                V_B <= '1'; R_B <= '0';

            when S3 =>           -- Route A : ROUGE  / Route B : ORANGE
                R_A <= '1';
                O_B <= '1'; R_B <= '0';
        end case;
    end process;

end Behavioral;