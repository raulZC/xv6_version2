
tsbrk4:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 18             	sub    $0x18,%esp
  char* a = sbrk (15000);
  17:	68 98 3a 00 00       	push   $0x3a98
  1c:	e8 b9 01 00 00       	call   1da <sbrk>
  21:	89 c3                	mov    %eax,%ebx

  fork();
  23:	e8 22 01 00 00       	call   14a <fork>

  a[500] = 1;
  28:	c6 83 f4 01 00 00 01 	movb   $0x1,0x1f4(%ebx)

  if ((uint)a + 15000 != (uint) sbrk (-15000))
  2f:	8d b3 98 3a 00 00    	lea    0x3a98(%ebx),%esi
  35:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  3c:	e8 99 01 00 00       	call   1da <sbrk>
  41:	83 c4 10             	add    $0x10,%esp
  44:	39 c6                	cmp    %eax,%esi
  46:	74 1b                	je     63 <main+0x63>
  {
    printf (1, "sbrk() con número positivo falló.\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 ec 03 00 00       	push   $0x3ec
  50:	6a 01                	push   $0x1
  52:	e8 3a 02 00 00       	call   291 <printf>
    exit(1);
  57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5e:	e8 ef 00 00 00       	call   152 <exit>
  }

  if (a != sbrk (0))
  63:	83 ec 0c             	sub    $0xc,%esp
  66:	6a 00                	push   $0x0
  68:	e8 6d 01 00 00       	call   1da <sbrk>
  6d:	83 c4 10             	add    $0x10,%esp
  70:	39 c3                	cmp    %eax,%ebx
  72:	74 1b                	je     8f <main+0x8f>
  {
    printf (1, "sbrk() con cero falló.\n");
  74:	83 ec 08             	sub    $0x8,%esp
  77:	68 11 04 00 00       	push   $0x411
  7c:	6a 01                	push   $0x1
  7e:	e8 0e 02 00 00       	call   291 <printf>
    exit(2);
  83:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8a:	e8 c3 00 00 00       	call   152 <exit>
  }

  if (a != sbrk (15000))
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	68 98 3a 00 00       	push   $0x3a98
  97:	e8 3e 01 00 00       	call   1da <sbrk>
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	39 c3                	cmp    %eax,%ebx
  a1:	74 1b                	je     be <main+0xbe>
  {
    printf (1, "sbrk() negativo falló.\n");
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	68 2a 04 00 00       	push   $0x42a
  ab:	6a 01                	push   $0x1
  ad:	e8 df 01 00 00       	call   291 <printf>
    exit(3);
  b2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  b9:	e8 94 00 00 00       	call   152 <exit>
  }

  printf (1, "Debe imprimir 1: %d.\n", ++a[500]);
  be:	8a 83 f4 01 00 00    	mov    0x1f4(%ebx),%al
  c4:	40                   	inc    %eax
  c5:	88 83 f4 01 00 00    	mov    %al,0x1f4(%ebx)
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	0f be c0             	movsbl %al,%eax
  d1:	50                   	push   %eax
  d2:	68 43 04 00 00       	push   $0x443
  d7:	6a 01                	push   $0x1
  d9:	e8 b3 01 00 00       	call   291 <printf>

  a=sbrk (-15000);
  de:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  e5:	e8 f0 00 00 00       	call   1da <sbrk>

  a=sbrk(1024*4096*2);
  ea:	c7 04 24 00 00 80 00 	movl   $0x800000,(%esp)
  f1:	e8 e4 00 00 00       	call   1da <sbrk>
  f6:	89 c3                	mov    %eax,%ebx

  fork();
  f8:	e8 4d 00 00 00       	call   14a <fork>

  a[600*4096*2] = 1;
  fd:	c6 83 00 00 4b 00 01 	movb   $0x1,0x4b0000(%ebx)

  sbrk(-1024*4096*2);
 104:	c7 04 24 00 00 80 ff 	movl   $0xff800000,(%esp)
 10b:	e8 ca 00 00 00       	call   1da <sbrk>

  a=sbrk(1024*4096*2);
 110:	c7 04 24 00 00 80 00 	movl   $0x800000,(%esp)
 117:	e8 be 00 00 00       	call   1da <sbrk>

  printf (1, "Debe imprimir 1: %d.\n", ++a[600*4096*2]);
 11c:	8a 88 00 00 4b 00    	mov    0x4b0000(%eax),%cl
 122:	8d 51 01             	lea    0x1(%ecx),%edx
 125:	88 90 00 00 4b 00    	mov    %dl,0x4b0000(%eax)
 12b:	83 c4 0c             	add    $0xc,%esp
 12e:	0f be d2             	movsbl %dl,%edx
 131:	52                   	push   %edx
 132:	68 43 04 00 00       	push   $0x443
 137:	6a 01                	push   $0x1
 139:	e8 53 01 00 00       	call   291 <printf>

  exit(0);
 13e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 145:	e8 08 00 00 00       	call   152 <exit>

0000014a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 14a:	b8 01 00 00 00       	mov    $0x1,%eax
 14f:	cd 40                	int    $0x40
 151:	c3                   	ret    

00000152 <exit>:
SYSCALL(exit)
 152:	b8 02 00 00 00       	mov    $0x2,%eax
 157:	cd 40                	int    $0x40
 159:	c3                   	ret    

0000015a <wait>:
SYSCALL(wait)
 15a:	b8 03 00 00 00       	mov    $0x3,%eax
 15f:	cd 40                	int    $0x40
 161:	c3                   	ret    

00000162 <pipe>:
SYSCALL(pipe)
 162:	b8 04 00 00 00       	mov    $0x4,%eax
 167:	cd 40                	int    $0x40
 169:	c3                   	ret    

0000016a <read>:
SYSCALL(read)
 16a:	b8 05 00 00 00       	mov    $0x5,%eax
 16f:	cd 40                	int    $0x40
 171:	c3                   	ret    

00000172 <write>:
SYSCALL(write)
 172:	b8 10 00 00 00       	mov    $0x10,%eax
 177:	cd 40                	int    $0x40
 179:	c3                   	ret    

0000017a <close>:
SYSCALL(close)
 17a:	b8 15 00 00 00       	mov    $0x15,%eax
 17f:	cd 40                	int    $0x40
 181:	c3                   	ret    

00000182 <kill>:
SYSCALL(kill)
 182:	b8 06 00 00 00       	mov    $0x6,%eax
 187:	cd 40                	int    $0x40
 189:	c3                   	ret    

0000018a <exec>:
SYSCALL(exec)
 18a:	b8 07 00 00 00       	mov    $0x7,%eax
 18f:	cd 40                	int    $0x40
 191:	c3                   	ret    

00000192 <open>:
SYSCALL(open)
 192:	b8 0f 00 00 00       	mov    $0xf,%eax
 197:	cd 40                	int    $0x40
 199:	c3                   	ret    

0000019a <mknod>:
SYSCALL(mknod)
 19a:	b8 11 00 00 00       	mov    $0x11,%eax
 19f:	cd 40                	int    $0x40
 1a1:	c3                   	ret    

000001a2 <unlink>:
SYSCALL(unlink)
 1a2:	b8 12 00 00 00       	mov    $0x12,%eax
 1a7:	cd 40                	int    $0x40
 1a9:	c3                   	ret    

000001aa <fstat>:
SYSCALL(fstat)
 1aa:	b8 08 00 00 00       	mov    $0x8,%eax
 1af:	cd 40                	int    $0x40
 1b1:	c3                   	ret    

000001b2 <link>:
SYSCALL(link)
 1b2:	b8 13 00 00 00       	mov    $0x13,%eax
 1b7:	cd 40                	int    $0x40
 1b9:	c3                   	ret    

000001ba <mkdir>:
SYSCALL(mkdir)
 1ba:	b8 14 00 00 00       	mov    $0x14,%eax
 1bf:	cd 40                	int    $0x40
 1c1:	c3                   	ret    

000001c2 <chdir>:
SYSCALL(chdir)
 1c2:	b8 09 00 00 00       	mov    $0x9,%eax
 1c7:	cd 40                	int    $0x40
 1c9:	c3                   	ret    

000001ca <dup>:
SYSCALL(dup)
 1ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 1cf:	cd 40                	int    $0x40
 1d1:	c3                   	ret    

000001d2 <getpid>:
SYSCALL(getpid)
 1d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 1d7:	cd 40                	int    $0x40
 1d9:	c3                   	ret    

000001da <sbrk>:
SYSCALL(sbrk)
 1da:	b8 0c 00 00 00       	mov    $0xc,%eax
 1df:	cd 40                	int    $0x40
 1e1:	c3                   	ret    

000001e2 <sleep>:
SYSCALL(sleep)
 1e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <uptime>:
SYSCALL(uptime)
 1ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <date>:
SYSCALL(date)
 1f2:	b8 16 00 00 00       	mov    $0x16,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <dup2>:
 1fa:	b8 17 00 00 00       	mov    $0x17,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 1c             	sub    $0x1c,%esp
 208:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 20b:	6a 01                	push   $0x1
 20d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 210:	52                   	push   %edx
 211:	50                   	push   %eax
 212:	e8 5b ff ff ff       	call   172 <write>
}
 217:	83 c4 10             	add    $0x10,%esp
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	57                   	push   %edi
 220:	56                   	push   %esi
 221:	53                   	push   %ebx
 222:	83 ec 2c             	sub    $0x2c,%esp
 225:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 228:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 22a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 22e:	74 04                	je     234 <printint+0x18>
 230:	85 d2                	test   %edx,%edx
 232:	78 3a                	js     26e <printint+0x52>
  neg = 0;
 234:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 23b:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 240:	89 f0                	mov    %esi,%eax
 242:	ba 00 00 00 00       	mov    $0x0,%edx
 247:	f7 f1                	div    %ecx
 249:	89 df                	mov    %ebx,%edi
 24b:	43                   	inc    %ebx
 24c:	8a 92 60 04 00 00    	mov    0x460(%edx),%dl
 252:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 256:	89 f2                	mov    %esi,%edx
 258:	89 c6                	mov    %eax,%esi
 25a:	39 d1                	cmp    %edx,%ecx
 25c:	76 e2                	jbe    240 <printint+0x24>
  if(neg)
 25e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 262:	74 22                	je     286 <printint+0x6a>
    buf[i++] = '-';
 264:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 269:	8d 5f 02             	lea    0x2(%edi),%ebx
 26c:	eb 18                	jmp    286 <printint+0x6a>
    x = -xx;
 26e:	f7 de                	neg    %esi
    neg = 1;
 270:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 277:	eb c2                	jmp    23b <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 279:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 27e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 281:	e8 7c ff ff ff       	call   202 <putc>
  while(--i >= 0)
 286:	4b                   	dec    %ebx
 287:	79 f0                	jns    279 <printint+0x5d>
}
 289:	83 c4 2c             	add    $0x2c,%esp
 28c:	5b                   	pop    %ebx
 28d:	5e                   	pop    %esi
 28e:	5f                   	pop    %edi
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    

00000291 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 291:	f3 0f 1e fb          	endbr32 
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 29e:	8d 45 10             	lea    0x10(%ebp),%eax
 2a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 2a4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 2a9:	bb 00 00 00 00       	mov    $0x0,%ebx
 2ae:	eb 12                	jmp    2c2 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 2b0:	89 fa                	mov    %edi,%edx
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	e8 48 ff ff ff       	call   202 <putc>
 2ba:	eb 05                	jmp    2c1 <printf+0x30>
      }
    } else if(state == '%'){
 2bc:	83 fe 25             	cmp    $0x25,%esi
 2bf:	74 22                	je     2e3 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 2c1:	43                   	inc    %ebx
 2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c5:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2c8:	84 c0                	test   %al,%al
 2ca:	0f 84 13 01 00 00    	je     3e3 <printf+0x152>
    c = fmt[i] & 0xff;
 2d0:	0f be f8             	movsbl %al,%edi
 2d3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2d6:	85 f6                	test   %esi,%esi
 2d8:	75 e2                	jne    2bc <printf+0x2b>
      if(c == '%'){
 2da:	83 f8 25             	cmp    $0x25,%eax
 2dd:	75 d1                	jne    2b0 <printf+0x1f>
        state = '%';
 2df:	89 c6                	mov    %eax,%esi
 2e1:	eb de                	jmp    2c1 <printf+0x30>
      if(c == 'd'){
 2e3:	83 f8 64             	cmp    $0x64,%eax
 2e6:	74 43                	je     32b <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 2e8:	83 f8 78             	cmp    $0x78,%eax
 2eb:	74 68                	je     355 <printf+0xc4>
 2ed:	83 f8 70             	cmp    $0x70,%eax
 2f0:	74 63                	je     355 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 2f2:	83 f8 73             	cmp    $0x73,%eax
 2f5:	0f 84 84 00 00 00    	je     37f <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2fb:	83 f8 63             	cmp    $0x63,%eax
 2fe:	0f 84 ad 00 00 00    	je     3b1 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 304:	83 f8 25             	cmp    $0x25,%eax
 307:	0f 84 c2 00 00 00    	je     3cf <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 30d:	ba 25 00 00 00       	mov    $0x25,%edx
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	e8 e8 fe ff ff       	call   202 <putc>
        putc(fd, c);
 31a:	89 fa                	mov    %edi,%edx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	e8 de fe ff ff       	call   202 <putc>
      }
      state = 0;
 324:	be 00 00 00 00       	mov    $0x0,%esi
 329:	eb 96                	jmp    2c1 <printf+0x30>
        printint(fd, *ap, 10, 1);
 32b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 32e:	8b 17                	mov    (%edi),%edx
 330:	83 ec 0c             	sub    $0xc,%esp
 333:	6a 01                	push   $0x1
 335:	b9 0a 00 00 00       	mov    $0xa,%ecx
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	e8 da fe ff ff       	call   21c <printint>
        ap++;
 342:	83 c7 04             	add    $0x4,%edi
 345:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 348:	83 c4 10             	add    $0x10,%esp
      state = 0;
 34b:	be 00 00 00 00       	mov    $0x0,%esi
 350:	e9 6c ff ff ff       	jmp    2c1 <printf+0x30>
        printint(fd, *ap, 16, 0);
 355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 358:	8b 17                	mov    (%edi),%edx
 35a:	83 ec 0c             	sub    $0xc,%esp
 35d:	6a 00                	push   $0x0
 35f:	b9 10 00 00 00       	mov    $0x10,%ecx
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	e8 b0 fe ff ff       	call   21c <printint>
        ap++;
 36c:	83 c7 04             	add    $0x4,%edi
 36f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 372:	83 c4 10             	add    $0x10,%esp
      state = 0;
 375:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 37a:	e9 42 ff ff ff       	jmp    2c1 <printf+0x30>
        s = (char*)*ap;
 37f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 382:	8b 30                	mov    (%eax),%esi
        ap++;
 384:	83 c0 04             	add    $0x4,%eax
 387:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 38a:	85 f6                	test   %esi,%esi
 38c:	75 13                	jne    3a1 <printf+0x110>
          s = "(null)";
 38e:	be 59 04 00 00       	mov    $0x459,%esi
 393:	eb 0c                	jmp    3a1 <printf+0x110>
          putc(fd, *s);
 395:	0f be d2             	movsbl %dl,%edx
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	e8 62 fe ff ff       	call   202 <putc>
          s++;
 3a0:	46                   	inc    %esi
        while(*s != 0){
 3a1:	8a 16                	mov    (%esi),%dl
 3a3:	84 d2                	test   %dl,%dl
 3a5:	75 ee                	jne    395 <printf+0x104>
      state = 0;
 3a7:	be 00 00 00 00       	mov    $0x0,%esi
 3ac:	e9 10 ff ff ff       	jmp    2c1 <printf+0x30>
        putc(fd, *ap);
 3b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3b4:	0f be 17             	movsbl (%edi),%edx
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	e8 43 fe ff ff       	call   202 <putc>
        ap++;
 3bf:	83 c7 04             	add    $0x4,%edi
 3c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3c5:	be 00 00 00 00       	mov    $0x0,%esi
 3ca:	e9 f2 fe ff ff       	jmp    2c1 <printf+0x30>
        putc(fd, c);
 3cf:	89 fa                	mov    %edi,%edx
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	e8 29 fe ff ff       	call   202 <putc>
      state = 0;
 3d9:	be 00 00 00 00       	mov    $0x0,%esi
 3de:	e9 de fe ff ff       	jmp    2c1 <printf+0x30>
    }
  }
}
 3e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e6:	5b                   	pop    %ebx
 3e7:	5e                   	pop    %esi
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret    
