
cat:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	68 00 02 00 00       	push   $0x200
  14:	68 e0 04 00 00       	push   $0x4e0
  19:	56                   	push   %esi
  1a:	e8 ff 00 00 00       	call   11e <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 2b                	jle    53 <cat+0x53>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 e0 04 00 00       	push   $0x4e0
  31:	6a 01                	push   $0x1
  33:	e8 ee 00 00 00       	call   126 <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 90 03 00 00       	push   $0x390
  47:	6a 01                	push   $0x1
  49:	e8 e7 01 00 00       	call   235 <printf>
      exit();
  4e:	e8 b3 00 00 00       	call   106 <exit>
    }
  }
  if(n < 0){
  53:	78 07                	js     5c <cat+0x5c>
    printf(1, "cat: read error\n");
    exit();
  }
}
  55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    
    printf(1, "cat: read error\n");
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 a2 03 00 00       	push   $0x3a2
  64:	6a 01                	push   $0x1
  66:	e8 ca 01 00 00       	call   235 <printf>
    exit();
  6b:	e8 96 00 00 00       	call   106 <exit>

00000070 <main>:

int
main(int argc, char *argv[])
{
  70:	f3 0f 1e fb          	endbr32 
  74:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  78:	83 e4 f0             	and    $0xfffffff0,%esp
  7b:	ff 71 fc             	pushl  -0x4(%ecx)
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	51                   	push   %ecx
  85:	83 ec 18             	sub    $0x18,%esp
  88:	8b 01                	mov    (%ecx),%eax
  8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8d:	8b 51 04             	mov    0x4(%ecx),%edx
  90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  93:	83 f8 01             	cmp    $0x1,%eax
  96:	7e 3c                	jle    d4 <main+0x64>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  98:	be 01 00 00 00       	mov    $0x1,%esi
  9d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  a0:	7d 57                	jge    f9 <main+0x89>
    if((fd = open(argv[i], 0)) < 0){
  a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a5:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	6a 00                	push   $0x0
  ad:	ff 37                	pushl  (%edi)
  af:	e8 92 00 00 00       	call   146 <open>
  b4:	89 c3                	mov    %eax,%ebx
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	85 c0                	test   %eax,%eax
  bb:	78 26                	js     e3 <main+0x73>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	50                   	push   %eax
  c1:	e8 3a ff ff ff       	call   0 <cat>
    close(fd);
  c6:	89 1c 24             	mov    %ebx,(%esp)
  c9:	e8 60 00 00 00       	call   12e <close>
  for(i = 1; i < argc; i++){
  ce:	46                   	inc    %esi
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	eb c9                	jmp    9d <main+0x2d>
    cat(0);
  d4:	83 ec 0c             	sub    $0xc,%esp
  d7:	6a 00                	push   $0x0
  d9:	e8 22 ff ff ff       	call   0 <cat>
    exit();
  de:	e8 23 00 00 00       	call   106 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e3:	83 ec 04             	sub    $0x4,%esp
  e6:	ff 37                	pushl  (%edi)
  e8:	68 b3 03 00 00       	push   $0x3b3
  ed:	6a 01                	push   $0x1
  ef:	e8 41 01 00 00       	call   235 <printf>
      exit();
  f4:	e8 0d 00 00 00       	call   106 <exit>
  }
  exit();
  f9:	e8 08 00 00 00       	call   106 <exit>

000000fe <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  fe:	b8 01 00 00 00       	mov    $0x1,%eax
 103:	cd 40                	int    $0x40
 105:	c3                   	ret    

00000106 <exit>:
SYSCALL(exit)
 106:	b8 02 00 00 00       	mov    $0x2,%eax
 10b:	cd 40                	int    $0x40
 10d:	c3                   	ret    

0000010e <wait>:
SYSCALL(wait)
 10e:	b8 03 00 00 00       	mov    $0x3,%eax
 113:	cd 40                	int    $0x40
 115:	c3                   	ret    

00000116 <pipe>:
SYSCALL(pipe)
 116:	b8 04 00 00 00       	mov    $0x4,%eax
 11b:	cd 40                	int    $0x40
 11d:	c3                   	ret    

0000011e <read>:
SYSCALL(read)
 11e:	b8 05 00 00 00       	mov    $0x5,%eax
 123:	cd 40                	int    $0x40
 125:	c3                   	ret    

00000126 <write>:
SYSCALL(write)
 126:	b8 10 00 00 00       	mov    $0x10,%eax
 12b:	cd 40                	int    $0x40
 12d:	c3                   	ret    

0000012e <close>:
SYSCALL(close)
 12e:	b8 15 00 00 00       	mov    $0x15,%eax
 133:	cd 40                	int    $0x40
 135:	c3                   	ret    

00000136 <kill>:
SYSCALL(kill)
 136:	b8 06 00 00 00       	mov    $0x6,%eax
 13b:	cd 40                	int    $0x40
 13d:	c3                   	ret    

0000013e <exec>:
SYSCALL(exec)
 13e:	b8 07 00 00 00       	mov    $0x7,%eax
 143:	cd 40                	int    $0x40
 145:	c3                   	ret    

00000146 <open>:
SYSCALL(open)
 146:	b8 0f 00 00 00       	mov    $0xf,%eax
 14b:	cd 40                	int    $0x40
 14d:	c3                   	ret    

0000014e <mknod>:
SYSCALL(mknod)
 14e:	b8 11 00 00 00       	mov    $0x11,%eax
 153:	cd 40                	int    $0x40
 155:	c3                   	ret    

00000156 <unlink>:
SYSCALL(unlink)
 156:	b8 12 00 00 00       	mov    $0x12,%eax
 15b:	cd 40                	int    $0x40
 15d:	c3                   	ret    

0000015e <fstat>:
SYSCALL(fstat)
 15e:	b8 08 00 00 00       	mov    $0x8,%eax
 163:	cd 40                	int    $0x40
 165:	c3                   	ret    

00000166 <link>:
SYSCALL(link)
 166:	b8 13 00 00 00       	mov    $0x13,%eax
 16b:	cd 40                	int    $0x40
 16d:	c3                   	ret    

0000016e <mkdir>:
SYSCALL(mkdir)
 16e:	b8 14 00 00 00       	mov    $0x14,%eax
 173:	cd 40                	int    $0x40
 175:	c3                   	ret    

00000176 <chdir>:
SYSCALL(chdir)
 176:	b8 09 00 00 00       	mov    $0x9,%eax
 17b:	cd 40                	int    $0x40
 17d:	c3                   	ret    

0000017e <dup>:
SYSCALL(dup)
 17e:	b8 0a 00 00 00       	mov    $0xa,%eax
 183:	cd 40                	int    $0x40
 185:	c3                   	ret    

00000186 <getpid>:
SYSCALL(getpid)
 186:	b8 0b 00 00 00       	mov    $0xb,%eax
 18b:	cd 40                	int    $0x40
 18d:	c3                   	ret    

0000018e <sbrk>:
SYSCALL(sbrk)
 18e:	b8 0c 00 00 00       	mov    $0xc,%eax
 193:	cd 40                	int    $0x40
 195:	c3                   	ret    

00000196 <sleep>:
SYSCALL(sleep)
 196:	b8 0d 00 00 00       	mov    $0xd,%eax
 19b:	cd 40                	int    $0x40
 19d:	c3                   	ret    

0000019e <uptime>:
SYSCALL(uptime)
 19e:	b8 0e 00 00 00       	mov    $0xe,%eax
 1a3:	cd 40                	int    $0x40
 1a5:	c3                   	ret    

000001a6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 1c             	sub    $0x1c,%esp
 1ac:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1af:	6a 01                	push   $0x1
 1b1:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1b4:	52                   	push   %edx
 1b5:	50                   	push   %eax
 1b6:	e8 6b ff ff ff       	call   126 <write>
}
 1bb:	83 c4 10             	add    $0x10,%esp
 1be:	c9                   	leave  
 1bf:	c3                   	ret    

000001c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
 1c6:	83 ec 2c             	sub    $0x2c,%esp
 1c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1cc:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1d2:	74 04                	je     1d8 <printint+0x18>
 1d4:	85 d2                	test   %edx,%edx
 1d6:	78 3a                	js     212 <printint+0x52>
  neg = 0;
 1d8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1df:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1e4:	89 f0                	mov    %esi,%eax
 1e6:	ba 00 00 00 00       	mov    $0x0,%edx
 1eb:	f7 f1                	div    %ecx
 1ed:	89 df                	mov    %ebx,%edi
 1ef:	43                   	inc    %ebx
 1f0:	8a 92 d0 03 00 00    	mov    0x3d0(%edx),%dl
 1f6:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1fa:	89 f2                	mov    %esi,%edx
 1fc:	89 c6                	mov    %eax,%esi
 1fe:	39 d1                	cmp    %edx,%ecx
 200:	76 e2                	jbe    1e4 <printint+0x24>
  if(neg)
 202:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 206:	74 22                	je     22a <printint+0x6a>
    buf[i++] = '-';
 208:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 20d:	8d 5f 02             	lea    0x2(%edi),%ebx
 210:	eb 18                	jmp    22a <printint+0x6a>
    x = -xx;
 212:	f7 de                	neg    %esi
    neg = 1;
 214:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 21b:	eb c2                	jmp    1df <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 21d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 225:	e8 7c ff ff ff       	call   1a6 <putc>
  while(--i >= 0)
 22a:	4b                   	dec    %ebx
 22b:	79 f0                	jns    21d <printint+0x5d>
}
 22d:	83 c4 2c             	add    $0x2c,%esp
 230:	5b                   	pop    %ebx
 231:	5e                   	pop    %esi
 232:	5f                   	pop    %edi
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    

00000235 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 235:	f3 0f 1e fb          	endbr32 
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	57                   	push   %edi
 23d:	56                   	push   %esi
 23e:	53                   	push   %ebx
 23f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 242:	8d 45 10             	lea    0x10(%ebp),%eax
 245:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 248:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 24d:	bb 00 00 00 00       	mov    $0x0,%ebx
 252:	eb 12                	jmp    266 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 254:	89 fa                	mov    %edi,%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	e8 48 ff ff ff       	call   1a6 <putc>
 25e:	eb 05                	jmp    265 <printf+0x30>
      }
    } else if(state == '%'){
 260:	83 fe 25             	cmp    $0x25,%esi
 263:	74 22                	je     287 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 265:	43                   	inc    %ebx
 266:	8b 45 0c             	mov    0xc(%ebp),%eax
 269:	8a 04 18             	mov    (%eax,%ebx,1),%al
 26c:	84 c0                	test   %al,%al
 26e:	0f 84 13 01 00 00    	je     387 <printf+0x152>
    c = fmt[i] & 0xff;
 274:	0f be f8             	movsbl %al,%edi
 277:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 27a:	85 f6                	test   %esi,%esi
 27c:	75 e2                	jne    260 <printf+0x2b>
      if(c == '%'){
 27e:	83 f8 25             	cmp    $0x25,%eax
 281:	75 d1                	jne    254 <printf+0x1f>
        state = '%';
 283:	89 c6                	mov    %eax,%esi
 285:	eb de                	jmp    265 <printf+0x30>
      if(c == 'd'){
 287:	83 f8 64             	cmp    $0x64,%eax
 28a:	74 43                	je     2cf <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 28c:	83 f8 78             	cmp    $0x78,%eax
 28f:	74 68                	je     2f9 <printf+0xc4>
 291:	83 f8 70             	cmp    $0x70,%eax
 294:	74 63                	je     2f9 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 296:	83 f8 73             	cmp    $0x73,%eax
 299:	0f 84 84 00 00 00    	je     323 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 29f:	83 f8 63             	cmp    $0x63,%eax
 2a2:	0f 84 ad 00 00 00    	je     355 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2a8:	83 f8 25             	cmp    $0x25,%eax
 2ab:	0f 84 c2 00 00 00    	je     373 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2b1:	ba 25 00 00 00       	mov    $0x25,%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	e8 e8 fe ff ff       	call   1a6 <putc>
        putc(fd, c);
 2be:	89 fa                	mov    %edi,%edx
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	e8 de fe ff ff       	call   1a6 <putc>
      }
      state = 0;
 2c8:	be 00 00 00 00       	mov    $0x0,%esi
 2cd:	eb 96                	jmp    265 <printf+0x30>
        printint(fd, *ap, 10, 1);
 2cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d2:	8b 17                	mov    (%edi),%edx
 2d4:	83 ec 0c             	sub    $0xc,%esp
 2d7:	6a 01                	push   $0x1
 2d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	e8 da fe ff ff       	call   1c0 <printint>
        ap++;
 2e6:	83 c7 04             	add    $0x4,%edi
 2e9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2ef:	be 00 00 00 00       	mov    $0x0,%esi
 2f4:	e9 6c ff ff ff       	jmp    265 <printf+0x30>
        printint(fd, *ap, 16, 0);
 2f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2fc:	8b 17                	mov    (%edi),%edx
 2fe:	83 ec 0c             	sub    $0xc,%esp
 301:	6a 00                	push   $0x0
 303:	b9 10 00 00 00       	mov    $0x10,%ecx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	e8 b0 fe ff ff       	call   1c0 <printint>
        ap++;
 310:	83 c7 04             	add    $0x4,%edi
 313:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 316:	83 c4 10             	add    $0x10,%esp
      state = 0;
 319:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 31e:	e9 42 ff ff ff       	jmp    265 <printf+0x30>
        s = (char*)*ap;
 323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 326:	8b 30                	mov    (%eax),%esi
        ap++;
 328:	83 c0 04             	add    $0x4,%eax
 32b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 32e:	85 f6                	test   %esi,%esi
 330:	75 13                	jne    345 <printf+0x110>
          s = "(null)";
 332:	be c8 03 00 00       	mov    $0x3c8,%esi
 337:	eb 0c                	jmp    345 <printf+0x110>
          putc(fd, *s);
 339:	0f be d2             	movsbl %dl,%edx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	e8 62 fe ff ff       	call   1a6 <putc>
          s++;
 344:	46                   	inc    %esi
        while(*s != 0){
 345:	8a 16                	mov    (%esi),%dl
 347:	84 d2                	test   %dl,%dl
 349:	75 ee                	jne    339 <printf+0x104>
      state = 0;
 34b:	be 00 00 00 00       	mov    $0x0,%esi
 350:	e9 10 ff ff ff       	jmp    265 <printf+0x30>
        putc(fd, *ap);
 355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 358:	0f be 17             	movsbl (%edi),%edx
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	e8 43 fe ff ff       	call   1a6 <putc>
        ap++;
 363:	83 c7 04             	add    $0x4,%edi
 366:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 369:	be 00 00 00 00       	mov    $0x0,%esi
 36e:	e9 f2 fe ff ff       	jmp    265 <printf+0x30>
        putc(fd, c);
 373:	89 fa                	mov    %edi,%edx
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	e8 29 fe ff ff       	call   1a6 <putc>
      state = 0;
 37d:	be 00 00 00 00       	mov    $0x0,%esi
 382:	e9 de fe ff ff       	jmp    265 <printf+0x30>
    }
  }
}
 387:	8d 65 f4             	lea    -0xc(%ebp),%esp
 38a:	5b                   	pop    %ebx
 38b:	5e                   	pop    %esi
 38c:	5f                   	pop    %edi
 38d:	5d                   	pop    %ebp
 38e:	c3                   	ret    
