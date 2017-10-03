# Linux环境下安装yafu

**NOTE1：** 我的linux环境: CentOS 6.7

**NOTE2：** 注意安装yafu、msieve、gmp、gmp-ecm在同一目录下

**NOTE3：** 我的安装位置：/root/sherlly

## STEP 1: 安装依赖环境（zlib/GMP/GMP-ECM/msieve）
### zlib
	rpm -qa|grep zlib
	yum install -y zlib-devel-1.2.3-29.el6.x86_64 zlib-1.2.3-29.el6.x86_64
	
### GMP
	rpm -qa|grep gmp

1. 如果版本>6.0：
	
		yum install -y gmp gmp-devel

2. 如果版本<6.0或者没有找到：

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
	//如果提示error: GMP 5.0.0 or newer is required则ecm选择低一点的版本或者升级gmp
	make
	make install

### msieve
	wget http://downloads.sourceforge.net/project/msieve/msieve/Msieve%20v1.52/msieve152.tar.gz
	tar zxvf msieve152.tar.gz
	mv msieve-1.52 msieve
	cd msieve
	make all


## STEP 2: 安装Yafu
1. 下载源代码

		git clone https://github.com/DarkenCode/yafu.git
		cd yafu
2. 修改MakeFile文件

		vim MakeFile
		在122行左右位置添加如下语句：
		LIBS+= -lc -lz
	
		在大概68行位置找到
		LIBS += -L../gmp/lib/linux/x86_64
		改为
		LIBS += -L../gmp/.libs
	
		在大概71行位置找到
		LIBS += -L../gmp-ecm/lib/linux/x86_64
		改为
		LIBS += -L../gmp-ecm/.libs

		在大概95行位置找到
		LIBS += -L../msieve/lib/linux/x86_64
		改为
		LIBS += -L../msieve
3. 编译安装

		64位：make x86_64 NFS=1
		32位：make x86 NFS=1
	
		//添加环境变量(此处yafu安装位置为/root/sherlly/yafu，根据实际安装位置修改)
		echo "export PATH=/root/sherlly/yafu:\$PATH">>/etc/profile
		source /etc/profile

		//运行程序
		yafu

	![](https://i.imgur.com/2Gjdd5M.png)
## 可能遇到的一些问题

> error: gnu/stubs-32.h: No such file or directory

	yum install -y glibc-devel.i686 libstdc++-devel.i686

> make: svnversion: Command not found

	yum install -y svn
	make all

> error: mpz_aprcl.h: No such file or directory
	
	vim top/calc.c
	#include "mpz_aprcl.h"
	改为
	#include "./aprcl/mpz_aprcl.h"

	vim factor/factor_common.c
	#include "mpz_aprcl.h"
	改为
	#include "../top/aprcl/mpz_aprcl.h"
	vim arith/arith3.c
	#include "mpz_aprcl.h"
	改为
	#include "../top/aprcl/mpz_aprcl.h"

>  error while loading shared libraries: libgmp.so.10: cannot open shared object file: No such file or directory

	find / -name libgmp.so.*
	ln -s /usr/lib64/libgmp.so.3 /usr/lib64/libgmp.so.10

