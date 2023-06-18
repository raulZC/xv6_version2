
ln:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
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
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  16:	83 39 03             	cmpl   $0x3,(%ecx)
  19:	74 1b                	je     36 <main+0x36>
    printf(2, "Usage: ln old new\n");
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	68 10 03 00 00       	push   $0x310
  23:	6a 02                	push   $0x2
  25:	e8 89 01 00 00       	call   1b3 <printf>
    exit(0);
  2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  31:	e8 3e 00 00 00       	call   74 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  36:	83 ec 08             	sub    $0x8,%esp
  39:	ff 73 08             	pushl  0x8(%ebx)
  3c:	ff 73 04             	pushl  0x4(%ebx)
  3f:	e8 90 00 00 00       	call   d4 <link>
  44:	83 c4 10             	add    $0x10,%esp
  47:	85 c0                	test   %eax,%eax
  49:	78 0a                	js     55 <main+0x55>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  4b:	83 ec 0c             	sub    $0xc,%esp
  4e:	6a 00                	push   $0x0
  50:	e8 1f 00 00 00       	call   74 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  55:	ff 73 08             	pushl  0x8(%ebx)
  58:	ff 73 04             	pushl  0x4(%ebx)
  5b:	68 23 03 00 00       	push   $0x323
  60:	6a 02                	push   $0x2
  62:	e8 4c 01 00 00       	call   1b3 <printf>
  67:	83 c4 10             	add    $0x10,%esp
  6a:	eb df                	jmp    4b <main+0x4b>

0000006c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  6c:	b8 01 00 00 00       	mov    $0x1,%eax
  71:	cd 40                	int    $0x40
  73:	c3                   	ret    

00000074 <exit>:
SYSCALL(exit)
  74:	b8 02 00 00 00       	mov    $0x2,%eax
  79:	cd 40                	int    $0x40
  7b:	c3                   	ret    

0000007c <wait>:
SYSCALL(wait)
  7c:	b8 03 00 00 00       	mov    $0x3,%eax
  81:	cd 40                	int    $0x40
  83:	c3                   	ret    

00000084 <pipe>:
SYSCALL(pipe)
  84:	b8 04 00 00 00       	mov    $0x4,%eax
  89:	cd 40                	int    $0x40
  8b:	c3                   	ret    

0000008c <read>:
SYSCALL(read)
  8c:	b8 05 00 00 00       	mov    $0x5,%eax
  91:	cd 40                	int    $0x40
  93:	c3                   	ret    

00000094 <write>:
SYSCALL(write)
  94:	b8 10 00 00 00       	mov    $0x10,%eax
  99:	cd 40                	int    $0x40
  9b:	c3                   	ret    

0000009c <close>:
SYSCALL(close)
  9c:	b8 15 00 00 00       	mov    $0x15,%eax
  a1:	cd 40                	int    $0x40
  a3:	c3                   	ret    

000000a4 <kill>:
SYSCALL(kill)
  a4:	b8 06 00 00 00       	mov    $0x6,%eax
  a9:	cd 40                	int    $0x40
  ab:	c3                   	ret    

000000ac <exec>:
SYSCALL(exec)
  ac:	b8 07 00 00 00       	mov    $0x7,%eax
  b1:	cd 40                	int    $0x40
  b3:	c3                   	ret    

000000b4 <open>:
SYSCALL(open)
  b4:	b8 0f 00 00 00       	mov    $0xf,%eax
  b9:	cd 40                	int    $0x40
  bb:	c3                   	ret    

000000bc <mknod>:
SYSCALL(mknod)
  bc:	b8 11 00 00 00       	mov    $0x11,%eax
  c1:	cd 40                	int    $0x40
  c3:	c3                   	ret    

000000c4 <unlink>:
SYSCALL(unlink)
  c4:	b8 12 00 00 00       	mov    $0x12,%eax
  c9:	cd 40                	int    $0x40
  cb:	c3                   	ret    

000000cc <fstat>:
SYSCALL(fstat)
  cc:	b8 08 00 00 00       	mov    $0x8,%eax
  d1:	cd 40                	int    $0x40
  d3:	c3                   	ret    

000000d4 <link>:
SYSCALL(link)
  d4:	b8 13 00 00 00       	mov    $0x13,%eax
  d9:	cd 40                	int    $0x40
  db:	c3                   	ret    

000000dc <mkdir>:
SYSCALL(mkdir)
  dc:	b8 14 00 00 00       	mov    $0x14,%eax
  e1:	cd 40                	int    $0x40
  e3:	c3                   	ret    

000000e4 <chdir>:
SYSCALL(chdir)
  e4:	b8 09 00 00 00       	mov    $0x9,%eax
  e9:	cd 40                	int    $0x40
  eb:	c3                   	ret    

000000ec <dup>:
SYSCALL(dup)
  ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  f1:	cd 40                	int    $0x40
  f3:	c3                   	ret    

000000f4 <getpid>:
SYSCALL(getpid)
  f4:	b8 0b 00 00 00       	mov    $0xb,%eax
  f9:	cd 40                	int    $0x40
  fb:	c3                   	ret    

000000fc <sbrk>:
SYSCALL(sbrk)
  fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 101:	cd 40                	int    $0x40
 103:	c3                   	ret    

00000104 <sleep>:
SYSCALL(sleep)
 104:	b8 0d 00 00 00       	mov    $0xd,%eax
 109:	cd 40                	int    $0x40
 10b:	c3                   	ret    

0000010c <uptime>:
SYSCALL(uptime)
 10c:	b8 0e 00 00 00       	mov    $0xe,%eax
 111:	cd 40                	int    $0x40
 113:	c3                   	ret    

00000114 <date>:
SYSCALL(date)
 114:	b8 16 00 00 00       	mov    $0x16,%eax
 119:	cd 40                	int    $0x40
 11b:	c3                   	ret    

0000011c <dup2>:
 11c:	b8 17 00 00 00       	mov    $0x17,%eax
 121:	cd 40                	int    $0x40
 123:	c3                   	ret    

00000124 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 1c             	sub    $0x1c,%esp
 12a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 12d:	6a 01                	push   $0x1
 12f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 132:	52                   	push   %edx
 133:	50                   	push   %eax
 134:	e8 5b ff ff ff       	call   94 <write>
}
 139:	83 c4 10             	add    $0x10,%esp
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	57                   	push   %edi
 142:	56                   	push   %esi
 143:	53                   	push   %ebx
 144:	83 ec 2c             	sub    $0x2c,%esp
 147:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 14a:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 14c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 150:	74 04                	je     156 <printint+0x18>
 152:	85 d2                	test   %edx,%edx
 154:	78 3a                	js     190 <printint+0x52>
  neg = 0;
 156:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 15d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 162:	89 f0                	mov    %esi,%eax
 164:	ba 00 00 00 00       	mov    $0x0,%edx
 169:	f7 f1                	div    %ecx
 16b:	89 df                	mov    %ebx,%edi
 16d:	43                   	inc    %ebx
 16e:	8a 92 40 03 00 00    	mov    0x340(%edx),%dl
 174:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 178:	89 f2                	mov    %esi,%edx
 17a:	89 c6                	mov    %eax,%esi
 17c:	39 d1                	cmp    %edx,%ecx
 17e:	76 e2                	jbe    162 <printint+0x24>
  if(neg)
 180:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 184:	74 22                	je     1a8 <printint+0x6a>
    buf[i++] = '-';
 186:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 18b:	8d 5f 02             	lea    0x2(%edi),%ebx
 18e:	eb 18                	jmp    1a8 <printint+0x6a>
    x = -xx;
 190:	f7 de                	neg    %esi
    neg = 1;
 192:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 199:	eb c2                	jmp    15d <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 19b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1a3:	e8 7c ff ff ff       	call   124 <putc>
  while(--i >= 0)
 1a8:	4b                   	dec    %ebx
 1a9:	79 f0                	jns    19b <printint+0x5d>
}
 1ab:	83 c4 2c             	add    $0x2c,%esp
 1ae:	5b                   	pop    %ebx
 1af:	5e                   	pop    %esi
 1b0:	5f                   	pop    %edi
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    

000001b3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1b3:	f3 0f 1e fb          	endbr32 
 1b7:	55                   	push   %ebp
 1b8:	89 e5                	mov    %esp,%ebp
 1ba:	57                   	push   %edi
 1bb:	56                   	push   %esi
 1bc:	53                   	push   %ebx
 1bd:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1c0:	8d 45 10             	lea    0x10(%ebp),%eax
 1c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1c6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1cb:	bb 00 00 00 00       	mov    $0x0,%ebx
 1d0:	eb 12                	jmp    1e4 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1d2:	89 fa                	mov    %edi,%edx
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	e8 48 ff ff ff       	call   124 <putc>
 1dc:	eb 05                	jmp    1e3 <printf+0x30>
      }
    } else if(state == '%'){
 1de:	83 fe 25             	cmp    $0x25,%esi
 1e1:	74 22                	je     205 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1e3:	43                   	inc    %ebx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1ea:	84 c0                	test   %al,%al
 1ec:	0f 84 13 01 00 00    	je     305 <printf+0x152>
    c = fmt[i] & 0xff;
 1f2:	0f be f8             	movsbl %al,%edi
 1f5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1f8:	85 f6                	test   %esi,%esi
 1fa:	75 e2                	jne    1de <printf+0x2b>
      if(c == '%'){
 1fc:	83 f8 25             	cmp    $0x25,%eax
 1ff:	75 d1                	jne    1d2 <printf+0x1f>
        state = '%';
 201:	89 c6                	mov    %eax,%esi
 203:	eb de                	jmp    1e3 <printf+0x30>
      if(c == 'd'){
 205:	83 f8 64             	cmp    $0x64,%eax
 208:	74 43                	je     24d <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 20a:	83 f8 78             	cmp    $0x78,%eax
 20d:	74 68                	je     277 <printf+0xc4>
 20f:	83 f8 70             	cmp    $0x70,%eax
 212:	74 63                	je     277 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 214:	83 f8 73             	cmp    $0x73,%eax
 217:	0f 84 84 00 00 00    	je     2a1 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 21d:	83 f8 63             	cmp    $0x63,%eax
 220:	0f 84 ad 00 00 00    	je     2d3 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 226:	83 f8 25             	cmp    $0x25,%eax
 229:	0f 84 c2 00 00 00    	je     2f1 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 22f:	ba 25 00 00 00       	mov    $0x25,%edx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	e8 e8 fe ff ff       	call   124 <putc>
        putc(fd, c);
 23c:	89 fa                	mov    %edi,%edx
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	e8 de fe ff ff       	call   124 <putc>
      }
      state = 0;
 246:	be 00 00 00 00       	mov    $0x0,%esi
 24b:	eb 96                	jmp    1e3 <printf+0x30>
        printint(fd, *ap, 10, 1);
 24d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 250:	8b 17                	mov    (%edi),%edx
 252:	83 ec 0c             	sub    $0xc,%esp
 255:	6a 01                	push   $0x1
 257:	b9 0a 00 00 00       	mov    $0xa,%ecx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	e8 da fe ff ff       	call   13e <printint>
        ap++;
 264:	83 c7 04             	add    $0x4,%edi
 267:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 26a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 26d:	be 00 00 00 00       	mov    $0x0,%esi
 272:	e9 6c ff ff ff       	jmp    1e3 <printf+0x30>
        printint(fd, *ap, 16, 0);
 277:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 27a:	8b 17                	mov    (%edi),%edx
 27c:	83 ec 0c             	sub    $0xc,%esp
 27f:	6a 00                	push   $0x0
 281:	b9 10 00 00 00       	mov    $0x10,%ecx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	e8 b0 fe ff ff       	call   13e <printint>
        ap++;
 28e:	83 c7 04             	add    $0x4,%edi
 291:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 294:	83 c4 10             	add    $0x10,%esp
      state = 0;
 297:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 29c:	e9 42 ff ff ff       	jmp    1e3 <printf+0x30>
        s = (char*)*ap;
 2a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2a4:	8b 30                	mov    (%eax),%esi
        ap++;
 2a6:	83 c0 04             	add    $0x4,%eax
 2a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2ac:	85 f6                	test   %esi,%esi
 2ae:	75 13                	jne    2c3 <printf+0x110>
          s = "(null)";
 2b0:	be 37 03 00 00       	mov    $0x337,%esi
 2b5:	eb 0c                	jmp    2c3 <printf+0x110>
          putc(fd, *s);
 2b7:	0f be d2             	movsbl %dl,%edx
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	e8 62 fe ff ff       	call   124 <putc>
          s++;
 2c2:	46                   	inc    %esi
        while(*s != 0){
 2c3:	8a 16                	mov    (%esi),%dl
 2c5:	84 d2                	test   %dl,%dl
 2c7:	75 ee                	jne    2b7 <printf+0x104>
      state = 0;
 2c9:	be 00 00 00 00       	mov    $0x0,%esi
 2ce:	e9 10 ff ff ff       	jmp    1e3 <printf+0x30>
        putc(fd, *ap);
 2d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d6:	0f be 17             	movsbl (%edi),%edx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	e8 43 fe ff ff       	call   124 <putc>
        ap++;
 2e1:	83 c7 04             	add    $0x4,%edi
 2e4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2e7:	be 00 00 00 00       	mov    $0x0,%esi
 2ec:	e9 f2 fe ff ff       	jmp    1e3 <printf+0x30>
        putc(fd, c);
 2f1:	89 fa                	mov    %edi,%edx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	e8 29 fe ff ff       	call   124 <putc>
      state = 0;
 2fb:	be 00 00 00 00       	mov    $0x0,%esi
 300:	e9 de fe ff ff       	jmp    1e3 <printf+0x30>
    }
  }
}
 305:	8d 65 f4             	lea    -0xc(%ebp),%esp
 308:	5b                   	pop    %ebx
 309:	5e                   	pop    %esi
 30a:	5f                   	pop    %edi
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    
