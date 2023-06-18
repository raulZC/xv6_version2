
tsbrk2:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <recursive>:
#include "user.h"

char a[4096] = {0};

int recursive(int v)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 1c             	sub    $0x1c,%esp
  printf (1, ".");
   b:	68 30 03 00 00       	push   $0x330
  10:	6a 01                	push   $0x1
  12:	e8 bd 01 00 00       	call   1d4 <printf>
  volatile int q = v;
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (q > 0)
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	7f 0a                	jg     31 <recursive+0x31>
    return recursive (q+1)+recursive (q+2);
  return 0;
  27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2f:	c9                   	leave  
  30:	c3                   	ret    
    return recursive (q+1)+recursive (q+2);
  31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  34:	83 ec 0c             	sub    $0xc,%esp
  37:	40                   	inc    %eax
  38:	50                   	push   %eax
  39:	e8 c2 ff ff ff       	call   0 <recursive>
  3e:	89 c3                	mov    %eax,%ebx
  40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  43:	83 c0 02             	add    $0x2,%eax
  46:	89 04 24             	mov    %eax,(%esp)
  49:	e8 b2 ff ff ff       	call   0 <recursive>
  4e:	01 d8                	add    %ebx,%eax
  50:	83 c4 10             	add    $0x10,%esp
  53:	eb d7                	jmp    2c <recursive+0x2c>

00000055 <main>:


int
main(int argc, char *argv[])
{
  55:	f3 0f 1e fb          	endbr32 
  59:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  5d:	83 e4 f0             	and    $0xfffffff0,%esp
  60:	ff 71 fc             	pushl  -0x4(%ecx)
  63:	55                   	push   %ebp
  64:	89 e5                	mov    %esp,%ebp
  66:	51                   	push   %ecx
  67:	83 ec 10             	sub    $0x10,%esp
  int i = 1;

  // Llamar recursivamente a recursive
  printf (1, ": %d\n", recursive (i));
  6a:	6a 01                	push   $0x1
  6c:	e8 8f ff ff ff       	call   0 <recursive>
  71:	83 c4 0c             	add    $0xc,%esp
  74:	50                   	push   %eax
  75:	68 32 03 00 00       	push   $0x332
  7a:	6a 01                	push   $0x1
  7c:	e8 53 01 00 00       	call   1d4 <printf>

  exit(0);
  81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  88:	e8 08 00 00 00       	call   95 <exit>

0000008d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  8d:	b8 01 00 00 00       	mov    $0x1,%eax
  92:	cd 40                	int    $0x40
  94:	c3                   	ret    

00000095 <exit>:
SYSCALL(exit)
  95:	b8 02 00 00 00       	mov    $0x2,%eax
  9a:	cd 40                	int    $0x40
  9c:	c3                   	ret    

0000009d <wait>:
SYSCALL(wait)
  9d:	b8 03 00 00 00       	mov    $0x3,%eax
  a2:	cd 40                	int    $0x40
  a4:	c3                   	ret    

000000a5 <pipe>:
SYSCALL(pipe)
  a5:	b8 04 00 00 00       	mov    $0x4,%eax
  aa:	cd 40                	int    $0x40
  ac:	c3                   	ret    

000000ad <read>:
SYSCALL(read)
  ad:	b8 05 00 00 00       	mov    $0x5,%eax
  b2:	cd 40                	int    $0x40
  b4:	c3                   	ret    

000000b5 <write>:
SYSCALL(write)
  b5:	b8 10 00 00 00       	mov    $0x10,%eax
  ba:	cd 40                	int    $0x40
  bc:	c3                   	ret    

000000bd <close>:
SYSCALL(close)
  bd:	b8 15 00 00 00       	mov    $0x15,%eax
  c2:	cd 40                	int    $0x40
  c4:	c3                   	ret    

000000c5 <kill>:
SYSCALL(kill)
  c5:	b8 06 00 00 00       	mov    $0x6,%eax
  ca:	cd 40                	int    $0x40
  cc:	c3                   	ret    

000000cd <exec>:
SYSCALL(exec)
  cd:	b8 07 00 00 00       	mov    $0x7,%eax
  d2:	cd 40                	int    $0x40
  d4:	c3                   	ret    

000000d5 <open>:
SYSCALL(open)
  d5:	b8 0f 00 00 00       	mov    $0xf,%eax
  da:	cd 40                	int    $0x40
  dc:	c3                   	ret    

000000dd <mknod>:
SYSCALL(mknod)
  dd:	b8 11 00 00 00       	mov    $0x11,%eax
  e2:	cd 40                	int    $0x40
  e4:	c3                   	ret    

000000e5 <unlink>:
SYSCALL(unlink)
  e5:	b8 12 00 00 00       	mov    $0x12,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret    

000000ed <fstat>:
SYSCALL(fstat)
  ed:	b8 08 00 00 00       	mov    $0x8,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret    

000000f5 <link>:
SYSCALL(link)
  f5:	b8 13 00 00 00       	mov    $0x13,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret    

000000fd <mkdir>:
SYSCALL(mkdir)
  fd:	b8 14 00 00 00       	mov    $0x14,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <chdir>:
SYSCALL(chdir)
 105:	b8 09 00 00 00       	mov    $0x9,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret    

0000010d <dup>:
SYSCALL(dup)
 10d:	b8 0a 00 00 00       	mov    $0xa,%eax
 112:	cd 40                	int    $0x40
 114:	c3                   	ret    

00000115 <getpid>:
SYSCALL(getpid)
 115:	b8 0b 00 00 00       	mov    $0xb,%eax
 11a:	cd 40                	int    $0x40
 11c:	c3                   	ret    

0000011d <sbrk>:
SYSCALL(sbrk)
 11d:	b8 0c 00 00 00       	mov    $0xc,%eax
 122:	cd 40                	int    $0x40
 124:	c3                   	ret    

00000125 <sleep>:
SYSCALL(sleep)
 125:	b8 0d 00 00 00       	mov    $0xd,%eax
 12a:	cd 40                	int    $0x40
 12c:	c3                   	ret    

0000012d <uptime>:
SYSCALL(uptime)
 12d:	b8 0e 00 00 00       	mov    $0xe,%eax
 132:	cd 40                	int    $0x40
 134:	c3                   	ret    

00000135 <date>:
SYSCALL(date)
 135:	b8 16 00 00 00       	mov    $0x16,%eax
 13a:	cd 40                	int    $0x40
 13c:	c3                   	ret    

0000013d <dup2>:
 13d:	b8 17 00 00 00       	mov    $0x17,%eax
 142:	cd 40                	int    $0x40
 144:	c3                   	ret    

00000145 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 1c             	sub    $0x1c,%esp
 14b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 14e:	6a 01                	push   $0x1
 150:	8d 55 f4             	lea    -0xc(%ebp),%edx
 153:	52                   	push   %edx
 154:	50                   	push   %eax
 155:	e8 5b ff ff ff       	call   b5 <write>
}
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	57                   	push   %edi
 163:	56                   	push   %esi
 164:	53                   	push   %ebx
 165:	83 ec 2c             	sub    $0x2c,%esp
 168:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 16b:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 16d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 171:	74 04                	je     177 <printint+0x18>
 173:	85 d2                	test   %edx,%edx
 175:	78 3a                	js     1b1 <printint+0x52>
  neg = 0;
 177:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 17e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 183:	89 f0                	mov    %esi,%eax
 185:	ba 00 00 00 00       	mov    $0x0,%edx
 18a:	f7 f1                	div    %ecx
 18c:	89 df                	mov    %ebx,%edi
 18e:	43                   	inc    %ebx
 18f:	8a 92 40 03 00 00    	mov    0x340(%edx),%dl
 195:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 199:	89 f2                	mov    %esi,%edx
 19b:	89 c6                	mov    %eax,%esi
 19d:	39 d1                	cmp    %edx,%ecx
 19f:	76 e2                	jbe    183 <printint+0x24>
  if(neg)
 1a1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1a5:	74 22                	je     1c9 <printint+0x6a>
    buf[i++] = '-';
 1a7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1ac:	8d 5f 02             	lea    0x2(%edi),%ebx
 1af:	eb 18                	jmp    1c9 <printint+0x6a>
    x = -xx;
 1b1:	f7 de                	neg    %esi
    neg = 1;
 1b3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1ba:	eb c2                	jmp    17e <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1bc:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c4:	e8 7c ff ff ff       	call   145 <putc>
  while(--i >= 0)
 1c9:	4b                   	dec    %ebx
 1ca:	79 f0                	jns    1bc <printint+0x5d>
}
 1cc:	83 c4 2c             	add    $0x2c,%esp
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5f                   	pop    %edi
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    

000001d4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1d4:	f3 0f 1e fb          	endbr32 
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	57                   	push   %edi
 1dc:	56                   	push   %esi
 1dd:	53                   	push   %ebx
 1de:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1e1:	8d 45 10             	lea    0x10(%ebp),%eax
 1e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1e7:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1ec:	bb 00 00 00 00       	mov    $0x0,%ebx
 1f1:	eb 12                	jmp    205 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1f3:	89 fa                	mov    %edi,%edx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	e8 48 ff ff ff       	call   145 <putc>
 1fd:	eb 05                	jmp    204 <printf+0x30>
      }
    } else if(state == '%'){
 1ff:	83 fe 25             	cmp    $0x25,%esi
 202:	74 22                	je     226 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 204:	43                   	inc    %ebx
 205:	8b 45 0c             	mov    0xc(%ebp),%eax
 208:	8a 04 18             	mov    (%eax,%ebx,1),%al
 20b:	84 c0                	test   %al,%al
 20d:	0f 84 13 01 00 00    	je     326 <printf+0x152>
    c = fmt[i] & 0xff;
 213:	0f be f8             	movsbl %al,%edi
 216:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 219:	85 f6                	test   %esi,%esi
 21b:	75 e2                	jne    1ff <printf+0x2b>
      if(c == '%'){
 21d:	83 f8 25             	cmp    $0x25,%eax
 220:	75 d1                	jne    1f3 <printf+0x1f>
        state = '%';
 222:	89 c6                	mov    %eax,%esi
 224:	eb de                	jmp    204 <printf+0x30>
      if(c == 'd'){
 226:	83 f8 64             	cmp    $0x64,%eax
 229:	74 43                	je     26e <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 22b:	83 f8 78             	cmp    $0x78,%eax
 22e:	74 68                	je     298 <printf+0xc4>
 230:	83 f8 70             	cmp    $0x70,%eax
 233:	74 63                	je     298 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 235:	83 f8 73             	cmp    $0x73,%eax
 238:	0f 84 84 00 00 00    	je     2c2 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 23e:	83 f8 63             	cmp    $0x63,%eax
 241:	0f 84 ad 00 00 00    	je     2f4 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 247:	83 f8 25             	cmp    $0x25,%eax
 24a:	0f 84 c2 00 00 00    	je     312 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 250:	ba 25 00 00 00       	mov    $0x25,%edx
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	e8 e8 fe ff ff       	call   145 <putc>
        putc(fd, c);
 25d:	89 fa                	mov    %edi,%edx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	e8 de fe ff ff       	call   145 <putc>
      }
      state = 0;
 267:	be 00 00 00 00       	mov    $0x0,%esi
 26c:	eb 96                	jmp    204 <printf+0x30>
        printint(fd, *ap, 10, 1);
 26e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 271:	8b 17                	mov    (%edi),%edx
 273:	83 ec 0c             	sub    $0xc,%esp
 276:	6a 01                	push   $0x1
 278:	b9 0a 00 00 00       	mov    $0xa,%ecx
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	e8 da fe ff ff       	call   15f <printint>
        ap++;
 285:	83 c7 04             	add    $0x4,%edi
 288:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 28b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 28e:	be 00 00 00 00       	mov    $0x0,%esi
 293:	e9 6c ff ff ff       	jmp    204 <printf+0x30>
        printint(fd, *ap, 16, 0);
 298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 29b:	8b 17                	mov    (%edi),%edx
 29d:	83 ec 0c             	sub    $0xc,%esp
 2a0:	6a 00                	push   $0x0
 2a2:	b9 10 00 00 00       	mov    $0x10,%ecx
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	e8 b0 fe ff ff       	call   15f <printint>
        ap++;
 2af:	83 c7 04             	add    $0x4,%edi
 2b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2b5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2b8:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2bd:	e9 42 ff ff ff       	jmp    204 <printf+0x30>
        s = (char*)*ap;
 2c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2c5:	8b 30                	mov    (%eax),%esi
        ap++;
 2c7:	83 c0 04             	add    $0x4,%eax
 2ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2cd:	85 f6                	test   %esi,%esi
 2cf:	75 13                	jne    2e4 <printf+0x110>
          s = "(null)";
 2d1:	be 38 03 00 00       	mov    $0x338,%esi
 2d6:	eb 0c                	jmp    2e4 <printf+0x110>
          putc(fd, *s);
 2d8:	0f be d2             	movsbl %dl,%edx
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	e8 62 fe ff ff       	call   145 <putc>
          s++;
 2e3:	46                   	inc    %esi
        while(*s != 0){
 2e4:	8a 16                	mov    (%esi),%dl
 2e6:	84 d2                	test   %dl,%dl
 2e8:	75 ee                	jne    2d8 <printf+0x104>
      state = 0;
 2ea:	be 00 00 00 00       	mov    $0x0,%esi
 2ef:	e9 10 ff ff ff       	jmp    204 <printf+0x30>
        putc(fd, *ap);
 2f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2f7:	0f be 17             	movsbl (%edi),%edx
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	e8 43 fe ff ff       	call   145 <putc>
        ap++;
 302:	83 c7 04             	add    $0x4,%edi
 305:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 308:	be 00 00 00 00       	mov    $0x0,%esi
 30d:	e9 f2 fe ff ff       	jmp    204 <printf+0x30>
        putc(fd, c);
 312:	89 fa                	mov    %edi,%edx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	e8 29 fe ff ff       	call   145 <putc>
      state = 0;
 31c:	be 00 00 00 00       	mov    $0x0,%esi
 321:	e9 de fe ff ff       	jmp    204 <printf+0x30>
    }
  }
}
 326:	8d 65 f4             	lea    -0xc(%ebp),%esp
 329:	5b                   	pop    %ebx
 32a:	5e                   	pop    %esi
 32b:	5f                   	pop    %edi
 32c:	5d                   	pop    %ebp
 32d:	c3                   	ret    
