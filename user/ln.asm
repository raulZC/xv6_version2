
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
  1e:	68 fc 02 00 00       	push   $0x2fc
  23:	6a 02                	push   $0x2
  25:	e8 75 01 00 00       	call   19f <printf>
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
  4f:	68 0f 03 00 00       	push   $0x30f
  54:	6a 02                	push   $0x2
  56:	e8 44 01 00 00       	call   19f <printf>
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

00000108 <date>:
SYSCALL(date)
 108:	b8 16 00 00 00       	mov    $0x16,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    

00000110 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 ec 1c             	sub    $0x1c,%esp
 116:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 119:	6a 01                	push   $0x1
 11b:	8d 55 f4             	lea    -0xc(%ebp),%edx
 11e:	52                   	push   %edx
 11f:	50                   	push   %eax
 120:	e8 63 ff ff ff       	call   88 <write>
}
 125:	83 c4 10             	add    $0x10,%esp
 128:	c9                   	leave  
 129:	c3                   	ret    

0000012a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	57                   	push   %edi
 12e:	56                   	push   %esi
 12f:	53                   	push   %ebx
 130:	83 ec 2c             	sub    $0x2c,%esp
 133:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 136:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 13c:	74 04                	je     142 <printint+0x18>
 13e:	85 d2                	test   %edx,%edx
 140:	78 3a                	js     17c <printint+0x52>
  neg = 0;
 142:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 149:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 14e:	89 f0                	mov    %esi,%eax
 150:	ba 00 00 00 00       	mov    $0x0,%edx
 155:	f7 f1                	div    %ecx
 157:	89 df                	mov    %ebx,%edi
 159:	43                   	inc    %ebx
 15a:	8a 92 2c 03 00 00    	mov    0x32c(%edx),%dl
 160:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 164:	89 f2                	mov    %esi,%edx
 166:	89 c6                	mov    %eax,%esi
 168:	39 d1                	cmp    %edx,%ecx
 16a:	76 e2                	jbe    14e <printint+0x24>
  if(neg)
 16c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 170:	74 22                	je     194 <printint+0x6a>
    buf[i++] = '-';
 172:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 177:	8d 5f 02             	lea    0x2(%edi),%ebx
 17a:	eb 18                	jmp    194 <printint+0x6a>
    x = -xx;
 17c:	f7 de                	neg    %esi
    neg = 1;
 17e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 185:	eb c2                	jmp    149 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 187:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 18c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 18f:	e8 7c ff ff ff       	call   110 <putc>
  while(--i >= 0)
 194:	4b                   	dec    %ebx
 195:	79 f0                	jns    187 <printint+0x5d>
}
 197:	83 c4 2c             	add    $0x2c,%esp
 19a:	5b                   	pop    %ebx
 19b:	5e                   	pop    %esi
 19c:	5f                   	pop    %edi
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    

0000019f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 19f:	f3 0f 1e fb          	endbr32 
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	57                   	push   %edi
 1a7:	56                   	push   %esi
 1a8:	53                   	push   %ebx
 1a9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1ac:	8d 45 10             	lea    0x10(%ebp),%eax
 1af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1b2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1b7:	bb 00 00 00 00       	mov    $0x0,%ebx
 1bc:	eb 12                	jmp    1d0 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1be:	89 fa                	mov    %edi,%edx
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	e8 48 ff ff ff       	call   110 <putc>
 1c8:	eb 05                	jmp    1cf <printf+0x30>
      }
    } else if(state == '%'){
 1ca:	83 fe 25             	cmp    $0x25,%esi
 1cd:	74 22                	je     1f1 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1cf:	43                   	inc    %ebx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1d6:	84 c0                	test   %al,%al
 1d8:	0f 84 13 01 00 00    	je     2f1 <printf+0x152>
    c = fmt[i] & 0xff;
 1de:	0f be f8             	movsbl %al,%edi
 1e1:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1e4:	85 f6                	test   %esi,%esi
 1e6:	75 e2                	jne    1ca <printf+0x2b>
      if(c == '%'){
 1e8:	83 f8 25             	cmp    $0x25,%eax
 1eb:	75 d1                	jne    1be <printf+0x1f>
        state = '%';
 1ed:	89 c6                	mov    %eax,%esi
 1ef:	eb de                	jmp    1cf <printf+0x30>
      if(c == 'd'){
 1f1:	83 f8 64             	cmp    $0x64,%eax
 1f4:	74 43                	je     239 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 1f6:	83 f8 78             	cmp    $0x78,%eax
 1f9:	74 68                	je     263 <printf+0xc4>
 1fb:	83 f8 70             	cmp    $0x70,%eax
 1fe:	74 63                	je     263 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 200:	83 f8 73             	cmp    $0x73,%eax
 203:	0f 84 84 00 00 00    	je     28d <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 209:	83 f8 63             	cmp    $0x63,%eax
 20c:	0f 84 ad 00 00 00    	je     2bf <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 212:	83 f8 25             	cmp    $0x25,%eax
 215:	0f 84 c2 00 00 00    	je     2dd <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 21b:	ba 25 00 00 00       	mov    $0x25,%edx
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	e8 e8 fe ff ff       	call   110 <putc>
        putc(fd, c);
 228:	89 fa                	mov    %edi,%edx
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	e8 de fe ff ff       	call   110 <putc>
      }
      state = 0;
 232:	be 00 00 00 00       	mov    $0x0,%esi
 237:	eb 96                	jmp    1cf <printf+0x30>
        printint(fd, *ap, 10, 1);
 239:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 23c:	8b 17                	mov    (%edi),%edx
 23e:	83 ec 0c             	sub    $0xc,%esp
 241:	6a 01                	push   $0x1
 243:	b9 0a 00 00 00       	mov    $0xa,%ecx
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	e8 da fe ff ff       	call   12a <printint>
        ap++;
 250:	83 c7 04             	add    $0x4,%edi
 253:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 256:	83 c4 10             	add    $0x10,%esp
      state = 0;
 259:	be 00 00 00 00       	mov    $0x0,%esi
 25e:	e9 6c ff ff ff       	jmp    1cf <printf+0x30>
        printint(fd, *ap, 16, 0);
 263:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 266:	8b 17                	mov    (%edi),%edx
 268:	83 ec 0c             	sub    $0xc,%esp
 26b:	6a 00                	push   $0x0
 26d:	b9 10 00 00 00       	mov    $0x10,%ecx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	e8 b0 fe ff ff       	call   12a <printint>
        ap++;
 27a:	83 c7 04             	add    $0x4,%edi
 27d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 280:	83 c4 10             	add    $0x10,%esp
      state = 0;
 283:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 288:	e9 42 ff ff ff       	jmp    1cf <printf+0x30>
        s = (char*)*ap;
 28d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 290:	8b 30                	mov    (%eax),%esi
        ap++;
 292:	83 c0 04             	add    $0x4,%eax
 295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 298:	85 f6                	test   %esi,%esi
 29a:	75 13                	jne    2af <printf+0x110>
          s = "(null)";
 29c:	be 23 03 00 00       	mov    $0x323,%esi
 2a1:	eb 0c                	jmp    2af <printf+0x110>
          putc(fd, *s);
 2a3:	0f be d2             	movsbl %dl,%edx
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	e8 62 fe ff ff       	call   110 <putc>
          s++;
 2ae:	46                   	inc    %esi
        while(*s != 0){
 2af:	8a 16                	mov    (%esi),%dl
 2b1:	84 d2                	test   %dl,%dl
 2b3:	75 ee                	jne    2a3 <printf+0x104>
      state = 0;
 2b5:	be 00 00 00 00       	mov    $0x0,%esi
 2ba:	e9 10 ff ff ff       	jmp    1cf <printf+0x30>
        putc(fd, *ap);
 2bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2c2:	0f be 17             	movsbl (%edi),%edx
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	e8 43 fe ff ff       	call   110 <putc>
        ap++;
 2cd:	83 c7 04             	add    $0x4,%edi
 2d0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2d3:	be 00 00 00 00       	mov    $0x0,%esi
 2d8:	e9 f2 fe ff ff       	jmp    1cf <printf+0x30>
        putc(fd, c);
 2dd:	89 fa                	mov    %edi,%edx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	e8 29 fe ff ff       	call   110 <putc>
      state = 0;
 2e7:	be 00 00 00 00       	mov    $0x0,%esi
 2ec:	e9 de fe ff ff       	jmp    1cf <printf+0x30>
    }
  }
}
 2f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2f4:	5b                   	pop    %ebx
 2f5:	5e                   	pop    %esi
 2f6:	5f                   	pop    %edi
 2f7:	5d                   	pop    %ebp
 2f8:	c3                   	ret    
