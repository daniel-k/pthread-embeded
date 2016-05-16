NEWLIB = ../x86/x86_64-hermit
MAKE = make
ARFLAGS_FOR_TARGET = rsv
CP = cp
C_source =  $(wildcard *.c) platform/hermit/pte_osal.c platform/helper/tls-helper.c
NAME = libpthread.a
OBJS = $(C_source:.c=.o)

#
# Prettify output
V = 0
ifeq ($V,0)
	Q = @
	P = > /dev/null
endif

XRAY_CFLAGS += -finstrument-functions -falign-functions=32 \
-DXRAY -DXRAY_DISABLE_BROWSER_INTEGRATION -DXRAY_NO_DEMANGLE \
-DXRAY_ANNOTATE

# other implicit rules
%.o : %.c
	@echo [CC] $@
	$Q$(CC_FOR_TARGET) -c $(CFLAGS_FOR_TARGET) $(XRAY_CFLAGS) -o $@ $<

default: all

all: $(NAME)

$(NAME): $(OBJS)
	$Q$(AR_FOR_TARGET) $(ARFLAGS_FOR_TARGET) $@ $(OBJS)
	$Q$(CP) $@ $(NEWLIB)/lib
	$Q$(CP) pthread.h $(NEWLIB)/include
	$Q$(CP) semaphore.h $(NEWLIB)/include
	$Q$(CP) platform/hermit/pte_types.h $(NEWLIB)/include
	
clean:
	@echo Cleaning examples
	$Q$(RM) $(NAME) *.o *~ platform/hermit/*.o platform/helper/*.o

veryclean:
	@echo Propper cleaning examples
	$Q$(RM) $(NAME) *.o *~ platform/hermit/*.o platform/helper/*.o

depend:
	$Q$(CC_FOR_TARGET) -MM $(CFLAGS_FOR_TARGET) *.c > Makefile.dep

-include Makefile.dep
# DO NOT DELETE
