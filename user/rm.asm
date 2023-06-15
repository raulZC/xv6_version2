
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
  49:	68 0c 03 00 00       	push   $0x30c
  4e:	6a 02                	push   $0x2
  50:	e8 5d 01 00 00       	call   1b2 <printf>
    exit();
  55:	e8 21 00 00 00       	call   7b <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	ff 36                	pushl  (%esi)
  5f:	68 20 03 00 00       	push   $0x320
  64:	6a 02                	push   $0x2
  66:	e8 47 01 00 00       	call   1b2 <printf>
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

0000011b <date>:
SYSCALL(date)
 11b:	b8 16 00 00 00       	mov    $0x16,%eax
 120:	cd 40                	int    $0x40
 122:	c3                   	ret    

00000123 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 1c             	sub    $0x1c,%esp
 129:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 12c:	6a 01                	push   $0x1
 12e:	8d 55 f4             	lea    -0xc(%ebp),%edx
 131:	52                   	push   %edx
 132:	50                   	push   %eax
 133:	e8 63 ff ff ff       	call   9b <write>
}
 138:	83 c4 10             	add    $0x10,%esp
 13b:	c9                   	leave  
 13c:	c3                   	ret    

0000013d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	57                   	push   %edi
 141:	56                   	push   %esi
 142:	53                   	push   %ebx
 143:	83 ec 2c             	sub    $0x2c,%esp
 146:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 149:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 14b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 14f:	74 04                	je     155 <printint+0x18>
 151:	85 d2                	test   %edx,%edx
 153:	78 3a                	js     18f <printint+0x52>
  neg = 0;
 155:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 15c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 161:	89 f0                	mov    %esi,%eax
 163:	ba 00 00 00 00       	mov    $0x0,%edx
 168:	f7 f1                	div    %ecx
 16a:	89 df                	mov    %ebx,%edi
 16c:	43                   	inc    %ebx
 16d:	8a 92 40 03 00 00    	mov    0x340(%edx),%dl
 173:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 177:	89 f2                	mov    %esi,%edx
 179:	89 c6                	mov    %eax,%esi
 17b:	39 d1                	cmp    %edx,%ecx
 17d:	76 e2                	jbe    161 <printint+0x24>
  if(neg)
 17f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 183:	74 22                	je     1a7 <printint+0x6a>
    buf[i++] = '-';
 185:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 18a:	8d 5f 02             	lea    0x2(%edi),%ebx
 18d:	eb 18                	jmp    1a7 <printint+0x6a>
    x = -xx;
 18f:	f7 de                	neg    %esi
    neg = 1;
 191:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 198:	eb c2                	jmp    15c <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 19a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 19f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1a2:	e8 7c ff ff ff       	call   123 <putc>
  while(--i >= 0)
 1a7:	4b                   	dec    %ebx
 1a8:	79 f0                	jns    19a <printint+0x5d>
}
 1aa:	83 c4 2c             	add    $0x2c,%esp
 1ad:	5b                   	pop    %ebx
 1ae:	5e                   	pop    %esi
 1af:	5f                   	pop    %edi
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1b2:	f3 0f 1e fb          	endbr32 
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	57                   	push   %edi
 1ba:	56                   	push   %esi
 1bb:	53                   	push   %ebx
 1bc:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1bf:	8d 45 10             	lea    0x10(%ebp),%eax
 1c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1c5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1ca:	bb 00 00 00 00       	mov    $0x0,%ebx
 1cf:	eb 12                	jmp    1e3 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1d1:	89 fa                	mov    %edi,%edx
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	e8 48 ff ff ff       	call   123 <putc>
 1db:	eb 05                	jmp    1e2 <printf+0x30>
      }
    } else if(state == '%'){
 1dd:	83 fe 25             	cmp    $0x25,%esi
 1e0:	74 22                	je     204 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1e2:	43                   	inc    %ebx
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1e9:	84 c0                	test   %al,%al
 1eb:	0f 84 13 01 00 00    	je     304 <printf+0x152>
    c = fmt[i] & 0xff;
 1f1:	0f be f8             	movsbl %al,%edi
 1f4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1f7:	85 f6                	test   %esi,%esi
 1f9:	75 e2                	jne    1dd <printf+0x2b>
      if(c == '%'){
 1fb:	83 f8 25             	cmp    $0x25,%eax
 1fe:	75 d1                	jne    1d1 <printf+0x1f>
        state = '%';
 200:	89 c6                	mov    %eax,%esi
 202:	eb de                	jmp    1e2 <printf+0x30>
      if(c == 'd'){
 204:	83 f8 64             	cmp    $0x64,%eax
 207:	74 43                	je     24c <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 209:	83 f8 78             	cmp    $0x78,%eax
 20c:	74 68                	je     276 <printf+0xc4>
 20e:	83 f8 70             	cmp    $0x70,%eax
 211:	74 63                	je     276 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 213:	83 f8 73             	cmp    $0x73,%eax
 216:	0f 84 84 00 00 00    	je     2a0 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 21c:	83 f8 63             	cmp    $0x63,%eax
 21f:	0f 84 ad 00 00 00    	je     2d2 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 225:	83 f8 25             	cmp    $0x25,%eax
 228:	0f 84 c2 00 00 00    	je     2f0 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 22e:	ba 25 00 00 00       	mov    $0x25,%edx
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	e8 e8 fe ff ff       	call   123 <putc>
        putc(fd, c);
 23b:	89 fa                	mov    %edi,%edx
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	e8 de fe ff ff       	call   123 <putc>
      }
      state = 0;
 245:	be 00 00 00 00       	mov    $0x0,%esi
 24a:	eb 96                	jmp    1e2 <printf+0x30>
        printint(fd, *ap, 10, 1);
 24c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 24f:	8b 17                	mov    (%edi),%edx
 251:	83 ec 0c             	sub    $0xc,%esp
 254:	6a 01                	push   $0x1
 256:	b9 0a 00 00 00       	mov    $0xa,%ecx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	e8 da fe ff ff       	call   13d <printint>
        ap++;
 263:	83 c7 04             	add    $0x4,%edi
 266:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 269:	83 c4 10             	add    $0x10,%esp
      state = 0;
 26c:	be 00 00 00 00       	mov    $0x0,%esi
 271:	e9 6c ff ff ff       	jmp    1e2 <printf+0x30>
        printint(fd, *ap, 16, 0);
 276:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 279:	8b 17                	mov    (%edi),%edx
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	6a 00                	push   $0x0
 280:	b9 10 00 00 00       	mov    $0x10,%ecx
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	e8 b0 fe ff ff       	call   13d <printint>
        ap++;
 28d:	83 c7 04             	add    $0x4,%edi
 290:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 293:	83 c4 10             	add    $0x10,%esp
      state = 0;
 296:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 29b:	e9 42 ff ff ff       	jmp    1e2 <printf+0x30>
        s = (char*)*ap;
 2a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2a3:	8b 30                	mov    (%eax),%esi
        ap++;
 2a5:	83 c0 04             	add    $0x4,%eax
 2a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2ab:	85 f6                	test   %esi,%esi
 2ad:	75 13                	jne    2c2 <printf+0x110>
          s = "(null)";
 2af:	be 39 03 00 00       	mov    $0x339,%esi
 2b4:	eb 0c                	jmp    2c2 <printf+0x110>
          putc(fd, *s);
 2b6:	0f be d2             	movsbl %dl,%edx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	e8 62 fe ff ff       	call   123 <putc>
          s++;
 2c1:	46                   	inc    %esi
        while(*s != 0){
 2c2:	8a 16                	mov    (%esi),%dl
 2c4:	84 d2                	test   %dl,%dl
 2c6:	75 ee                	jne    2b6 <printf+0x104>
      state = 0;
 2c8:	be 00 00 00 00       	mov    $0x0,%esi
 2cd:	e9 10 ff ff ff       	jmp    1e2 <printf+0x30>
        putc(fd, *ap);
 2d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d5:	0f be 17             	movsbl (%edi),%edx
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	e8 43 fe ff ff       	call   123 <putc>
        ap++;
 2e0:	83 c7 04             	add    $0x4,%edi
 2e3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2e6:	be 00 00 00 00       	mov    $0x0,%esi
 2eb:	e9 f2 fe ff ff       	jmp    1e2 <printf+0x30>
        putc(fd, c);
 2f0:	89 fa                	mov    %edi,%edx
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	e8 29 fe ff ff       	call   123 <putc>
      state = 0;
 2fa:	be 00 00 00 00       	mov    $0x0,%esi
 2ff:	e9 de fe ff ff       	jmp    1e2 <printf+0x30>
    }
  }
}
 304:	8d 65 f4             	lea    -0xc(%ebp),%esp
 307:	5b                   	pop    %ebx
 308:	5e                   	pop    %esi
 309:	5f                   	pop    %edi
 30a:	5d                   	pop    %ebp
 30b:	c3                   	ret    
