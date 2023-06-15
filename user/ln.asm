
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
  19:	74 14                	je     2f <main+0x2f>
    printf(2, "Usage: ln old new\n");
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	68 f4 02 00 00       	push   $0x2f4
  23:	6a 02                	push   $0x2
  25:	e8 6d 01 00 00       	call   197 <printf>
    exit();
  2a:	e8 39 00 00 00       	call   68 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	ff 73 08             	pushl  0x8(%ebx)
  35:	ff 73 04             	pushl  0x4(%ebx)
  38:	e8 8b 00 00 00       	call   c8 <link>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	85 c0                	test   %eax,%eax
  42:	78 05                	js     49 <main+0x49>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  44:	e8 1f 00 00 00       	call   68 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  49:	ff 73 08             	pushl  0x8(%ebx)
  4c:	ff 73 04             	pushl  0x4(%ebx)
  4f:	68 07 03 00 00       	push   $0x307
  54:	6a 02                	push   $0x2
  56:	e8 3c 01 00 00       	call   197 <printf>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	eb e4                	jmp    44 <main+0x44>

00000060 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  60:	b8 01 00 00 00       	mov    $0x1,%eax
  65:	cd 40                	int    $0x40
  67:	c3                   	ret    

00000068 <exit>:
SYSCALL(exit)
  68:	b8 02 00 00 00       	mov    $0x2,%eax
  6d:	cd 40                	int    $0x40
  6f:	c3                   	ret    

00000070 <wait>:
SYSCALL(wait)
  70:	b8 03 00 00 00       	mov    $0x3,%eax
  75:	cd 40                	int    $0x40
  77:	c3                   	ret    

00000078 <pipe>:
SYSCALL(pipe)
  78:	b8 04 00 00 00       	mov    $0x4,%eax
  7d:	cd 40                	int    $0x40
  7f:	c3                   	ret    

00000080 <read>:
SYSCALL(read)
  80:	b8 05 00 00 00       	mov    $0x5,%eax
  85:	cd 40                	int    $0x40
  87:	c3                   	ret    

00000088 <write>:
SYSCALL(write)
  88:	b8 10 00 00 00       	mov    $0x10,%eax
  8d:	cd 40                	int    $0x40
  8f:	c3                   	ret    

00000090 <close>:
SYSCALL(close)
  90:	b8 15 00 00 00       	mov    $0x15,%eax
  95:	cd 40                	int    $0x40
  97:	c3                   	ret    

00000098 <kill>:
SYSCALL(kill)
  98:	b8 06 00 00 00       	mov    $0x6,%eax
  9d:	cd 40                	int    $0x40
  9f:	c3                   	ret    

000000a0 <exec>:
SYSCALL(exec)
  a0:	b8 07 00 00 00       	mov    $0x7,%eax
  a5:	cd 40                	int    $0x40
  a7:	c3                   	ret    

000000a8 <open>:
SYSCALL(open)
  a8:	b8 0f 00 00 00       	mov    $0xf,%eax
  ad:	cd 40                	int    $0x40
  af:	c3                   	ret    

000000b0 <mknod>:
SYSCALL(mknod)
  b0:	b8 11 00 00 00       	mov    $0x11,%eax
  b5:	cd 40                	int    $0x40
  b7:	c3                   	ret    

000000b8 <unlink>:
SYSCALL(unlink)
  b8:	b8 12 00 00 00       	mov    $0x12,%eax
  bd:	cd 40                	int    $0x40
  bf:	c3                   	ret    

000000c0 <fstat>:
SYSCALL(fstat)
  c0:	b8 08 00 00 00       	mov    $0x8,%eax
  c5:	cd 40                	int    $0x40
  c7:	c3                   	ret    

000000c8 <link>:
SYSCALL(link)
  c8:	b8 13 00 00 00       	mov    $0x13,%eax
  cd:	cd 40                	int    $0x40
  cf:	c3                   	ret    

000000d0 <mkdir>:
SYSCALL(mkdir)
  d0:	b8 14 00 00 00       	mov    $0x14,%eax
  d5:	cd 40                	int    $0x40
  d7:	c3                   	ret    

000000d8 <chdir>:
SYSCALL(chdir)
  d8:	b8 09 00 00 00       	mov    $0x9,%eax
  dd:	cd 40                	int    $0x40
  df:	c3                   	ret    

000000e0 <dup>:
SYSCALL(dup)
  e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  e5:	cd 40                	int    $0x40
  e7:	c3                   	ret    

000000e8 <getpid>:
SYSCALL(getpid)
  e8:	b8 0b 00 00 00       	mov    $0xb,%eax
  ed:	cd 40                	int    $0x40
  ef:	c3                   	ret    

000000f0 <sbrk>:
SYSCALL(sbrk)
  f0:	b8 0c 00 00 00       	mov    $0xc,%eax
  f5:	cd 40                	int    $0x40
  f7:	c3                   	ret    

000000f8 <sleep>:
SYSCALL(sleep)
  f8:	b8 0d 00 00 00       	mov    $0xd,%eax
  fd:	cd 40                	int    $0x40
  ff:	c3                   	ret    

00000100 <uptime>:
SYSCALL(uptime)
 100:	b8 0e 00 00 00       	mov    $0xe,%eax
 105:	cd 40                	int    $0x40
 107:	c3                   	ret    

00000108 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	83 ec 1c             	sub    $0x1c,%esp
 10e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 111:	6a 01                	push   $0x1
 113:	8d 55 f4             	lea    -0xc(%ebp),%edx
 116:	52                   	push   %edx
 117:	50                   	push   %eax
 118:	e8 6b ff ff ff       	call   88 <write>
}
 11d:	83 c4 10             	add    $0x10,%esp
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	57                   	push   %edi
 126:	56                   	push   %esi
 127:	53                   	push   %ebx
 128:	83 ec 2c             	sub    $0x2c,%esp
 12b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 12e:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 134:	74 04                	je     13a <printint+0x18>
 136:	85 d2                	test   %edx,%edx
 138:	78 3a                	js     174 <printint+0x52>
  neg = 0;
 13a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 141:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 146:	89 f0                	mov    %esi,%eax
 148:	ba 00 00 00 00       	mov    $0x0,%edx
 14d:	f7 f1                	div    %ecx
 14f:	89 df                	mov    %ebx,%edi
 151:	43                   	inc    %ebx
 152:	8a 92 24 03 00 00    	mov    0x324(%edx),%dl
 158:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 15c:	89 f2                	mov    %esi,%edx
 15e:	89 c6                	mov    %eax,%esi
 160:	39 d1                	cmp    %edx,%ecx
 162:	76 e2                	jbe    146 <printint+0x24>
  if(neg)
 164:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 168:	74 22                	je     18c <printint+0x6a>
    buf[i++] = '-';
 16a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 16f:	8d 5f 02             	lea    0x2(%edi),%ebx
 172:	eb 18                	jmp    18c <printint+0x6a>
    x = -xx;
 174:	f7 de                	neg    %esi
    neg = 1;
 176:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 17d:	eb c2                	jmp    141 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 17f:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 184:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 187:	e8 7c ff ff ff       	call   108 <putc>
  while(--i >= 0)
 18c:	4b                   	dec    %ebx
 18d:	79 f0                	jns    17f <printint+0x5d>
}
 18f:	83 c4 2c             	add    $0x2c,%esp
 192:	5b                   	pop    %ebx
 193:	5e                   	pop    %esi
 194:	5f                   	pop    %edi
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    

00000197 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 197:	f3 0f 1e fb          	endbr32 
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	57                   	push   %edi
 19f:	56                   	push   %esi
 1a0:	53                   	push   %ebx
 1a1:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1a4:	8d 45 10             	lea    0x10(%ebp),%eax
 1a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1aa:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1af:	bb 00 00 00 00       	mov    $0x0,%ebx
 1b4:	eb 12                	jmp    1c8 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1b6:	89 fa                	mov    %edi,%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	e8 48 ff ff ff       	call   108 <putc>
 1c0:	eb 05                	jmp    1c7 <printf+0x30>
      }
    } else if(state == '%'){
 1c2:	83 fe 25             	cmp    $0x25,%esi
 1c5:	74 22                	je     1e9 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1c7:	43                   	inc    %ebx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1ce:	84 c0                	test   %al,%al
 1d0:	0f 84 13 01 00 00    	je     2e9 <printf+0x152>
    c = fmt[i] & 0xff;
 1d6:	0f be f8             	movsbl %al,%edi
 1d9:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1dc:	85 f6                	test   %esi,%esi
 1de:	75 e2                	jne    1c2 <printf+0x2b>
      if(c == '%'){
 1e0:	83 f8 25             	cmp    $0x25,%eax
 1e3:	75 d1                	jne    1b6 <printf+0x1f>
        state = '%';
 1e5:	89 c6                	mov    %eax,%esi
 1e7:	eb de                	jmp    1c7 <printf+0x30>
      if(c == 'd'){
 1e9:	83 f8 64             	cmp    $0x64,%eax
 1ec:	74 43                	je     231 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 1ee:	83 f8 78             	cmp    $0x78,%eax
 1f1:	74 68                	je     25b <printf+0xc4>
 1f3:	83 f8 70             	cmp    $0x70,%eax
 1f6:	74 63                	je     25b <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 1f8:	83 f8 73             	cmp    $0x73,%eax
 1fb:	0f 84 84 00 00 00    	je     285 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 201:	83 f8 63             	cmp    $0x63,%eax
 204:	0f 84 ad 00 00 00    	je     2b7 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 20a:	83 f8 25             	cmp    $0x25,%eax
 20d:	0f 84 c2 00 00 00    	je     2d5 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 213:	ba 25 00 00 00       	mov    $0x25,%edx
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	e8 e8 fe ff ff       	call   108 <putc>
        putc(fd, c);
 220:	89 fa                	mov    %edi,%edx
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	e8 de fe ff ff       	call   108 <putc>
      }
      state = 0;
 22a:	be 00 00 00 00       	mov    $0x0,%esi
 22f:	eb 96                	jmp    1c7 <printf+0x30>
        printint(fd, *ap, 10, 1);
 231:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 234:	8b 17                	mov    (%edi),%edx
 236:	83 ec 0c             	sub    $0xc,%esp
 239:	6a 01                	push   $0x1
 23b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	e8 da fe ff ff       	call   122 <printint>
        ap++;
 248:	83 c7 04             	add    $0x4,%edi
 24b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 24e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 251:	be 00 00 00 00       	mov    $0x0,%esi
 256:	e9 6c ff ff ff       	jmp    1c7 <printf+0x30>
        printint(fd, *ap, 16, 0);
 25b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 25e:	8b 17                	mov    (%edi),%edx
 260:	83 ec 0c             	sub    $0xc,%esp
 263:	6a 00                	push   $0x0
 265:	b9 10 00 00 00       	mov    $0x10,%ecx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	e8 b0 fe ff ff       	call   122 <printint>
        ap++;
 272:	83 c7 04             	add    $0x4,%edi
 275:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 278:	83 c4 10             	add    $0x10,%esp
      state = 0;
 27b:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 280:	e9 42 ff ff ff       	jmp    1c7 <printf+0x30>
        s = (char*)*ap;
 285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 288:	8b 30                	mov    (%eax),%esi
        ap++;
 28a:	83 c0 04             	add    $0x4,%eax
 28d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 290:	85 f6                	test   %esi,%esi
 292:	75 13                	jne    2a7 <printf+0x110>
          s = "(null)";
 294:	be 1b 03 00 00       	mov    $0x31b,%esi
 299:	eb 0c                	jmp    2a7 <printf+0x110>
          putc(fd, *s);
 29b:	0f be d2             	movsbl %dl,%edx
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	e8 62 fe ff ff       	call   108 <putc>
          s++;
 2a6:	46                   	inc    %esi
        while(*s != 0){
 2a7:	8a 16                	mov    (%esi),%dl
 2a9:	84 d2                	test   %dl,%dl
 2ab:	75 ee                	jne    29b <printf+0x104>
      state = 0;
 2ad:	be 00 00 00 00       	mov    $0x0,%esi
 2b2:	e9 10 ff ff ff       	jmp    1c7 <printf+0x30>
        putc(fd, *ap);
 2b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2ba:	0f be 17             	movsbl (%edi),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	e8 43 fe ff ff       	call   108 <putc>
        ap++;
 2c5:	83 c7 04             	add    $0x4,%edi
 2c8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2cb:	be 00 00 00 00       	mov    $0x0,%esi
 2d0:	e9 f2 fe ff ff       	jmp    1c7 <printf+0x30>
        putc(fd, c);
 2d5:	89 fa                	mov    %edi,%edx
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	e8 29 fe ff ff       	call   108 <putc>
      state = 0;
 2df:	be 00 00 00 00       	mov    $0x0,%esi
 2e4:	e9 de fe ff ff       	jmp    1c7 <printf+0x30>
    }
  }
}
 2e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ec:	5b                   	pop    %ebx
 2ed:	5e                   	pop    %esi
 2ee:	5f                   	pop    %edi
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
