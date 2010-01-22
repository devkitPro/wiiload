#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
#---------------------------------------------------------------------------------
TARGET		:=	wiiload
BUILD		:=	build
SOURCES		:=	source
INCLUDES	:=	include
#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
DEBUGFLAGS	:=
CFLAGS	:=	$(DEBUGFLAGS) -Wall -O3\

CFLAGS	+=	$(INCLUDE)

LDFLAGS	=	$(DEBUGFLAGS)

UNAME := $(shell uname -s)


ifneq (,$(findstring MINGW,$(UNAME)))
	EXEEXT		:= .exe
	PLATFORM_LIBS	:=	-lws2_32
endif

ifneq (,$(findstring Linux,$(shell uname -s)))
	LDFLAGS += -static
endif

ifneq (,$(findstring Darwin,$(shell uname -s)))
	SDK	:=	/Developer/SDKs/MacOSX10.4u.sdk
	OSXCFLAGS	:= -mmacosx-version-min=10.4 -isysroot $(SDK) -arch i386 -arch ppc
	OSXCXXFLAGS	:=	$(OSXCFLAGS)
	CXXFLAGS	+=	-fvisibility=hidden
	LDFLAGS		+= -mmacosx-version-min=10.4 -arch i386 -arch ppc -Wl,-syslibroot,$(SDK)
endif

#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS	:=	$(PLATFORM_LIBS) -lz
#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:=
#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------


export OUTPUT	:=	$(CURDIR)/$(TARGET)$(EXEEXT)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir))

export CC	:=	gcc
export CXX	:=	g++
export AR	:=	ar
export OBJCOPY	:=	objcopy

#---------------------------------------------------------------------------------
# automatically build a list of object files for our project
#---------------------------------------------------------------------------------
CFILES			:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES			:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

export OFILES	:= $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------
	export LD	:=	$(CC)
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
	export LD	:=	$(CXX)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
					$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
					-I$(CURDIR)/$(BUILD)

export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean

#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(OUTPUT)

#---------------------------------------------------------------------------------
install:
	cp $(OUTPUT) $(PREFIX)

#---------------------------------------------------------------------------------
all: clean $(BUILD)

#---------------------------------------------------------------------------------
run:
	$(OUTPUT)

#---------------------------------------------------------------------------------
else

DEPENDS	:=	$(OFILES:.o=.d)


#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(OUTPUT)	:	$(OFILES)
	@echo linking $@
	@$(LD) $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@

#---------------------------------------------------------------------------------
# Compile Targets for C/C++
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
%.o : %.cpp
	@echo $(notdir $<)
	$(CXX) -E -MMD $(CFLAGS) $< > /dev/null
	$(CXX) $(OSXCXXFLAGS) $(CFLAGS) -o $@ -c $<

#---------------------------------------------------------------------------------
%.o : %.c
	@echo $(notdir $<)
	$(CC) -E -MMD $(CFLAGS) $< > /dev/null
	$(CC) $(OSXCFLAGS) $(CFLAGS) -o $@ -c $<

-include $(DEPENDS)

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
