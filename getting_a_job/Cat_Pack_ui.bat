@echo off
py "D:\Games\Steam\steamapps\common\X4 Foundations\X4_Customizer-1.24.12\Framework\Main.py" Cat_Pack -argpass ./getting_a_job/ui -include *.xpl

move "getting_a_job\ui\ext_01.cat" "getting_a_job\subst_02.cat"
move "getting_a_job\ui\ext_01.dat" "getting_a_job\subst_02.dat"