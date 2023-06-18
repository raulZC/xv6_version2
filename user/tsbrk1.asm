
tsbrk1:     formato del fichero elf32-i386


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
  1c:	e8 54 01 00 00       	call   175 <sbrk>
  21:	89 c3                	mov    %eax,%ebx

  a[500] = 1;
  23:	c6 80 f4 01 00 00 01 	movb   $0x1,0x1f4(%eax)

  if ((uint)a + 15000 != (uint) sbrk (-15000))
  2a:	8d b0 98 3a 00 00    	lea    0x3a98(%eax),%esi
  30:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  37:	e8 39 01 00 00       	call   175 <sbrk>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	39 c6                	cmp    %eax,%esi
  41:	74 1b                	je     5e <main+0x5e>
  {
    printf (1, "sbrk() con número positivo falló.\n");
  43:	83 ec 08             	sub    $0x8,%esp
  46:	68 88 03 00 00       	push   $0x388
  4b:	6a 01                	push   $0x1
  4d:	e8 da 01 00 00       	call   22c <printf>
    exit(1);
  52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  59:	e8 8f 00 00 00       	call   ed <exit>
  }

  if (a != sbrk (0))
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	6a 00                	push   $0x0
  63:	e8 0d 01 00 00       	call   175 <sbrk>
  68:	83 c4 10             	add    $0x10,%esp
  6b:	39 c3                	cmp    %eax,%ebx
  6d:	74 1b                	je     8a <main+0x8a>
  {
    printf (1, "sbrk() con cero falló.\n");
  6f:	83 ec 08             	sub    $0x8,%esp
  72:	68 ad 03 00 00       	push   $0x3ad
  77:	6a 01                	push   $0x1
  79:	e8 ae 01 00 00       	call   22c <printf>
    exit(2);
  7e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  85:	e8 63 00 00 00       	call   ed <exit>
  }

  if (a != sbrk (15000))
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	68 98 3a 00 00       	push   $0x3a98
  92:	e8 de 00 00 00       	call   175 <sbrk>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	39 c3                	cmp    %eax,%ebx
  9c:	74 1b                	je     b9 <main+0xb9>
  {
    printf (1, "sbrk() negativo falló.\n");
  9e:	83 ec 08             	sub    $0x8,%esp
  a1:	68 c6 03 00 00       	push   $0x3c6
  a6:	6a 01                	push   $0x1
  a8:	e8 7f 01 00 00       	call   22c <printf>
    exit(3);
  ad:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  b4:	e8 34 00 00 00       	call   ed <exit>
  }

  printf (1, "Debe imprimir 1: %d.\n", ++a[500]);
  b9:	8a 83 f4 01 00 00    	mov    0x1f4(%ebx),%al
  bf:	40                   	inc    %eax
  c0:	88 83 f4 01 00 00    	mov    %al,0x1f4(%ebx)
  c6:	83 ec 04             	sub    $0x4,%esp
  c9:	0f be c0             	movsbl %al,%eax
  cc:	50                   	push   %eax
  cd:	68 df 03 00 00       	push   $0x3df
  d2:	6a 01                	push   $0x1
  d4:	e8 53 01 00 00       	call   22c <printf>

  exit(0);
  d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  e0:	e8 08 00 00 00       	call   ed <exit>

000000e5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  e5:	b8 01 00 00 00       	mov    $0x1,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret    

000000ed <exit>:
SYSCALL(exit)
  ed:	b8 02 00 00 00       	mov    $0x2,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret    

000000f5 <wait>:
SYSCALL(wait)
  f5:	b8 03 00 00 00       	mov    $0x3,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret    

000000fd <pipe>:
SYSCALL(pipe)
  fd:	b8 04 00 00 00       	mov    $0x4,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <read>:
SYSCALL(read)
 105:	b8 05 00 00 00       	mov    $0x5,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret    

0000010d <write>:
SYSCALL(write)
 10d:	b8 10 00 00 00       	mov    $0x10,%eax
 112:	cd 40                	int    $0x40
 114:	c3                   	ret    

00000115 <close>:
SYSCALL(close)
 115:	b8 15 00 00 00       	mov    $0x15,%eax
 11a:	cd 40                	int    $0x40
 11c:	c3                   	ret    

0000011d <kill>:
SYSCALL(kill)
 11d:	b8 06 00 00 00       	mov    $0x6,%eax
 122:	cd 40                	int    $0x40
 124:	c3                   	ret    

00000125 <exec>:
SYSCALL(exec)
 125:	b8 07 00 00 00       	mov    $0x7,%eax
 12a:	cd 40                	int    $0x40
 12c:	c3                   	ret    

0000012d <open>:
SYSCALL(open)
 12d:	b8 0f 00 00 00       	mov    $0xf,%eax
 132:	cd 40                	int    $0x40
 134:	c3                   	ret    

00000135 <mknod>:
SYSCALL(mknod)
 135:	b8 11 00 00 00       	mov    $0x11,%eax
 13a:	cd 40                	int    $0x40
 13c:	c3                   	ret    

0000013d <unlink>:
SYSCALL(unlink)
 13d:	b8 12 00 00 00       	mov    $0x12,%eax
 142:	cd 40                	int    $0x40
 144:	c3                   	ret    

00000145 <fstat>:
SYSCALL(fstat)
 145:	b8 08 00 00 00       	mov    $0x8,%eax
 14a:	cd 40                	int    $0x40
 14c:	c3                   	ret    

0000014d <link>:
SYSCALL(link)
 14d:	b8 13 00 00 00       	mov    $0x13,%eax
 152:	cd 40                	int    $0x40
 154:	c3                   	ret    

00000155 <mkdir>:
SYSCALL(mkdir)
 155:	b8 14 00 00 00       	mov    $0x14,%eax
 15a:	cd 40                	int    $0x40
 15c:	c3                   	ret    

0000015d <chdir>:
SYSCALL(chdir)
 15d:	b8 09 00 00 00       	mov    $0x9,%eax
 162:	cd 40                	int    $0x40
 164:	c3                   	ret    

00000165 <dup>:
SYSCALL(dup)
 165:	b8 0a 00 00 00       	mov    $0xa,%eax
 16a:	cd 40                	int    $0x40
 16c:	c3                   	ret    

0000016d <getpid>:
SYSCALL(getpid)
 16d:	b8 0b 00 00 00       	mov    $0xb,%eax
 172:	cd 40                	int    $0x40
 174:	c3                   	ret    

00000175 <sbrk>:
SYSCALL(sbrk)
 175:	b8 0c 00 00 00       	mov    $0xc,%eax
 17a:	cd 40                	int    $0x40
 17c:	c3                   	ret    

0000017d <sleep>:
SYSCALL(sleep)
 17d:	b8 0d 00 00 00       	mov    $0xd,%eax
 182:	cd 40                	int    $0x40
 184:	c3                   	ret    

00000185 <uptime>:
SYSCALL(uptime)
 185:	b8 0e 00 00 00       	mov    $0xe,%eax
 18a:	cd 40                	int    $0x40
 18c:	c3                   	ret    

0000018d <date>:
SYSCALL(date)
 18d:	b8 16 00 00 00       	mov    $0x16,%eax
 192:	cd 40                	int    $0x40
 194:	c3                   	ret    

00000195 <dup2>:
 195:	b8 17 00 00 00       	mov    $0x17,%eax
 19a:	cd 40                	int    $0x40
 19c:	c3                   	ret    

0000019d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 19d:	55                   	push   %ebp
 19e:	89 e5                	mov    %esp,%ebp
 1a0:	83 ec 1c             	sub    $0x1c,%esp
 1a3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1a6:	6a 01                	push   $0x1
 1a8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1ab:	52                   	push   %edx
 1ac:	50                   	push   %eax
 1ad:	e8 5b ff ff ff       	call   10d <write>
}
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	c9                   	leave  
 1b6:	c3                   	ret    

000001b7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1b7:	55                   	push   %ebp
 1b8:	89 e5                	mov    %esp,%ebp
 1ba:	57                   	push   %edi
 1bb:	56                   	push   %esi
 1bc:	53                   	push   %ebx
 1bd:	83 ec 2c             	sub    $0x2c,%esp
 1c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1c3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1c9:	74 04                	je     1cf <printint+0x18>
 1cb:	85 d2                	test   %edx,%edx
 1cd:	78 3a                	js     209 <printint+0x52>
  neg = 0;
 1cf:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1db:	89 f0                	mov    %esi,%eax
 1dd:	ba 00 00 00 00       	mov    $0x0,%edx
 1e2:	f7 f1                	div    %ecx
 1e4:	89 df                	mov    %ebx,%edi
 1e6:	43                   	inc    %ebx
 1e7:	8a 92 fc 03 00 00    	mov    0x3fc(%edx),%dl
 1ed:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1f1:	89 f2                	mov    %esi,%edx
 1f3:	89 c6                	mov    %eax,%esi
 1f5:	39 d1                	cmp    %edx,%ecx
 1f7:	76 e2                	jbe    1db <printint+0x24>
  if(neg)
 1f9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1fd:	74 22                	je     221 <printint+0x6a>
    buf[i++] = '-';
 1ff:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 204:	8d 5f 02             	lea    0x2(%edi),%ebx
 207:	eb 18                	jmp    221 <printint+0x6a>
    x = -xx;
 209:	f7 de                	neg    %esi
    neg = 1;
 20b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 212:	eb c2                	jmp    1d6 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 214:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 219:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 21c:	e8 7c ff ff ff       	call   19d <putc>
  while(--i >= 0)
 221:	4b                   	dec    %ebx
 222:	79 f0                	jns    214 <printint+0x5d>
}
 224:	83 c4 2c             	add    $0x2c,%esp
 227:	5b                   	pop    %ebx
 228:	5e                   	pop    %esi
 229:	5f                   	pop    %edi
 22a:	5d                   	pop    %ebp
 22b:	c3                   	ret    

0000022c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 22c:	f3 0f 1e fb          	endbr32 
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	53                   	push   %ebx
 236:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 239:	8d 45 10             	lea    0x10(%ebp),%eax
 23c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 23f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 244:	bb 00 00 00 00       	mov    $0x0,%ebx
 249:	eb 12                	jmp    25d <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 24b:	89 fa                	mov    %edi,%edx
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	e8 48 ff ff ff       	call   19d <putc>
 255:	eb 05                	jmp    25c <printf+0x30>
      }
    } else if(state == '%'){
 257:	83 fe 25             	cmp    $0x25,%esi
 25a:	74 22                	je     27e <printf+0x52>
  for(i = 0; fmt[i]; i++){
 25c:	43                   	inc    %ebx
 25d:	8b 45 0c             	mov    0xc(%ebp),%eax
 260:	8a 04 18             	mov    (%eax,%ebx,1),%al
 263:	84 c0                	test   %al,%al
 265:	0f 84 13 01 00 00    	je     37e <printf+0x152>
    c = fmt[i] & 0xff;
 26b:	0f be f8             	movsbl %al,%edi
 26e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 271:	85 f6                	test   %esi,%esi
 273:	75 e2                	jne    257 <printf+0x2b>
      if(c == '%'){
 275:	83 f8 25             	cmp    $0x25,%eax
 278:	75 d1                	jne    24b <printf+0x1f>
        state = '%';
 27a:	89 c6                	mov    %eax,%esi
 27c:	eb de                	jmp    25c <printf+0x30>
      if(c == 'd'){
 27e:	83 f8 64             	cmp    $0x64,%eax
 281:	74 43                	je     2c6 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 283:	83 f8 78             	cmp    $0x78,%eax
 286:	74 68                	je     2f0 <printf+0xc4>
 288:	83 f8 70             	cmp    $0x70,%eax
 28b:	74 63                	je     2f0 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 28d:	83 f8 73             	cmp    $0x73,%eax
 290:	0f 84 84 00 00 00    	je     31a <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 296:	83 f8 63             	cmp    $0x63,%eax
 299:	0f 84 ad 00 00 00    	je     34c <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 29f:	83 f8 25             	cmp    $0x25,%eax
 2a2:	0f 84 c2 00 00 00    	je     36a <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2a8:	ba 25 00 00 00       	mov    $0x25,%edx
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	e8 e8 fe ff ff       	call   19d <putc>
        putc(fd, c);
 2b5:	89 fa                	mov    %edi,%edx
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	e8 de fe ff ff       	call   19d <putc>
      }
      state = 0;
 2bf:	be 00 00 00 00       	mov    $0x0,%esi
 2c4:	eb 96                	jmp    25c <printf+0x30>
        printint(fd, *ap, 10, 1);
 2c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2c9:	8b 17                	mov    (%edi),%edx
 2cb:	83 ec 0c             	sub    $0xc,%esp
 2ce:	6a 01                	push   $0x1
 2d0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	e8 da fe ff ff       	call   1b7 <printint>
        ap++;
 2dd:	83 c7 04             	add    $0x4,%edi
 2e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2e3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2e6:	be 00 00 00 00       	mov    $0x0,%esi
 2eb:	e9 6c ff ff ff       	jmp    25c <printf+0x30>
        printint(fd, *ap, 16, 0);
 2f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2f3:	8b 17                	mov    (%edi),%edx
 2f5:	83 ec 0c             	sub    $0xc,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	b9 10 00 00 00       	mov    $0x10,%ecx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	e8 b0 fe ff ff       	call   1b7 <printint>
        ap++;
 307:	83 c7 04             	add    $0x4,%edi
 30a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 30d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 310:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 315:	e9 42 ff ff ff       	jmp    25c <printf+0x30>
        s = (char*)*ap;
 31a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 31d:	8b 30                	mov    (%eax),%esi
        ap++;
 31f:	83 c0 04             	add    $0x4,%eax
 322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 325:	85 f6                	test   %esi,%esi
 327:	75 13                	jne    33c <printf+0x110>
          s = "(null)";
 329:	be f5 03 00 00       	mov    $0x3f5,%esi
 32e:	eb 0c                	jmp    33c <printf+0x110>
          putc(fd, *s);
 330:	0f be d2             	movsbl %dl,%edx
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	e8 62 fe ff ff       	call   19d <putc>
          s++;
 33b:	46                   	inc    %esi
        while(*s != 0){
 33c:	8a 16                	mov    (%esi),%dl
 33e:	84 d2                	test   %dl,%dl
 340:	75 ee                	jne    330 <printf+0x104>
      state = 0;
 342:	be 00 00 00 00       	mov    $0x0,%esi
 347:	e9 10 ff ff ff       	jmp    25c <printf+0x30>
        putc(fd, *ap);
 34c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 34f:	0f be 17             	movsbl (%edi),%edx
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	e8 43 fe ff ff       	call   19d <putc>
        ap++;
 35a:	83 c7 04             	add    $0x4,%edi
 35d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 360:	be 00 00 00 00       	mov    $0x0,%esi
 365:	e9 f2 fe ff ff       	jmp    25c <printf+0x30>
        putc(fd, c);
 36a:	89 fa                	mov    %edi,%edx
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	e8 29 fe ff ff       	call   19d <putc>
      state = 0;
 374:	be 00 00 00 00       	mov    $0x0,%esi
 379:	e9 de fe ff ff       	jmp    25c <printf+0x30>
    }
  }
}
 37e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 381:	5b                   	pop    %ebx
 382:	5e                   	pop    %esi
 383:	5f                   	pop    %edi
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    
