
rm:     formato del fichero elf32-i386


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
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 01                	mov    (%ecx),%eax
  1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1d:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	7e 21                	jle    46 <main+0x46>
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  25:	bb 01 00 00 00       	mov    $0x1,%ebx
  2a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  2d:	7d 3f                	jge    6e <main+0x6e>
    if(unlink(argv[i]) < 0){
  2f:	8d 34 9f             	lea    (%edi,%ebx,4),%esi
  32:	83 ec 0c             	sub    $0xc,%esp
  35:	ff 36                	pushl  (%esi)
  37:	e8 8f 00 00 00       	call   cb <unlink>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	85 c0                	test   %eax,%eax
  41:	78 17                	js     5a <main+0x5a>
  for(i = 1; i < argc; i++){
  43:	43                   	inc    %ebx
  44:	eb e4                	jmp    2a <main+0x2a>
    printf(2, "Usage: rm files...\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 04 03 00 00       	push   $0x304
  4e:	6a 02                	push   $0x2
  50:	e8 55 01 00 00       	call   1aa <printf>
    exit();
  55:	e8 21 00 00 00       	call   7b <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	ff 36                	pushl  (%esi)
  5f:	68 18 03 00 00       	push   $0x318
  64:	6a 02                	push   $0x2
  66:	e8 3f 01 00 00       	call   1aa <printf>
      break;
  6b:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  6e:	e8 08 00 00 00       	call   7b <exit>

00000073 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  73:	b8 01 00 00 00       	mov    $0x1,%eax
  78:	cd 40                	int    $0x40
  7a:	c3                   	ret    

0000007b <exit>:
SYSCALL(exit)
  7b:	b8 02 00 00 00       	mov    $0x2,%eax
  80:	cd 40                	int    $0x40
  82:	c3                   	ret    

00000083 <wait>:
SYSCALL(wait)
  83:	b8 03 00 00 00       	mov    $0x3,%eax
  88:	cd 40                	int    $0x40
  8a:	c3                   	ret    

0000008b <pipe>:
SYSCALL(pipe)
  8b:	b8 04 00 00 00       	mov    $0x4,%eax
  90:	cd 40                	int    $0x40
  92:	c3                   	ret    

00000093 <read>:
SYSCALL(read)
  93:	b8 05 00 00 00       	mov    $0x5,%eax
  98:	cd 40                	int    $0x40
  9a:	c3                   	ret    

0000009b <write>:
SYSCALL(write)
  9b:	b8 10 00 00 00       	mov    $0x10,%eax
  a0:	cd 40                	int    $0x40
  a2:	c3                   	ret    

000000a3 <close>:
SYSCALL(close)
  a3:	b8 15 00 00 00       	mov    $0x15,%eax
  a8:	cd 40                	int    $0x40
  aa:	c3                   	ret    

000000ab <kill>:
SYSCALL(kill)
  ab:	b8 06 00 00 00       	mov    $0x6,%eax
  b0:	cd 40                	int    $0x40
  b2:	c3                   	ret    

000000b3 <exec>:
SYSCALL(exec)
  b3:	b8 07 00 00 00       	mov    $0x7,%eax
  b8:	cd 40                	int    $0x40
  ba:	c3                   	ret    

000000bb <open>:
SYSCALL(open)
  bb:	b8 0f 00 00 00       	mov    $0xf,%eax
  c0:	cd 40                	int    $0x40
  c2:	c3                   	ret    

000000c3 <mknod>:
SYSCALL(mknod)
  c3:	b8 11 00 00 00       	mov    $0x11,%eax
  c8:	cd 40                	int    $0x40
  ca:	c3                   	ret    

000000cb <unlink>:
SYSCALL(unlink)
  cb:	b8 12 00 00 00       	mov    $0x12,%eax
  d0:	cd 40                	int    $0x40
  d2:	c3                   	ret    

000000d3 <fstat>:
SYSCALL(fstat)
  d3:	b8 08 00 00 00       	mov    $0x8,%eax
  d8:	cd 40                	int    $0x40
  da:	c3                   	ret    

000000db <link>:
SYSCALL(link)
  db:	b8 13 00 00 00       	mov    $0x13,%eax
  e0:	cd 40                	int    $0x40
  e2:	c3                   	ret    

000000e3 <mkdir>:
SYSCALL(mkdir)
  e3:	b8 14 00 00 00       	mov    $0x14,%eax
  e8:	cd 40                	int    $0x40
  ea:	c3                   	ret    

000000eb <chdir>:
SYSCALL(chdir)
  eb:	b8 09 00 00 00       	mov    $0x9,%eax
  f0:	cd 40                	int    $0x40
  f2:	c3                   	ret    

000000f3 <dup>:
SYSCALL(dup)
  f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  f8:	cd 40                	int    $0x40
  fa:	c3                   	ret    

000000fb <getpid>:
SYSCALL(getpid)
  fb:	b8 0b 00 00 00       	mov    $0xb,%eax
 100:	cd 40                	int    $0x40
 102:	c3                   	ret    

00000103 <sbrk>:
SYSCALL(sbrk)
 103:	b8 0c 00 00 00       	mov    $0xc,%eax
 108:	cd 40                	int    $0x40
 10a:	c3                   	ret    

0000010b <sleep>:
SYSCALL(sleep)
 10b:	b8 0d 00 00 00       	mov    $0xd,%eax
 110:	cd 40                	int    $0x40
 112:	c3                   	ret    

00000113 <uptime>:
SYSCALL(uptime)
 113:	b8 0e 00 00 00       	mov    $0xe,%eax
 118:	cd 40                	int    $0x40
 11a:	c3                   	ret    

0000011b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	83 ec 1c             	sub    $0x1c,%esp
 121:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 124:	6a 01                	push   $0x1
 126:	8d 55 f4             	lea    -0xc(%ebp),%edx
 129:	52                   	push   %edx
 12a:	50                   	push   %eax
 12b:	e8 6b ff ff ff       	call   9b <write>
}
 130:	83 c4 10             	add    $0x10,%esp
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	57                   	push   %edi
 139:	56                   	push   %esi
 13a:	53                   	push   %ebx
 13b:	83 ec 2c             	sub    $0x2c,%esp
 13e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 141:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 147:	74 04                	je     14d <printint+0x18>
 149:	85 d2                	test   %edx,%edx
 14b:	78 3a                	js     187 <printint+0x52>
  neg = 0;
 14d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 154:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 159:	89 f0                	mov    %esi,%eax
 15b:	ba 00 00 00 00       	mov    $0x0,%edx
 160:	f7 f1                	div    %ecx
 162:	89 df                	mov    %ebx,%edi
 164:	43                   	inc    %ebx
 165:	8a 92 38 03 00 00    	mov    0x338(%edx),%dl
 16b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 16f:	89 f2                	mov    %esi,%edx
 171:	89 c6                	mov    %eax,%esi
 173:	39 d1                	cmp    %edx,%ecx
 175:	76 e2                	jbe    159 <printint+0x24>
  if(neg)
 177:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 17b:	74 22                	je     19f <printint+0x6a>
    buf[i++] = '-';
 17d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 182:	8d 5f 02             	lea    0x2(%edi),%ebx
 185:	eb 18                	jmp    19f <printint+0x6a>
    x = -xx;
 187:	f7 de                	neg    %esi
    neg = 1;
 189:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 190:	eb c2                	jmp    154 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 192:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 197:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 19a:	e8 7c ff ff ff       	call   11b <putc>
  while(--i >= 0)
 19f:	4b                   	dec    %ebx
 1a0:	79 f0                	jns    192 <printint+0x5d>
}
 1a2:	83 c4 2c             	add    $0x2c,%esp
 1a5:	5b                   	pop    %ebx
 1a6:	5e                   	pop    %esi
 1a7:	5f                   	pop    %edi
 1a8:	5d                   	pop    %ebp
 1a9:	c3                   	ret    

000001aa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1aa:	f3 0f 1e fb          	endbr32 
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	57                   	push   %edi
 1b2:	56                   	push   %esi
 1b3:	53                   	push   %ebx
 1b4:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1b7:	8d 45 10             	lea    0x10(%ebp),%eax
 1ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1bd:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1c2:	bb 00 00 00 00       	mov    $0x0,%ebx
 1c7:	eb 12                	jmp    1db <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1c9:	89 fa                	mov    %edi,%edx
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	e8 48 ff ff ff       	call   11b <putc>
 1d3:	eb 05                	jmp    1da <printf+0x30>
      }
    } else if(state == '%'){
 1d5:	83 fe 25             	cmp    $0x25,%esi
 1d8:	74 22                	je     1fc <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1da:	43                   	inc    %ebx
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
 1de:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1e1:	84 c0                	test   %al,%al
 1e3:	0f 84 13 01 00 00    	je     2fc <printf+0x152>
    c = fmt[i] & 0xff;
 1e9:	0f be f8             	movsbl %al,%edi
 1ec:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1ef:	85 f6                	test   %esi,%esi
 1f1:	75 e2                	jne    1d5 <printf+0x2b>
      if(c == '%'){
 1f3:	83 f8 25             	cmp    $0x25,%eax
 1f6:	75 d1                	jne    1c9 <printf+0x1f>
        state = '%';
 1f8:	89 c6                	mov    %eax,%esi
 1fa:	eb de                	jmp    1da <printf+0x30>
      if(c == 'd'){
 1fc:	83 f8 64             	cmp    $0x64,%eax
 1ff:	74 43                	je     244 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 201:	83 f8 78             	cmp    $0x78,%eax
 204:	74 68                	je     26e <printf+0xc4>
 206:	83 f8 70             	cmp    $0x70,%eax
 209:	74 63                	je     26e <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 20b:	83 f8 73             	cmp    $0x73,%eax
 20e:	0f 84 84 00 00 00    	je     298 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 214:	83 f8 63             	cmp    $0x63,%eax
 217:	0f 84 ad 00 00 00    	je     2ca <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 21d:	83 f8 25             	cmp    $0x25,%eax
 220:	0f 84 c2 00 00 00    	je     2e8 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 226:	ba 25 00 00 00       	mov    $0x25,%edx
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	e8 e8 fe ff ff       	call   11b <putc>
        putc(fd, c);
 233:	89 fa                	mov    %edi,%edx
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	e8 de fe ff ff       	call   11b <putc>
      }
      state = 0;
 23d:	be 00 00 00 00       	mov    $0x0,%esi
 242:	eb 96                	jmp    1da <printf+0x30>
        printint(fd, *ap, 10, 1);
 244:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 247:	8b 17                	mov    (%edi),%edx
 249:	83 ec 0c             	sub    $0xc,%esp
 24c:	6a 01                	push   $0x1
 24e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	e8 da fe ff ff       	call   135 <printint>
        ap++;
 25b:	83 c7 04             	add    $0x4,%edi
 25e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 261:	83 c4 10             	add    $0x10,%esp
      state = 0;
 264:	be 00 00 00 00       	mov    $0x0,%esi
 269:	e9 6c ff ff ff       	jmp    1da <printf+0x30>
        printint(fd, *ap, 16, 0);
 26e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 271:	8b 17                	mov    (%edi),%edx
 273:	83 ec 0c             	sub    $0xc,%esp
 276:	6a 00                	push   $0x0
 278:	b9 10 00 00 00       	mov    $0x10,%ecx
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	e8 b0 fe ff ff       	call   135 <printint>
        ap++;
 285:	83 c7 04             	add    $0x4,%edi
 288:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 28b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 28e:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 293:	e9 42 ff ff ff       	jmp    1da <printf+0x30>
        s = (char*)*ap;
 298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 29b:	8b 30                	mov    (%eax),%esi
        ap++;
 29d:	83 c0 04             	add    $0x4,%eax
 2a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2a3:	85 f6                	test   %esi,%esi
 2a5:	75 13                	jne    2ba <printf+0x110>
          s = "(null)";
 2a7:	be 31 03 00 00       	mov    $0x331,%esi
 2ac:	eb 0c                	jmp    2ba <printf+0x110>
          putc(fd, *s);
 2ae:	0f be d2             	movsbl %dl,%edx
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	e8 62 fe ff ff       	call   11b <putc>
          s++;
 2b9:	46                   	inc    %esi
        while(*s != 0){
 2ba:	8a 16                	mov    (%esi),%dl
 2bc:	84 d2                	test   %dl,%dl
 2be:	75 ee                	jne    2ae <printf+0x104>
      state = 0;
 2c0:	be 00 00 00 00       	mov    $0x0,%esi
 2c5:	e9 10 ff ff ff       	jmp    1da <printf+0x30>
        putc(fd, *ap);
 2ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2cd:	0f be 17             	movsbl (%edi),%edx
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	e8 43 fe ff ff       	call   11b <putc>
        ap++;
 2d8:	83 c7 04             	add    $0x4,%edi
 2db:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2de:	be 00 00 00 00       	mov    $0x0,%esi
 2e3:	e9 f2 fe ff ff       	jmp    1da <printf+0x30>
        putc(fd, c);
 2e8:	89 fa                	mov    %edi,%edx
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	e8 29 fe ff ff       	call   11b <putc>
      state = 0;
 2f2:	be 00 00 00 00       	mov    $0x0,%esi
 2f7:	e9 de fe ff ff       	jmp    1da <printf+0x30>
    }
  }
}
 2fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    
