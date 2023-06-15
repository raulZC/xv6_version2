
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
  42:	68 98 03 00 00       	push   $0x398
  47:	6a 01                	push   $0x1
  49:	e8 ef 01 00 00       	call   23d <printf>
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
  5f:	68 aa 03 00 00       	push   $0x3aa
  64:	6a 01                	push   $0x1
  66:	e8 d2 01 00 00       	call   23d <printf>
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
  e8:	68 bb 03 00 00       	push   $0x3bb
  ed:	6a 01                	push   $0x1
  ef:	e8 49 01 00 00       	call   23d <printf>
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

000001a6 <date>:
SYSCALL(date)
 1a6:	b8 16 00 00 00       	mov    $0x16,%eax
 1ab:	cd 40                	int    $0x40
 1ad:	c3                   	ret    

000001ae <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 1c             	sub    $0x1c,%esp
 1b4:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1b7:	6a 01                	push   $0x1
 1b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1bc:	52                   	push   %edx
 1bd:	50                   	push   %eax
 1be:	e8 63 ff ff ff       	call   126 <write>
}
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	57                   	push   %edi
 1cc:	56                   	push   %esi
 1cd:	53                   	push   %ebx
 1ce:	83 ec 2c             	sub    $0x2c,%esp
 1d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1d4:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1da:	74 04                	je     1e0 <printint+0x18>
 1dc:	85 d2                	test   %edx,%edx
 1de:	78 3a                	js     21a <printint+0x52>
  neg = 0;
 1e0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1ec:	89 f0                	mov    %esi,%eax
 1ee:	ba 00 00 00 00       	mov    $0x0,%edx
 1f3:	f7 f1                	div    %ecx
 1f5:	89 df                	mov    %ebx,%edi
 1f7:	43                   	inc    %ebx
 1f8:	8a 92 d8 03 00 00    	mov    0x3d8(%edx),%dl
 1fe:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 202:	89 f2                	mov    %esi,%edx
 204:	89 c6                	mov    %eax,%esi
 206:	39 d1                	cmp    %edx,%ecx
 208:	76 e2                	jbe    1ec <printint+0x24>
  if(neg)
 20a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 20e:	74 22                	je     232 <printint+0x6a>
    buf[i++] = '-';
 210:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 215:	8d 5f 02             	lea    0x2(%edi),%ebx
 218:	eb 18                	jmp    232 <printint+0x6a>
    x = -xx;
 21a:	f7 de                	neg    %esi
    neg = 1;
 21c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 223:	eb c2                	jmp    1e7 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 225:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 22a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 22d:	e8 7c ff ff ff       	call   1ae <putc>
  while(--i >= 0)
 232:	4b                   	dec    %ebx
 233:	79 f0                	jns    225 <printint+0x5d>
}
 235:	83 c4 2c             	add    $0x2c,%esp
 238:	5b                   	pop    %ebx
 239:	5e                   	pop    %esi
 23a:	5f                   	pop    %edi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    

0000023d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 23d:	f3 0f 1e fb          	endbr32 
 241:	55                   	push   %ebp
 242:	89 e5                	mov    %esp,%ebp
 244:	57                   	push   %edi
 245:	56                   	push   %esi
 246:	53                   	push   %ebx
 247:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 24a:	8d 45 10             	lea    0x10(%ebp),%eax
 24d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 250:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 255:	bb 00 00 00 00       	mov    $0x0,%ebx
 25a:	eb 12                	jmp    26e <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 25c:	89 fa                	mov    %edi,%edx
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	e8 48 ff ff ff       	call   1ae <putc>
 266:	eb 05                	jmp    26d <printf+0x30>
      }
    } else if(state == '%'){
 268:	83 fe 25             	cmp    $0x25,%esi
 26b:	74 22                	je     28f <printf+0x52>
  for(i = 0; fmt[i]; i++){
 26d:	43                   	inc    %ebx
 26e:	8b 45 0c             	mov    0xc(%ebp),%eax
 271:	8a 04 18             	mov    (%eax,%ebx,1),%al
 274:	84 c0                	test   %al,%al
 276:	0f 84 13 01 00 00    	je     38f <printf+0x152>
    c = fmt[i] & 0xff;
 27c:	0f be f8             	movsbl %al,%edi
 27f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 282:	85 f6                	test   %esi,%esi
 284:	75 e2                	jne    268 <printf+0x2b>
      if(c == '%'){
 286:	83 f8 25             	cmp    $0x25,%eax
 289:	75 d1                	jne    25c <printf+0x1f>
        state = '%';
 28b:	89 c6                	mov    %eax,%esi
 28d:	eb de                	jmp    26d <printf+0x30>
      if(c == 'd'){
 28f:	83 f8 64             	cmp    $0x64,%eax
 292:	74 43                	je     2d7 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 294:	83 f8 78             	cmp    $0x78,%eax
 297:	74 68                	je     301 <printf+0xc4>
 299:	83 f8 70             	cmp    $0x70,%eax
 29c:	74 63                	je     301 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 29e:	83 f8 73             	cmp    $0x73,%eax
 2a1:	0f 84 84 00 00 00    	je     32b <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2a7:	83 f8 63             	cmp    $0x63,%eax
 2aa:	0f 84 ad 00 00 00    	je     35d <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2b0:	83 f8 25             	cmp    $0x25,%eax
 2b3:	0f 84 c2 00 00 00    	je     37b <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2b9:	ba 25 00 00 00       	mov    $0x25,%edx
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	e8 e8 fe ff ff       	call   1ae <putc>
        putc(fd, c);
 2c6:	89 fa                	mov    %edi,%edx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	e8 de fe ff ff       	call   1ae <putc>
      }
      state = 0;
 2d0:	be 00 00 00 00       	mov    $0x0,%esi
 2d5:	eb 96                	jmp    26d <printf+0x30>
        printint(fd, *ap, 10, 1);
 2d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2da:	8b 17                	mov    (%edi),%edx
 2dc:	83 ec 0c             	sub    $0xc,%esp
 2df:	6a 01                	push   $0x1
 2e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	e8 da fe ff ff       	call   1c8 <printint>
        ap++;
 2ee:	83 c7 04             	add    $0x4,%edi
 2f1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2f4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2f7:	be 00 00 00 00       	mov    $0x0,%esi
 2fc:	e9 6c ff ff ff       	jmp    26d <printf+0x30>
        printint(fd, *ap, 16, 0);
 301:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 304:	8b 17                	mov    (%edi),%edx
 306:	83 ec 0c             	sub    $0xc,%esp
 309:	6a 00                	push   $0x0
 30b:	b9 10 00 00 00       	mov    $0x10,%ecx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	e8 b0 fe ff ff       	call   1c8 <printint>
        ap++;
 318:	83 c7 04             	add    $0x4,%edi
 31b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 31e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 321:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 326:	e9 42 ff ff ff       	jmp    26d <printf+0x30>
        s = (char*)*ap;
 32b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 32e:	8b 30                	mov    (%eax),%esi
        ap++;
 330:	83 c0 04             	add    $0x4,%eax
 333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 336:	85 f6                	test   %esi,%esi
 338:	75 13                	jne    34d <printf+0x110>
          s = "(null)";
 33a:	be d0 03 00 00       	mov    $0x3d0,%esi
 33f:	eb 0c                	jmp    34d <printf+0x110>
          putc(fd, *s);
 341:	0f be d2             	movsbl %dl,%edx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	e8 62 fe ff ff       	call   1ae <putc>
          s++;
 34c:	46                   	inc    %esi
        while(*s != 0){
 34d:	8a 16                	mov    (%esi),%dl
 34f:	84 d2                	test   %dl,%dl
 351:	75 ee                	jne    341 <printf+0x104>
      state = 0;
 353:	be 00 00 00 00       	mov    $0x0,%esi
 358:	e9 10 ff ff ff       	jmp    26d <printf+0x30>
        putc(fd, *ap);
 35d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 360:	0f be 17             	movsbl (%edi),%edx
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	e8 43 fe ff ff       	call   1ae <putc>
        ap++;
 36b:	83 c7 04             	add    $0x4,%edi
 36e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 371:	be 00 00 00 00       	mov    $0x0,%esi
 376:	e9 f2 fe ff ff       	jmp    26d <printf+0x30>
        putc(fd, c);
 37b:	89 fa                	mov    %edi,%edx
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	e8 29 fe ff ff       	call   1ae <putc>
      state = 0;
 385:	be 00 00 00 00       	mov    $0x0,%esi
 38a:	e9 de fe ff ff       	jmp    26d <printf+0x30>
    }
  }
}
 38f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 392:	5b                   	pop    %ebx
 393:	5e                   	pop    %esi
 394:	5f                   	pop    %edi
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
