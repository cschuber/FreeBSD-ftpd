#	@(#)Makefile	8.2 (Berkeley) 4/4/94
# $FreeBSD$

PROG=	ftpd
MAN8=	ftpd.8
SRCS=	ftpd.c ftpcmd.y logwtmp.c popen.c skey-stuff.c

CFLAGS+=-DSETPROCTITLE -DSKEY -DLOGIN_CAP -DVIRTUAL_HOSTING -Wall \
	-I${.CURDIR}/../../contrib-crypto/telnet
YFLAGS=

LDADD=	-lskey -lmd -lcrypt -lutil
DPADD=	${LIBSKEY} ${LIBMD} ${LIBCRYPT} ${LIBUTIL}

LSDIR=	../../bin/ls
.PATH:	${.CURDIR}/${LSDIR}
SRCS+=	ls.c cmp.c print.c stat_flags.c util.c
CFLAGS+=-DINTERNAL_LS -Dmain=ls_main -I${.CURDIR}/${LSDIR}

.if exists(${DESTDIR}/usr/lib/libkrb.a) && defined(MAKE_KERBEROS4)
.PATH:  ${.CURDIR}/../../lib/libpam/modules/pam_kerberosIV
SRCS+=	klogin.c
LDADD+=	-lkrb -ldes -lcom_err
DPADD+= ${LIBKRB} ${LIBDES} ${LIBCOM_ERR}
CFLAGS+=-DKERBEROS
DISTRIBUTION=	krb
.endif

.include <bsd.prog.mk>
