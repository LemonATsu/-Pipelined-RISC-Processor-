VLOG			= ncverilog
FILEPATH	= ../src
FUNC			= $(FILEPATH)/func_unit.v test_func_unit.v
REGF			= $(FILEPATH)/reg_file.v test_reg_file.v
PC        = $(FILEPATH)/*.v test_pipe_pc.v
SH        = $(FILEPATH)/*.v test_pipe_shift.v +define+N_MEM_TEST=1
HEADER		= $(FILEPATH)/header.v
VLOGARG		= +access+r
RM        = rm -rf
LOGF      = *.log INCA_* nWaveLog novas*

shift :
	$(VLOG) $(HEADER) $(SH) $(VLOGARG)

pc  :
	$(VLOG) $(HEADER) $(PC) $(VLOGARG)

func :
	$(VLOG) $(HEADER) $(FUNC) $(VLOGARG)
clean :
	$(RM) $(LOGF)

