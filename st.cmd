#!/usr/local/epics/base/modules/soft/synApps/support/motor/modules/motorParker/iocs/parkerIOC/bin/linux-x86_64/parker
#
#
#errlogInit(5000)

< envPaths


# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in this build from CARS

dbLoadDatabase "$(IOC_DIR)/dbd/parker.dbd"

parker_registerRecordDeviceDriver pdbbase


cd "${TOP_IOC}"

pwd

### Motors
dbLoadTemplate "motorACR.substitutions"

###drvAsynIPPortConfigure("portName","hostInfo",priority,noAutoConnect,noProcessEos)
#drvAsynIPPortConfigure("ACR9000", "192.168.10.42:5002", 0, 0, 0)
#
drvAsynIPPortConfigure("ACR9000", "10.16.122.17:5002", 0, 0, 0)
#
# some important ASYN definitions
#

#### traceMask definitions
#define ASYN_TRACE_ERROR     0x0001
#define ASYN_TRACEIO_DEVICE  0x0002
#define ASYN_TRACEIO_FILTER  0x0004
#define ASYN_TRACEIO_DRIVER  0x0008
#define ASYN_TRACE_FLOW      0x0010
#define ASYN_TRACE_WARNING   0x0020

#### traceIO mask definitions
#define ASYN_TRACEIO_NODATA 0x0000
#define ASYN_TRACEIO_ASCII  0x0001
#define ASYN_TRACEIO_ESCAPE 0x0002
#define ASYN_TRACEIO_HEX    0x0004

#### traceInfo mask definitions
#define ASYN_TRACEINFO_TIME 0x0001
#define ASYN_TRACEINFO_PORT 0x0002
#define ASYN_TRACEINFO_SOURCE 0x0004
#define ASYN_TRACEINFO_THREAD 0x0008



##asynSetTraceMask(portName,addr,mask)
###asynSetTraceIOMask(portName,addr,mask)
#
##asynSetTraceMask("ACR9000", -1, 3)
asynSetTraceIOMask("ACR9000", 0, 2)
asynOctetSetInputEos("ACR9000",0,"\r")
asynOctetSetOutputEos("ACR9000",0,"\r")


dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=IOC:, R=asyn1, PORT=ACR9000, ADDR=0, OMAX=256, IMAX=256")
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=IOC:, R=asyn2, PORT=ACR9000, ADDR=1, OMAX=256, IMAX=256")
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=IOC:, R=asyn3, PORT=ACR9000, ADDR=2, OMAX=256, IMAX=256")
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=IOC:, R=asyn4, PORT=ACR9000, ADDR=3, OMAX=256, IMAX=256")


#
# PORT, ACR_PORT, number of axes, active poll period (ms), idle poll period (ms)
#

ACRCreateController("ACR1", "ACR9000", 4, 20, 1000)


##asynSetTraceMask("ACR1", -1, 3)
asynSetTraceIOMask("ACR1", 0, 2)


iocInit

# This IOC does not use save/restore yet, so set values of some PVs
#dbpf("IOC:m1.RTRY", "5")
# Tweak step size
#dbpf("IOC:m1.TWV", "10")



