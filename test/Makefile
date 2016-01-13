VLOG			= ncverilog
FILEPATH	= ../src
FUNC			= $(FILEPATH)/func_unit.v test_func_unit.v
REGF			= $(FILEPATH)/reg_file.v test_reg_file.v
PC        = $(FILEPATH)/*.v test_pipe_pc.v
SH        = $(FILEPATH)/*.v test_pipe_shift.v +define+N_MEM_TEST=1

POW       = test_general.v +define+FPATH=\"testcase/pow.dat\"
SUM       = test_general.v +define+FPATH=\"testcase/08_sum.dat\"
LCM2      = test_general.v +define+FPATH=\"testcase/07_lcm_2.dat\"
FACT      = test_general.v +define+FPATH=\"testcase/05_factorial.dat\"
LCM       = test_general.v +define+FPATH=\"testcase/04_lcm.dat\"
DIV       = test_general.v +define+FPATH=\"testcase/03_div.dat\"
MULT      = test_general.v +define+FPATH=\"testcase/02_mult.dat\"
GCD       = test_general.v +define+FPATH=\"testcase/01_gcd.dat\"


VLOGARG		= +access+r +notimingchecks +nospecify
DEBUG     = +define+DEBUG_MEM_RW
RM        = rm -rf
LOGF      = *.log INCA_* nWaveLog novas*
BASICF    = $(FILEPATH)/header.v $(FILEPATH)/top.v $(FILEPATH)/pipeline.v $(FILEPATH)/ins_decoder.v $(FILEPATH)/reg_file.v $(FILEPATH)/func_unit.v
HEADER    = $(FILEPATH)/header.v
SYNF      = $(FILEPATH)/top_syn.v -v /theda21_2/CBDK_IC_Contest/cur/Verilog/tsmc13.v
RAM       = $(FILEPATH)/RAM2Kx32.v
SYNARG    = +access+r +define+NETLIST=1

powsyn:
	$(VLOG) $(HEADER) $(POW) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=595
pow :
	$(VLOG) $(BASICF) $(POW) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=595

lcm2syn:
	$(VLOG) $(HEADER) $(LCM2) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=1010
lcm2 :
	$(VLOG) $(BASICF) $(LCM2) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=1010

factsyn:
	$(VLOG) $(HEADER) $(FACT) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=110
fact :
	$(VLOG) $(BASICF) $(FACT) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=110

lcmsyn:
	$(VLOG) $(HEADER) $(LCM) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=130
lcm :
	$(VLOG) $(BASICF) $(LCM) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=130

divsyn:
	$(VLOG) $(HEADER) $(DIV) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=60
div :
	$(VLOG) $(BASICF) $(DIV) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=60

gcdsyn :
	$(VLOG) $(HEADER) $(GCD) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=70
gcd :
	$(VLOG) $(BASICF) $(GCD) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=70

multsyn :
	$(VLOG) $(HEADER) $(MULT) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=40
mult :
	$(VLOG) $(BASICF) $(MULT) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=40

sumsyn :
	$(VLOG) $(HEADER) $(SUM) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=630
sum :
	$(VLOG) $(BASICF) $(SUM) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=610

shift :
	$(VLOG) $(HEADER) $(SH) $(VLOGARG)

pc  :
	$(VLOG) $(HEADER) $(PC) $(VLOGARG)

func :
	$(VLOG) $(HEADER) $(FUNC) $(VLOGARG)
clean :
	$(RM) $(LOGF)

