
dup2test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char* argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int fd;

  // Ejemplo de dup2 con un fd incorrecto
  if (dup2 (-1,8) >= 0)
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 08                	push   $0x8
  18:	6a ff                	push   $0xffffffff
  1a:	e8 ea 03 00 00       	call   409 <dup2>
  1f:	83 c4 10             	add    $0x10,%esp
  22:	85 c0                	test   %eax,%eax
  24:	0f 89 ed 01 00 00    	jns    217 <main+0x217>
    printf (2, "dup2 no funciona con fd incorrecto.\n");

  // Ejemplo de dup2 con un newfd incorrecto
  if (dup2 (1,-1) >= 0)
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	6a ff                	push   $0xffffffff
  2f:	6a 01                	push   $0x1
  31:	e8 d3 03 00 00       	call   409 <dup2>
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	0f 89 ed 01 00 00    	jns    22e <main+0x22e>
    printf (2, "dup2 no funciona con fd incorrecto (2).\n");

  // Ejemplo de dup2 con un fd no mapeado
  if (dup2 (6,8) >= 0)
  41:	83 ec 08             	sub    $0x8,%esp
  44:	6a 08                	push   $0x8
  46:	6a 06                	push   $0x6
  48:	e8 bc 03 00 00       	call   409 <dup2>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	85 c0                	test   %eax,%eax
  52:	0f 89 ed 01 00 00    	jns    245 <main+0x245>
    printf (2, "dup2 no funciona con fd no mapeado.\n");

  // Ejemplo de dup2 con un fd no mapeado (2)
  if (dup2 (8,1) >= 0)
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	6a 01                	push   $0x1
  5d:	6a 08                	push   $0x8
  5f:	e8 a5 03 00 00       	call   409 <dup2>
  64:	83 c4 10             	add    $0x10,%esp
  67:	85 c0                	test   %eax,%eax
  69:	0f 89 ed 01 00 00    	jns    25c <main+0x25c>
    printf (2, "dup2 no funciona con fd no mapeado (2).\n");

  if (dup2 (1,25) >= 0)
  6f:	83 ec 08             	sub    $0x8,%esp
  72:	6a 19                	push   $0x19
  74:	6a 01                	push   $0x1
  76:	e8 8e 03 00 00       	call   409 <dup2>
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	85 c0                	test   %eax,%eax
  80:	0f 89 ed 01 00 00    	jns    273 <main+0x273>
    printf (2, "dup2 no funciona con fd superior a NOFILE.\n");

  // Ejemplo de dup2 con fd existente
  if (dup2 (1,4) != 4)
  86:	83 ec 08             	sub    $0x8,%esp
  89:	6a 04                	push   $0x4
  8b:	6a 01                	push   $0x1
  8d:	e8 77 03 00 00       	call   409 <dup2>
  92:	83 c4 10             	add    $0x10,%esp
  95:	83 f8 04             	cmp    $0x4,%eax
  98:	0f 85 ec 01 00 00    	jne    28a <main+0x28a>
    printf (2, "dup2 no funciona con fd existente.\n");

  printf (4, "Este mensaje debe salir por terminal.\n");
  9e:	83 ec 08             	sub    $0x8,%esp
  a1:	68 f4 06 00 00       	push   $0x6f4
  a6:	6a 04                	push   $0x4
  a8:	e8 f3 03 00 00       	call   4a0 <printf>

  if (dup2 (4,6) != 6)
  ad:	83 c4 08             	add    $0x8,%esp
  b0:	6a 06                	push   $0x6
  b2:	6a 04                	push   $0x4
  b4:	e8 50 03 00 00       	call   409 <dup2>
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	83 f8 06             	cmp    $0x6,%eax
  bf:	0f 85 dc 01 00 00    	jne    2a1 <main+0x2a1>
    printf (2, "dup2 no funciona con fd existente (2).\n");

  printf (6, "Este mensaje debe salir por terminal (2).\n");
  c5:	83 ec 08             	sub    $0x8,%esp
  c8:	68 44 07 00 00       	push   $0x744
  cd:	6a 06                	push   $0x6
  cf:	e8 cc 03 00 00       	call   4a0 <printf>

  if (close (4) != 0)
  d4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  db:	e8 a9 02 00 00       	call   389 <close>
  e0:	83 c4 10             	add    $0x10,%esp
  e3:	85 c0                	test   %eax,%eax
  e5:	0f 85 cd 01 00 00    	jne    2b8 <main+0x2b8>
    printf (2, "Error en close (4)\n");
  printf (6, "Este mensaje debe salir por terminal (3).\n");
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	68 70 07 00 00       	push   $0x770
  f3:	6a 06                	push   $0x6
  f5:	e8 a6 03 00 00       	call   4a0 <printf>
  if (close (6) != 0)
  fa:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
 101:	e8 83 02 00 00       	call   389 <close>
 106:	83 c4 10             	add    $0x10,%esp
 109:	85 c0                	test   %eax,%eax
 10b:	0f 85 be 01 00 00    	jne    2cf <main+0x2cf>
    printf (2, "Error en close (6)\n");
  if (close (6) == 0)
 111:	83 ec 0c             	sub    $0xc,%esp
 114:	6a 06                	push   $0x6
 116:	e8 6e 02 00 00       	call   389 <close>
 11b:	83 c4 10             	add    $0x10,%esp
 11e:	85 c0                	test   %eax,%eax
 120:	0f 84 c0 01 00 00    	je     2e6 <main+0x2e6>
    printf (2, "Error en close (6) (2)\n");

  fd = open ("fichero_salida.txt", O_CREATE|O_RDWR);
 126:	83 ec 08             	sub    $0x8,%esp
 129:	68 02 02 00 00       	push   $0x202
 12e:	68 50 08 00 00       	push   $0x850
 133:	e8 69 02 00 00       	call   3a1 <open>
 138:	89 c3                	mov    %eax,%ebx
  printf (fd, "Salida a fichero\n");
 13a:	83 c4 08             	add    $0x8,%esp
 13d:	68 63 08 00 00       	push   $0x863
 142:	50                   	push   %eax
 143:	e8 58 03 00 00       	call   4a0 <printf>

  if (dup2 (fd, 9) != 9)
 148:	83 c4 08             	add    $0x8,%esp
 14b:	6a 09                	push   $0x9
 14d:	53                   	push   %ebx
 14e:	e8 b6 02 00 00       	call   409 <dup2>
 153:	83 c4 10             	add    $0x10,%esp
 156:	83 f8 09             	cmp    $0x9,%eax
 159:	0f 85 9e 01 00 00    	jne    2fd <main+0x2fd>
    printf (2, "dup2 no funciona con fd existente (3).\n");

  printf (9, "Salida también a fichero.\n");
 15f:	83 ec 08             	sub    $0x8,%esp
 162:	68 75 08 00 00       	push   $0x875
 167:	6a 09                	push   $0x9
 169:	e8 32 03 00 00       	call   4a0 <printf>

  if (dup2 (9, 9) != 9)
 16e:	83 c4 08             	add    $0x8,%esp
 171:	6a 09                	push   $0x9
 173:	6a 09                	push   $0x9
 175:	e8 8f 02 00 00       	call   409 <dup2>
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	83 f8 09             	cmp    $0x9,%eax
 180:	0f 85 8e 01 00 00    	jne    314 <main+0x314>
    printf (2, "dup2 no funciona con newfd=oldfd.\n");

  printf (9, "Salida también a fichero.\n");
 186:	83 ec 08             	sub    $0x8,%esp
 189:	68 75 08 00 00       	push   $0x875
 18e:	6a 09                	push   $0x9
 190:	e8 0b 03 00 00       	call   4a0 <printf>

  close (9);
 195:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
 19c:	e8 e8 01 00 00       	call   389 <close>

  dup2 (1, 6);
 1a1:	83 c4 08             	add    $0x8,%esp
 1a4:	6a 06                	push   $0x6
 1a6:	6a 01                	push   $0x1
 1a8:	e8 5c 02 00 00       	call   409 <dup2>

  if (dup2 (fd, 1) != 1)
 1ad:	83 c4 08             	add    $0x8,%esp
 1b0:	6a 01                	push   $0x1
 1b2:	53                   	push   %ebx
 1b3:	e8 51 02 00 00       	call   409 <dup2>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	83 f8 01             	cmp    $0x1,%eax
 1be:	0f 85 67 01 00 00    	jne    32b <main+0x32b>
    printf (2, "dup2 no funciona con fd existente (4).\n");

  printf (1, "Cuarta salida a fichero.\n");
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	68 91 08 00 00       	push   $0x891
 1cc:	6a 01                	push   $0x1
 1ce:	e8 cd 02 00 00       	call   4a0 <printf>
  if (close (1) != 0)
 1d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1da:	e8 aa 01 00 00       	call   389 <close>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	0f 85 58 01 00 00    	jne    342 <main+0x342>
    printf (2, "Error en close (1).\n");

  dup2 (6,fd);
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	53                   	push   %ebx
 1ee:	6a 06                	push   $0x6
 1f0:	e8 14 02 00 00       	call   409 <dup2>

  printf (fd, "Este mensaje debe salir por terminal.\n");
 1f5:	83 c4 08             	add    $0x8,%esp
 1f8:	68 f4 06 00 00       	push   $0x6f4
 1fd:	53                   	push   %ebx
 1fe:	e8 9d 02 00 00       	call   4a0 <printf>
  close (fd);
 203:	89 1c 24             	mov    %ebx,(%esp)
 206:	e8 7e 01 00 00       	call   389 <close>

  exit(0);
 20b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 212:	e8 4a 01 00 00       	call   361 <exit>
    printf (2, "dup2 no funciona con fd incorrecto.\n");
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	68 fc 05 00 00       	push   $0x5fc
 21f:	6a 02                	push   $0x2
 221:	e8 7a 02 00 00       	call   4a0 <printf>
 226:	83 c4 10             	add    $0x10,%esp
 229:	e9 fc fd ff ff       	jmp    2a <main+0x2a>
    printf (2, "dup2 no funciona con fd incorrecto (2).\n");
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	68 24 06 00 00       	push   $0x624
 236:	6a 02                	push   $0x2
 238:	e8 63 02 00 00       	call   4a0 <printf>
 23d:	83 c4 10             	add    $0x10,%esp
 240:	e9 fc fd ff ff       	jmp    41 <main+0x41>
    printf (2, "dup2 no funciona con fd no mapeado.\n");
 245:	83 ec 08             	sub    $0x8,%esp
 248:	68 50 06 00 00       	push   $0x650
 24d:	6a 02                	push   $0x2
 24f:	e8 4c 02 00 00       	call   4a0 <printf>
 254:	83 c4 10             	add    $0x10,%esp
 257:	e9 fc fd ff ff       	jmp    58 <main+0x58>
    printf (2, "dup2 no funciona con fd no mapeado (2).\n");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 78 06 00 00       	push   $0x678
 264:	6a 02                	push   $0x2
 266:	e8 35 02 00 00       	call   4a0 <printf>
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	e9 fc fd ff ff       	jmp    6f <main+0x6f>
    printf (2, "dup2 no funciona con fd superior a NOFILE.\n");
 273:	83 ec 08             	sub    $0x8,%esp
 276:	68 a4 06 00 00       	push   $0x6a4
 27b:	6a 02                	push   $0x2
 27d:	e8 1e 02 00 00       	call   4a0 <printf>
 282:	83 c4 10             	add    $0x10,%esp
 285:	e9 fc fd ff ff       	jmp    86 <main+0x86>
    printf (2, "dup2 no funciona con fd existente.\n");
 28a:	83 ec 08             	sub    $0x8,%esp
 28d:	68 d0 06 00 00       	push   $0x6d0
 292:	6a 02                	push   $0x2
 294:	e8 07 02 00 00       	call   4a0 <printf>
 299:	83 c4 10             	add    $0x10,%esp
 29c:	e9 fd fd ff ff       	jmp    9e <main+0x9e>
    printf (2, "dup2 no funciona con fd existente (2).\n");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 1c 07 00 00       	push   $0x71c
 2a9:	6a 02                	push   $0x2
 2ab:	e8 f0 01 00 00       	call   4a0 <printf>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	e9 0d fe ff ff       	jmp    c5 <main+0xc5>
    printf (2, "Error en close (4)\n");
 2b8:	83 ec 08             	sub    $0x8,%esp
 2bb:	68 10 08 00 00       	push   $0x810
 2c0:	6a 02                	push   $0x2
 2c2:	e8 d9 01 00 00       	call   4a0 <printf>
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	e9 1c fe ff ff       	jmp    eb <main+0xeb>
    printf (2, "Error en close (6)\n");
 2cf:	83 ec 08             	sub    $0x8,%esp
 2d2:	68 24 08 00 00       	push   $0x824
 2d7:	6a 02                	push   $0x2
 2d9:	e8 c2 01 00 00       	call   4a0 <printf>
 2de:	83 c4 10             	add    $0x10,%esp
 2e1:	e9 2b fe ff ff       	jmp    111 <main+0x111>
    printf (2, "Error en close (6) (2)\n");
 2e6:	83 ec 08             	sub    $0x8,%esp
 2e9:	68 38 08 00 00       	push   $0x838
 2ee:	6a 02                	push   $0x2
 2f0:	e8 ab 01 00 00       	call   4a0 <printf>
 2f5:	83 c4 10             	add    $0x10,%esp
 2f8:	e9 29 fe ff ff       	jmp    126 <main+0x126>
    printf (2, "dup2 no funciona con fd existente (3).\n");
 2fd:	83 ec 08             	sub    $0x8,%esp
 300:	68 9c 07 00 00       	push   $0x79c
 305:	6a 02                	push   $0x2
 307:	e8 94 01 00 00       	call   4a0 <printf>
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	e9 4b fe ff ff       	jmp    15f <main+0x15f>
    printf (2, "dup2 no funciona con newfd=oldfd.\n");
 314:	83 ec 08             	sub    $0x8,%esp
 317:	68 c4 07 00 00       	push   $0x7c4
 31c:	6a 02                	push   $0x2
 31e:	e8 7d 01 00 00       	call   4a0 <printf>
 323:	83 c4 10             	add    $0x10,%esp
 326:	e9 5b fe ff ff       	jmp    186 <main+0x186>
    printf (2, "dup2 no funciona con fd existente (4).\n");
 32b:	83 ec 08             	sub    $0x8,%esp
 32e:	68 e8 07 00 00       	push   $0x7e8
 333:	6a 02                	push   $0x2
 335:	e8 66 01 00 00       	call   4a0 <printf>
 33a:	83 c4 10             	add    $0x10,%esp
 33d:	e9 82 fe ff ff       	jmp    1c4 <main+0x1c4>
    printf (2, "Error en close (1).\n");
 342:	83 ec 08             	sub    $0x8,%esp
 345:	68 ab 08 00 00       	push   $0x8ab
 34a:	6a 02                	push   $0x2
 34c:	e8 4f 01 00 00       	call   4a0 <printf>
 351:	83 c4 10             	add    $0x10,%esp
 354:	e9 91 fe ff ff       	jmp    1ea <main+0x1ea>

00000359 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 359:	b8 01 00 00 00       	mov    $0x1,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <exit>:
SYSCALL(exit)
 361:	b8 02 00 00 00       	mov    $0x2,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <wait>:
SYSCALL(wait)
 369:	b8 03 00 00 00       	mov    $0x3,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <pipe>:
SYSCALL(pipe)
 371:	b8 04 00 00 00       	mov    $0x4,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <read>:
SYSCALL(read)
 379:	b8 05 00 00 00       	mov    $0x5,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <write>:
SYSCALL(write)
 381:	b8 10 00 00 00       	mov    $0x10,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <close>:
SYSCALL(close)
 389:	b8 15 00 00 00       	mov    $0x15,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <kill>:
SYSCALL(kill)
 391:	b8 06 00 00 00       	mov    $0x6,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <exec>:
SYSCALL(exec)
 399:	b8 07 00 00 00       	mov    $0x7,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <open>:
SYSCALL(open)
 3a1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <mknod>:
SYSCALL(mknod)
 3a9:	b8 11 00 00 00       	mov    $0x11,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <unlink>:
SYSCALL(unlink)
 3b1:	b8 12 00 00 00       	mov    $0x12,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <fstat>:
SYSCALL(fstat)
 3b9:	b8 08 00 00 00       	mov    $0x8,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <link>:
SYSCALL(link)
 3c1:	b8 13 00 00 00       	mov    $0x13,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <mkdir>:
SYSCALL(mkdir)
 3c9:	b8 14 00 00 00       	mov    $0x14,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <chdir>:
SYSCALL(chdir)
 3d1:	b8 09 00 00 00       	mov    $0x9,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <dup>:
SYSCALL(dup)
 3d9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <getpid>:
SYSCALL(getpid)
 3e1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <sbrk>:
SYSCALL(sbrk)
 3e9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <sleep>:
SYSCALL(sleep)
 3f1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <uptime>:
SYSCALL(uptime)
 3f9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <date>:
SYSCALL(date)
 401:	b8 16 00 00 00       	mov    $0x16,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <dup2>:
 409:	b8 17 00 00 00       	mov    $0x17,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 411:	55                   	push   %ebp
 412:	89 e5                	mov    %esp,%ebp
 414:	83 ec 1c             	sub    $0x1c,%esp
 417:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 41a:	6a 01                	push   $0x1
 41c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 41f:	52                   	push   %edx
 420:	50                   	push   %eax
 421:	e8 5b ff ff ff       	call   381 <write>
}
 426:	83 c4 10             	add    $0x10,%esp
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
 42e:	57                   	push   %edi
 42f:	56                   	push   %esi
 430:	53                   	push   %ebx
 431:	83 ec 2c             	sub    $0x2c,%esp
 434:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 437:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 439:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 43d:	74 04                	je     443 <printint+0x18>
 43f:	85 d2                	test   %edx,%edx
 441:	78 3a                	js     47d <printint+0x52>
  neg = 0;
 443:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 44a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 44f:	89 f0                	mov    %esi,%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f1                	div    %ecx
 458:	89 df                	mov    %ebx,%edi
 45a:	43                   	inc    %ebx
 45b:	8a 92 c8 08 00 00    	mov    0x8c8(%edx),%dl
 461:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 465:	89 f2                	mov    %esi,%edx
 467:	89 c6                	mov    %eax,%esi
 469:	39 d1                	cmp    %edx,%ecx
 46b:	76 e2                	jbe    44f <printint+0x24>
  if(neg)
 46d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 471:	74 22                	je     495 <printint+0x6a>
    buf[i++] = '-';
 473:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 478:	8d 5f 02             	lea    0x2(%edi),%ebx
 47b:	eb 18                	jmp    495 <printint+0x6a>
    x = -xx;
 47d:	f7 de                	neg    %esi
    neg = 1;
 47f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 486:	eb c2                	jmp    44a <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 488:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 48d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 490:	e8 7c ff ff ff       	call   411 <putc>
  while(--i >= 0)
 495:	4b                   	dec    %ebx
 496:	79 f0                	jns    488 <printint+0x5d>
}
 498:	83 c4 2c             	add    $0x2c,%esp
 49b:	5b                   	pop    %ebx
 49c:	5e                   	pop    %esi
 49d:	5f                   	pop    %edi
 49e:	5d                   	pop    %ebp
 49f:	c3                   	ret    

000004a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4a0:	f3 0f 1e fb          	endbr32 
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	57                   	push   %edi
 4a8:	56                   	push   %esi
 4a9:	53                   	push   %ebx
 4aa:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ad:	8d 45 10             	lea    0x10(%ebp),%eax
 4b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4b3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4b8:	bb 00 00 00 00       	mov    $0x0,%ebx
 4bd:	eb 12                	jmp    4d1 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4bf:	89 fa                	mov    %edi,%edx
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	e8 48 ff ff ff       	call   411 <putc>
 4c9:	eb 05                	jmp    4d0 <printf+0x30>
      }
    } else if(state == '%'){
 4cb:	83 fe 25             	cmp    $0x25,%esi
 4ce:	74 22                	je     4f2 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 4d0:	43                   	inc    %ebx
 4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d4:	8a 04 18             	mov    (%eax,%ebx,1),%al
 4d7:	84 c0                	test   %al,%al
 4d9:	0f 84 13 01 00 00    	je     5f2 <printf+0x152>
    c = fmt[i] & 0xff;
 4df:	0f be f8             	movsbl %al,%edi
 4e2:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4e5:	85 f6                	test   %esi,%esi
 4e7:	75 e2                	jne    4cb <printf+0x2b>
      if(c == '%'){
 4e9:	83 f8 25             	cmp    $0x25,%eax
 4ec:	75 d1                	jne    4bf <printf+0x1f>
        state = '%';
 4ee:	89 c6                	mov    %eax,%esi
 4f0:	eb de                	jmp    4d0 <printf+0x30>
      if(c == 'd'){
 4f2:	83 f8 64             	cmp    $0x64,%eax
 4f5:	74 43                	je     53a <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4f7:	83 f8 78             	cmp    $0x78,%eax
 4fa:	74 68                	je     564 <printf+0xc4>
 4fc:	83 f8 70             	cmp    $0x70,%eax
 4ff:	74 63                	je     564 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 501:	83 f8 73             	cmp    $0x73,%eax
 504:	0f 84 84 00 00 00    	je     58e <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50a:	83 f8 63             	cmp    $0x63,%eax
 50d:	0f 84 ad 00 00 00    	je     5c0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 513:	83 f8 25             	cmp    $0x25,%eax
 516:	0f 84 c2 00 00 00    	je     5de <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 51c:	ba 25 00 00 00       	mov    $0x25,%edx
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	e8 e8 fe ff ff       	call   411 <putc>
        putc(fd, c);
 529:	89 fa                	mov    %edi,%edx
 52b:	8b 45 08             	mov    0x8(%ebp),%eax
 52e:	e8 de fe ff ff       	call   411 <putc>
      }
      state = 0;
 533:	be 00 00 00 00       	mov    $0x0,%esi
 538:	eb 96                	jmp    4d0 <printf+0x30>
        printint(fd, *ap, 10, 1);
 53a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 53d:	8b 17                	mov    (%edi),%edx
 53f:	83 ec 0c             	sub    $0xc,%esp
 542:	6a 01                	push   $0x1
 544:	b9 0a 00 00 00       	mov    $0xa,%ecx
 549:	8b 45 08             	mov    0x8(%ebp),%eax
 54c:	e8 da fe ff ff       	call   42b <printint>
        ap++;
 551:	83 c7 04             	add    $0x4,%edi
 554:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 557:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55a:	be 00 00 00 00       	mov    $0x0,%esi
 55f:	e9 6c ff ff ff       	jmp    4d0 <printf+0x30>
        printint(fd, *ap, 16, 0);
 564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 567:	8b 17                	mov    (%edi),%edx
 569:	83 ec 0c             	sub    $0xc,%esp
 56c:	6a 00                	push   $0x0
 56e:	b9 10 00 00 00       	mov    $0x10,%ecx
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	e8 b0 fe ff ff       	call   42b <printint>
        ap++;
 57b:	83 c7 04             	add    $0x4,%edi
 57e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 581:	83 c4 10             	add    $0x10,%esp
      state = 0;
 584:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 589:	e9 42 ff ff ff       	jmp    4d0 <printf+0x30>
        s = (char*)*ap;
 58e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 591:	8b 30                	mov    (%eax),%esi
        ap++;
 593:	83 c0 04             	add    $0x4,%eax
 596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 599:	85 f6                	test   %esi,%esi
 59b:	75 13                	jne    5b0 <printf+0x110>
          s = "(null)";
 59d:	be c0 08 00 00       	mov    $0x8c0,%esi
 5a2:	eb 0c                	jmp    5b0 <printf+0x110>
          putc(fd, *s);
 5a4:	0f be d2             	movsbl %dl,%edx
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	e8 62 fe ff ff       	call   411 <putc>
          s++;
 5af:	46                   	inc    %esi
        while(*s != 0){
 5b0:	8a 16                	mov    (%esi),%dl
 5b2:	84 d2                	test   %dl,%dl
 5b4:	75 ee                	jne    5a4 <printf+0x104>
      state = 0;
 5b6:	be 00 00 00 00       	mov    $0x0,%esi
 5bb:	e9 10 ff ff ff       	jmp    4d0 <printf+0x30>
        putc(fd, *ap);
 5c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5c3:	0f be 17             	movsbl (%edi),%edx
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	e8 43 fe ff ff       	call   411 <putc>
        ap++;
 5ce:	83 c7 04             	add    $0x4,%edi
 5d1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5d4:	be 00 00 00 00       	mov    $0x0,%esi
 5d9:	e9 f2 fe ff ff       	jmp    4d0 <printf+0x30>
        putc(fd, c);
 5de:	89 fa                	mov    %edi,%edx
 5e0:	8b 45 08             	mov    0x8(%ebp),%eax
 5e3:	e8 29 fe ff ff       	call   411 <putc>
      state = 0;
 5e8:	be 00 00 00 00       	mov    $0x0,%esi
 5ed:	e9 de fe ff ff       	jmp    4d0 <printf+0x30>
    }
  }
}
 5f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f5:	5b                   	pop    %ebx
 5f6:	5e                   	pop    %esi
 5f7:	5f                   	pop    %edi
 5f8:	5d                   	pop    %ebp
 5f9:	c3                   	ret    
