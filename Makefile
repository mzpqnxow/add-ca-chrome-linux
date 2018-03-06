LIBNSS_TOOLS := libnss3-tools 
QUIET_INSTALL := "DEBIAN_FRONTEND=noninteractive apt-get install -y -q"
SUDO := sudo

CA_CERT = "" # Specify on commandline, mandatory 
CA_NAME = Private CA # Override on commandline, optional

all: depend
	@if [ $(CA_CERT) = "" ]; then echo 'Please specify a CA x509 PEM file as as `make CA_CERT=<path>`'; /bin/false; fi
	@echo "Adding $(CA_CERT)"
	certutil -d sql:$$HOME/.pki/nssdb \
      -A \
      -t "C,," \
      -n "$(CA_NAME)" \
      -i $(CA_CERT) 

depend:
	@echo -n "Checking dependencies ..." 
	@dpkg --list | grep "$(LIBNSS_TOOLS)" 2>&1 > /dev/null || \
	    $(SUDO) $(QUIET_INSTALL) $(LIBNSS_TOOLS); \
            echo " OK"

depend:



.PHONY: all depend
