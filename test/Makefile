VLOG			= ncverilog
FILEPATH	= ../src
FUNC			= $(FILEPATH)/func_unit.v test_func_unit.v
REGF			= $(FILEPATH)/reg_file.v test_reg_file.v
PC        = $(FILEPATH)/*.v test_pipe_pc.v
SH        = $(FILEPATH)/*.v test_pipe_shift.v +define+N_MEM_TEST=1
IF        = test_general.v +define+FPATH=\"testcase/if_test.dat\"
MULT      = test_general.v +define+FPATH=\"testcase/mult.dat\"
GCD       = test_general.v +define+FPATH=\"testcase/gcd.dat\"

VLOGARG		= +access+r +notimingchecks +nospecify
DEBUG     = +define+DEBUG_MEM_RW
RM        = rm -rf
LOGF      = *.log INCA_* nWaveLog novas*
BASICF    = $(FILEPATH)/header.v $(FILEPATH)/top.v $(FILEPATH)/pipeline.v $(FILEPATH)/ins_decoder.v $(FILEPATH)/reg_file.v $(FILEPATH)/func_unit.v
HEADER    = $(FILEPATH)/header.v
SYNF      = $(FILEPATH)/top_syn.v -v /theda21_2/CBDK_IC_Contest/cur/Verilog/tsmc13.v
RAM       = $(FILEPATH)/RAM2Kx32.v
SYNARG    = +access+r +define+NETLIST=1

gcdsyn :
	$(VLOG) $(HEADER) $(GCD) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=70
gcd :
	$(VLOG) $(BASICF) $(GCD) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=70

multsyn :
	$(VLOG) $(HEADER) $(MULT) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=40
mult :
	$(VLOG) $(BASICF) $(MULT) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=40

ifsyn :
	$(VLOG) $(HEADER) $(IF) $(SYNF) $(RAM) $(DEBUG) $(SYNARG) +define+CYC=630
if :
	$(VLOG) $(BASICF) $(IF) $(RAM) $(VLOGARG) $(DEBUG) +define+CYC=610

shift :
	$(VLOG) $(HEADER) $(SH) $(VLOGARG)

pc  :
	$(VLOG) $(HEADER) $(PC) $(VLOGARG)

func :
	$(VLOG) $(HEADER) $(FUNC) $(VLOGARG)
clean :
	$(RM) $(LOGF)

