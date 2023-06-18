
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
  14:	68 20 05 00 00       	push   $0x520
  19:	56                   	push   %esi
  1a:	e8 20 01 00 00       	call   13f <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 32                	jle    5a <cat+0x5a>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 20 05 00 00       	push   $0x520
  31:	6a 01                	push   $0x1
  33:	e8 0f 01 00 00       	call   147 <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 c0 03 00 00       	push   $0x3c0
  47:	6a 01                	push   $0x1
  49:	e8 18 02 00 00       	call   266 <printf>
      exit(0);
  4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  55:	e8 cd 00 00 00       	call   127 <exit>
    }
  }
  if(n < 0){
  5a:	78 07                	js     63 <cat+0x63>
    printf(1, "cat: read error\n");
    exit(0);
  }
}
  5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  5f:	5b                   	pop    %ebx
  60:	5e                   	pop    %esi
  61:	5d                   	pop    %ebp
  62:	c3                   	ret    
    printf(1, "cat: read error\n");
  63:	83 ec 08             	sub    $0x8,%esp
  66:	68 d2 03 00 00       	push   $0x3d2
  6b:	6a 01                	push   $0x1
  6d:	e8 f4 01 00 00       	call   266 <printf>
    exit(0);
  72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  79:	e8 a9 00 00 00       	call   127 <exit>

0000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	f3 0f 1e fb          	endbr32 
  82:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  86:	83 e4 f0             	and    $0xfffffff0,%esp
  89:	ff 71 fc             	pushl  -0x4(%ecx)
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	57                   	push   %edi
  90:	56                   	push   %esi
  91:	53                   	push   %ebx
  92:	51                   	push   %ecx
  93:	83 ec 18             	sub    $0x18,%esp
  96:	8b 01                	mov    (%ecx),%eax
  98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  9b:	8b 51 04             	mov    0x4(%ecx),%edx
  9e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  a1:	83 f8 01             	cmp    $0x1,%eax
  a4:	7e 3c                	jle    e2 <main+0x64>
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
  a6:	be 01 00 00 00       	mov    $0x1,%esi
  ab:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  ae:	7d 65                	jge    115 <main+0x97>
    if((fd = open(argv[i], 0)) < 0){
  b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b3:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	6a 00                	push   $0x0
  bb:	ff 37                	pushl  (%edi)
  bd:	e8 a5 00 00 00       	call   167 <open>
  c2:	89 c3                	mov    %eax,%ebx
  c4:	83 c4 10             	add    $0x10,%esp
  c7:	85 c0                	test   %eax,%eax
  c9:	78 2d                	js     f8 <main+0x7a>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit(0);
    }
    cat(fd);
  cb:	83 ec 0c             	sub    $0xc,%esp
  ce:	50                   	push   %eax
  cf:	e8 2c ff ff ff       	call   0 <cat>
    close(fd);
  d4:	89 1c 24             	mov    %ebx,(%esp)
  d7:	e8 73 00 00 00       	call   14f <close>
  for(i = 1; i < argc; i++){
  dc:	46                   	inc    %esi
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	eb c9                	jmp    ab <main+0x2d>
    cat(0);
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	6a 00                	push   $0x0
  e7:	e8 14 ff ff ff       	call   0 <cat>
    exit(0);
  ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f3:	e8 2f 00 00 00       	call   127 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  f8:	83 ec 04             	sub    $0x4,%esp
  fb:	ff 37                	pushl  (%edi)
  fd:	68 e3 03 00 00       	push   $0x3e3
 102:	6a 01                	push   $0x1
 104:	e8 5d 01 00 00       	call   266 <printf>
      exit(0);
 109:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 110:	e8 12 00 00 00       	call   127 <exit>
  }
  exit(0);
 115:	83 ec 0c             	sub    $0xc,%esp
 118:	6a 00                	push   $0x0
 11a:	e8 08 00 00 00       	call   127 <exit>

0000011f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 11f:	b8 01 00 00 00       	mov    $0x1,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <exit>:
SYSCALL(exit)
 127:	b8 02 00 00 00       	mov    $0x2,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <wait>:
SYSCALL(wait)
 12f:	b8 03 00 00 00       	mov    $0x3,%eax
 134:	cd 40                	int    $0x40
 136:	c3                   	ret    

00000137 <pipe>:
SYSCALL(pipe)
 137:	b8 04 00 00 00       	mov    $0x4,%eax
 13c:	cd 40                	int    $0x40
 13e:	c3                   	ret    

0000013f <read>:
SYSCALL(read)
 13f:	b8 05 00 00 00       	mov    $0x5,%eax
 144:	cd 40                	int    $0x40
 146:	c3                   	ret    

00000147 <write>:
SYSCALL(write)
 147:	b8 10 00 00 00       	mov    $0x10,%eax
 14c:	cd 40                	int    $0x40
 14e:	c3                   	ret    

0000014f <close>:
SYSCALL(close)
 14f:	b8 15 00 00 00       	mov    $0x15,%eax
 154:	cd 40                	int    $0x40
 156:	c3                   	ret    

00000157 <kill>:
SYSCALL(kill)
 157:	b8 06 00 00 00       	mov    $0x6,%eax
 15c:	cd 40                	int    $0x40
 15e:	c3                   	ret    

0000015f <exec>:
SYSCALL(exec)
 15f:	b8 07 00 00 00       	mov    $0x7,%eax
 164:	cd 40                	int    $0x40
 166:	c3                   	ret    

00000167 <open>:
SYSCALL(open)
 167:	b8 0f 00 00 00       	mov    $0xf,%eax
 16c:	cd 40                	int    $0x40
 16e:	c3                   	ret    

0000016f <mknod>:
SYSCALL(mknod)
 16f:	b8 11 00 00 00       	mov    $0x11,%eax
 174:	cd 40                	int    $0x40
 176:	c3                   	ret    

00000177 <unlink>:
SYSCALL(unlink)
 177:	b8 12 00 00 00       	mov    $0x12,%eax
 17c:	cd 40                	int    $0x40
 17e:	c3                   	ret    

0000017f <fstat>:
SYSCALL(fstat)
 17f:	b8 08 00 00 00       	mov    $0x8,%eax
 184:	cd 40                	int    $0x40
 186:	c3                   	ret    

00000187 <link>:
SYSCALL(link)
 187:	b8 13 00 00 00       	mov    $0x13,%eax
 18c:	cd 40                	int    $0x40
 18e:	c3                   	ret    

0000018f <mkdir>:
SYSCALL(mkdir)
 18f:	b8 14 00 00 00       	mov    $0x14,%eax
 194:	cd 40                	int    $0x40
 196:	c3                   	ret    

00000197 <chdir>:
SYSCALL(chdir)
 197:	b8 09 00 00 00       	mov    $0x9,%eax
 19c:	cd 40                	int    $0x40
 19e:	c3                   	ret    

0000019f <dup>:
SYSCALL(dup)
 19f:	b8 0a 00 00 00       	mov    $0xa,%eax
 1a4:	cd 40                	int    $0x40
 1a6:	c3                   	ret    

000001a7 <getpid>:
SYSCALL(getpid)
 1a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 1ac:	cd 40                	int    $0x40
 1ae:	c3                   	ret    

000001af <sbrk>:
SYSCALL(sbrk)
 1af:	b8 0c 00 00 00       	mov    $0xc,%eax
 1b4:	cd 40                	int    $0x40
 1b6:	c3                   	ret    

000001b7 <sleep>:
SYSCALL(sleep)
 1b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 1bc:	cd 40                	int    $0x40
 1be:	c3                   	ret    

000001bf <uptime>:
SYSCALL(uptime)
 1bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 1c4:	cd 40                	int    $0x40
 1c6:	c3                   	ret    

000001c7 <date>:
SYSCALL(date)
 1c7:	b8 16 00 00 00       	mov    $0x16,%eax
 1cc:	cd 40                	int    $0x40
 1ce:	c3                   	ret    

000001cf <dup2>:
 1cf:	b8 17 00 00 00       	mov    $0x17,%eax
 1d4:	cd 40                	int    $0x40
 1d6:	c3                   	ret    

000001d7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 1c             	sub    $0x1c,%esp
 1dd:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1e0:	6a 01                	push   $0x1
 1e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1e5:	52                   	push   %edx
 1e6:	50                   	push   %eax
 1e7:	e8 5b ff ff ff       	call   147 <write>
}
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	57                   	push   %edi
 1f5:	56                   	push   %esi
 1f6:	53                   	push   %ebx
 1f7:	83 ec 2c             	sub    $0x2c,%esp
 1fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1fd:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 203:	74 04                	je     209 <printint+0x18>
 205:	85 d2                	test   %edx,%edx
 207:	78 3a                	js     243 <printint+0x52>
  neg = 0;
 209:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 210:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 215:	89 f0                	mov    %esi,%eax
 217:	ba 00 00 00 00       	mov    $0x0,%edx
 21c:	f7 f1                	div    %ecx
 21e:	89 df                	mov    %ebx,%edi
 220:	43                   	inc    %ebx
 221:	8a 92 00 04 00 00    	mov    0x400(%edx),%dl
 227:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 22b:	89 f2                	mov    %esi,%edx
 22d:	89 c6                	mov    %eax,%esi
 22f:	39 d1                	cmp    %edx,%ecx
 231:	76 e2                	jbe    215 <printint+0x24>
  if(neg)
 233:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 237:	74 22                	je     25b <printint+0x6a>
    buf[i++] = '-';
 239:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 23e:	8d 5f 02             	lea    0x2(%edi),%ebx
 241:	eb 18                	jmp    25b <printint+0x6a>
    x = -xx;
 243:	f7 de                	neg    %esi
    neg = 1;
 245:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 24c:	eb c2                	jmp    210 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 24e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 256:	e8 7c ff ff ff       	call   1d7 <putc>
  while(--i >= 0)
 25b:	4b                   	dec    %ebx
 25c:	79 f0                	jns    24e <printint+0x5d>
}
 25e:	83 c4 2c             	add    $0x2c,%esp
 261:	5b                   	pop    %ebx
 262:	5e                   	pop    %esi
 263:	5f                   	pop    %edi
 264:	5d                   	pop    %ebp
 265:	c3                   	ret    

00000266 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 266:	f3 0f 1e fb          	endbr32 
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	57                   	push   %edi
 26e:	56                   	push   %esi
 26f:	53                   	push   %ebx
 270:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 273:	8d 45 10             	lea    0x10(%ebp),%eax
 276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 279:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 27e:	bb 00 00 00 00       	mov    $0x0,%ebx
 283:	eb 12                	jmp    297 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 285:	89 fa                	mov    %edi,%edx
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	e8 48 ff ff ff       	call   1d7 <putc>
 28f:	eb 05                	jmp    296 <printf+0x30>
      }
    } else if(state == '%'){
 291:	83 fe 25             	cmp    $0x25,%esi
 294:	74 22                	je     2b8 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 296:	43                   	inc    %ebx
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	8a 04 18             	mov    (%eax,%ebx,1),%al
 29d:	84 c0                	test   %al,%al
 29f:	0f 84 13 01 00 00    	je     3b8 <printf+0x152>
    c = fmt[i] & 0xff;
 2a5:	0f be f8             	movsbl %al,%edi
 2a8:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2ab:	85 f6                	test   %esi,%esi
 2ad:	75 e2                	jne    291 <printf+0x2b>
      if(c == '%'){
 2af:	83 f8 25             	cmp    $0x25,%eax
 2b2:	75 d1                	jne    285 <printf+0x1f>
        state = '%';
 2b4:	89 c6                	mov    %eax,%esi
 2b6:	eb de                	jmp    296 <printf+0x30>
      if(c == 'd'){
 2b8:	83 f8 64             	cmp    $0x64,%eax
 2bb:	74 43                	je     300 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 2bd:	83 f8 78             	cmp    $0x78,%eax
 2c0:	74 68                	je     32a <printf+0xc4>
 2c2:	83 f8 70             	cmp    $0x70,%eax
 2c5:	74 63                	je     32a <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 2c7:	83 f8 73             	cmp    $0x73,%eax
 2ca:	0f 84 84 00 00 00    	je     354 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2d0:	83 f8 63             	cmp    $0x63,%eax
 2d3:	0f 84 ad 00 00 00    	je     386 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2d9:	83 f8 25             	cmp    $0x25,%eax
 2dc:	0f 84 c2 00 00 00    	je     3a4 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2e2:	ba 25 00 00 00       	mov    $0x25,%edx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	e8 e8 fe ff ff       	call   1d7 <putc>
        putc(fd, c);
 2ef:	89 fa                	mov    %edi,%edx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	e8 de fe ff ff       	call   1d7 <putc>
      }
      state = 0;
 2f9:	be 00 00 00 00       	mov    $0x0,%esi
 2fe:	eb 96                	jmp    296 <printf+0x30>
        printint(fd, *ap, 10, 1);
 300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 303:	8b 17                	mov    (%edi),%edx
 305:	83 ec 0c             	sub    $0xc,%esp
 308:	6a 01                	push   $0x1
 30a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	e8 da fe ff ff       	call   1f1 <printint>
        ap++;
 317:	83 c7 04             	add    $0x4,%edi
 31a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 31d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 320:	be 00 00 00 00       	mov    $0x0,%esi
 325:	e9 6c ff ff ff       	jmp    296 <printf+0x30>
        printint(fd, *ap, 16, 0);
 32a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 32d:	8b 17                	mov    (%edi),%edx
 32f:	83 ec 0c             	sub    $0xc,%esp
 332:	6a 00                	push   $0x0
 334:	b9 10 00 00 00       	mov    $0x10,%ecx
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	e8 b0 fe ff ff       	call   1f1 <printint>
        ap++;
 341:	83 c7 04             	add    $0x4,%edi
 344:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 347:	83 c4 10             	add    $0x10,%esp
      state = 0;
 34a:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 34f:	e9 42 ff ff ff       	jmp    296 <printf+0x30>
        s = (char*)*ap;
 354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 357:	8b 30                	mov    (%eax),%esi
        ap++;
 359:	83 c0 04             	add    $0x4,%eax
 35c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 35f:	85 f6                	test   %esi,%esi
 361:	75 13                	jne    376 <printf+0x110>
          s = "(null)";
 363:	be f8 03 00 00       	mov    $0x3f8,%esi
 368:	eb 0c                	jmp    376 <printf+0x110>
          putc(fd, *s);
 36a:	0f be d2             	movsbl %dl,%edx
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	e8 62 fe ff ff       	call   1d7 <putc>
          s++;
 375:	46                   	inc    %esi
        while(*s != 0){
 376:	8a 16                	mov    (%esi),%dl
 378:	84 d2                	test   %dl,%dl
 37a:	75 ee                	jne    36a <printf+0x104>
      state = 0;
 37c:	be 00 00 00 00       	mov    $0x0,%esi
 381:	e9 10 ff ff ff       	jmp    296 <printf+0x30>
        putc(fd, *ap);
 386:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 389:	0f be 17             	movsbl (%edi),%edx
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	e8 43 fe ff ff       	call   1d7 <putc>
        ap++;
 394:	83 c7 04             	add    $0x4,%edi
 397:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 39a:	be 00 00 00 00       	mov    $0x0,%esi
 39f:	e9 f2 fe ff ff       	jmp    296 <printf+0x30>
        putc(fd, c);
 3a4:	89 fa                	mov    %edi,%edx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	e8 29 fe ff ff       	call   1d7 <putc>
      state = 0;
 3ae:	be 00 00 00 00       	mov    $0x0,%esi
 3b3:	e9 de fe ff ff       	jmp    296 <printf+0x30>
    }
  }
}
 3b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bb:	5b                   	pop    %ebx
 3bc:	5e                   	pop    %esi
 3bd:	5f                   	pop    %edi
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    
