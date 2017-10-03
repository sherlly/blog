# Install yafu under Linux operating system
**NOTE1:** My linux environment: CentOS 6.7

**NOTE2:** Install yafu, gmp, gmp-ecm, msieve in the same directory

**NOTE3:** My install location is /root/sherlly

## STEP 1: Install Dependencies
### zlib
	rpm -qa|grep zlib
	yum install -y zlib-devel-1.2.3-29.el6.x86_64 zlib-1.2.3-29.el6.x86_64
	
### GMP
	rpm -qa|grep gmp

1. if your gmp version>6.0:
	
		yum install -y gmp gmp-devel

2. if your gmp version<6.0 or not found it:

		wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
		tar jxvf gmp-6.1.2.tar.bz2
		mv gmp-6.1.2 gmp
		cd gmp
		./configure
		make
		make install
![](https://i.imgur.com/gL8RlCb.png)	

### GMP-ECM
	wget https://gforge.inria.fr/frs/download.php/file/4663/ecm-6.2.tar.gz
	tar zxvf ecm-6.2.tar.gz
	mv ecm-6.2 gmp-ecm
	cd gmp-ecm
	./configure
	make
	make install

### msieve
	wget http://downloads.sourceforge.net/project/msieve/msieve/Msieve%20v1.52/msieve152.tar.gz
	tar zxvf msieve152.tar.gz
	mv msieve-1.52 msieve
	cd msieve
	make all


## STEP 2: Install Yafu

**1. Download source file**

	git clone https://github.com/DarkenCode/yafu.git
	cd yafu
**2. Modify MakeFile**

	vim MakeFile
		//add new line around line 122：
		LIBS+= -lc -lz
	
		//locate around line 68 and find:
		LIBS += -L../gmp/lib/linux/x86_64
		//then change it to:
		LIBS += -L../gmp/.libs
	
		//locate around line 71 and find:
		LIBS += -L../gmp-ecm/lib/linux/x86_64
		then change it to:
		LIBS += -L../gmp-ecm/.libs

		//locate around line 95 and find:
		LIBS += -L../msieve/lib/linux/x86_64
		//then change it to:
		LIBS += -L../msieve

**3. Compile and install yafu**

	64bits：make x86_64 NFS=1
	32bits：make x86 NFS=1
	
	//add environment variable
	echo "export PATH=/root/sherlly/yafu:\$PATH">>/etc/profile
	source /etc/profile

	//run
	./yafu

![](https://i.imgur.com/2Gjdd5M.png)
## Some Problem

> error: gnu/stubs-32.h: No such file or directory

	yum install -y glibc-devel.i686 libstdc++-devel.i686

> make: svnversion: Command not found

	yum install -y svn
	make all

> error: mpz_aprcl.h: No such file or directory
	
	vim top/calc.c
	//#include "mpz_aprcl.h"
	#include "./aprcl/mpz_aprcl.h"

	vim factor/factor_common.c
	//#include "mpz_aprcl.h"
	#include "../top/aprcl/mpz_aprcl.h"

	vim arith/arith3.c
	//#include "mpz_aprcl.h"
	#include "../top/aprcl/mpz_aprcl.h"

>  error while loading shared libraries: libgmp.so.10: cannot open shared object file: No such file or directory

	find / -name libgmp.so.*
	ln -s /usr/lib64/libgmp.so.3 /usr/lib64/libgmp.so.10

