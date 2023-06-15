
echo:     formato del fichero elf32-i386


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
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  1d:	b8 01 00 00 00       	mov    $0x1,%eax
  22:	eb 1a                	jmp    3e <main+0x3e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  24:	ba f0 02 00 00       	mov    $0x2f0,%edx
  29:	52                   	push   %edx
  2a:	ff 34 87             	pushl  (%edi,%eax,4)
  2d:	68 f4 02 00 00       	push   $0x2f4
  32:	6a 01                	push   $0x1
  34:	e8 5b 01 00 00       	call   194 <printf>
  39:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  3c:	89 d8                	mov    %ebx,%eax
  3e:	39 f0                	cmp    %esi,%eax
  40:	7d 0e                	jge    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  42:	8d 58 01             	lea    0x1(%eax),%ebx
  45:	39 f3                	cmp    %esi,%ebx
  47:	7d db                	jge    24 <main+0x24>
  49:	ba f2 02 00 00       	mov    $0x2f2,%edx
  4e:	eb d9                	jmp    29 <main+0x29>
  exit();
  50:	e8 08 00 00 00       	call   5d <exit>

00000055 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  55:	b8 01 00 00 00       	mov    $0x1,%eax
  5a:	cd 40                	int    $0x40
  5c:	c3                   	ret    

0000005d <exit>:
SYSCALL(exit)
  5d:	b8 02 00 00 00       	mov    $0x2,%eax
  62:	cd 40                	int    $0x40
  64:	c3                   	ret    

00000065 <wait>:
SYSCALL(wait)
  65:	b8 03 00 00 00       	mov    $0x3,%eax
  6a:	cd 40                	int    $0x40
  6c:	c3                   	ret    

0000006d <pipe>:
SYSCALL(pipe)
  6d:	b8 04 00 00 00       	mov    $0x4,%eax
  72:	cd 40                	int    $0x40
  74:	c3                   	ret    

00000075 <read>:
SYSCALL(read)
  75:	b8 05 00 00 00       	mov    $0x5,%eax
  7a:	cd 40                	int    $0x40
  7c:	c3                   	ret    

0000007d <write>:
SYSCALL(write)
  7d:	b8 10 00 00 00       	mov    $0x10,%eax
  82:	cd 40                	int    $0x40
  84:	c3                   	ret    

00000085 <close>:
SYSCALL(close)
  85:	b8 15 00 00 00       	mov    $0x15,%eax
  8a:	cd 40                	int    $0x40
  8c:	c3                   	ret    

0000008d <kill>:
SYSCALL(kill)
  8d:	b8 06 00 00 00       	mov    $0x6,%eax
  92:	cd 40                	int    $0x40
  94:	c3                   	ret    

00000095 <exec>:
SYSCALL(exec)
  95:	b8 07 00 00 00       	mov    $0x7,%eax
  9a:	cd 40                	int    $0x40
  9c:	c3                   	ret    

0000009d <open>:
SYSCALL(open)
  9d:	b8 0f 00 00 00       	mov    $0xf,%eax
  a2:	cd 40                	int    $0x40
  a4:	c3                   	ret    

000000a5 <mknod>:
SYSCALL(mknod)
  a5:	b8 11 00 00 00       	mov    $0x11,%eax
  aa:	cd 40                	int    $0x40
  ac:	c3                   	ret    

000000ad <unlink>:
SYSCALL(unlink)
  ad:	b8 12 00 00 00       	mov    $0x12,%eax
  b2:	cd 40                	int    $0x40
  b4:	c3                   	ret    

000000b5 <fstat>:
SYSCALL(fstat)
  b5:	b8 08 00 00 00       	mov    $0x8,%eax
  ba:	cd 40                	int    $0x40
  bc:	c3                   	ret    

000000bd <link>:
SYSCALL(link)
  bd:	b8 13 00 00 00       	mov    $0x13,%eax
  c2:	cd 40                	int    $0x40
  c4:	c3                   	ret    

000000c5 <mkdir>:
SYSCALL(mkdir)
  c5:	b8 14 00 00 00       	mov    $0x14,%eax
  ca:	cd 40                	int    $0x40
  cc:	c3                   	ret    

000000cd <chdir>:
SYSCALL(chdir)
  cd:	b8 09 00 00 00       	mov    $0x9,%eax
  d2:	cd 40                	int    $0x40
  d4:	c3                   	ret    

000000d5 <dup>:
SYSCALL(dup)
  d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  da:	cd 40                	int    $0x40
  dc:	c3                   	ret    

000000dd <getpid>:
SYSCALL(getpid)
  dd:	b8 0b 00 00 00       	mov    $0xb,%eax
  e2:	cd 40                	int    $0x40
  e4:	c3                   	ret    

000000e5 <sbrk>:
SYSCALL(sbrk)
  e5:	b8 0c 00 00 00       	mov    $0xc,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret    

000000ed <sleep>:
SYSCALL(sleep)
  ed:	b8 0d 00 00 00       	mov    $0xd,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret    

000000f5 <uptime>:
SYSCALL(uptime)
  f5:	b8 0e 00 00 00       	mov    $0xe,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret    

000000fd <date>:
SYSCALL(date)
  fd:	b8 16 00 00 00       	mov    $0x16,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	83 ec 1c             	sub    $0x1c,%esp
 10b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 10e:	6a 01                	push   $0x1
 110:	8d 55 f4             	lea    -0xc(%ebp),%edx
 113:	52                   	push   %edx
 114:	50                   	push   %eax
 115:	e8 63 ff ff ff       	call   7d <write>
}
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	c9                   	leave  
 11e:	c3                   	ret    

0000011f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	57                   	push   %edi
 123:	56                   	push   %esi
 124:	53                   	push   %ebx
 125:	83 ec 2c             	sub    $0x2c,%esp
 128:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 12b:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 12d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 131:	74 04                	je     137 <printint+0x18>
 133:	85 d2                	test   %edx,%edx
 135:	78 3a                	js     171 <printint+0x52>
  neg = 0;
 137:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 13e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 143:	89 f0                	mov    %esi,%eax
 145:	ba 00 00 00 00       	mov    $0x0,%edx
 14a:	f7 f1                	div    %ecx
 14c:	89 df                	mov    %ebx,%edi
 14e:	43                   	inc    %ebx
 14f:	8a 92 00 03 00 00    	mov    0x300(%edx),%dl
 155:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 159:	89 f2                	mov    %esi,%edx
 15b:	89 c6                	mov    %eax,%esi
 15d:	39 d1                	cmp    %edx,%ecx
 15f:	76 e2                	jbe    143 <printint+0x24>
  if(neg)
 161:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 165:	74 22                	je     189 <printint+0x6a>
    buf[i++] = '-';
 167:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 16c:	8d 5f 02             	lea    0x2(%edi),%ebx
 16f:	eb 18                	jmp    189 <printint+0x6a>
    x = -xx;
 171:	f7 de                	neg    %esi
    neg = 1;
 173:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 17a:	eb c2                	jmp    13e <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 17c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 181:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 184:	e8 7c ff ff ff       	call   105 <putc>
  while(--i >= 0)
 189:	4b                   	dec    %ebx
 18a:	79 f0                	jns    17c <printint+0x5d>
}
 18c:	83 c4 2c             	add    $0x2c,%esp
 18f:	5b                   	pop    %ebx
 190:	5e                   	pop    %esi
 191:	5f                   	pop    %edi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    

00000194 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 194:	f3 0f 1e fb          	endbr32 
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	57                   	push   %edi
 19c:	56                   	push   %esi
 19d:	53                   	push   %ebx
 19e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1a1:	8d 45 10             	lea    0x10(%ebp),%eax
 1a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1a7:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1ac:	bb 00 00 00 00       	mov    $0x0,%ebx
 1b1:	eb 12                	jmp    1c5 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1b3:	89 fa                	mov    %edi,%edx
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	e8 48 ff ff ff       	call   105 <putc>
 1bd:	eb 05                	jmp    1c4 <printf+0x30>
      }
    } else if(state == '%'){
 1bf:	83 fe 25             	cmp    $0x25,%esi
 1c2:	74 22                	je     1e6 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1c4:	43                   	inc    %ebx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1cb:	84 c0                	test   %al,%al
 1cd:	0f 84 13 01 00 00    	je     2e6 <printf+0x152>
    c = fmt[i] & 0xff;
 1d3:	0f be f8             	movsbl %al,%edi
 1d6:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1d9:	85 f6                	test   %esi,%esi
 1db:	75 e2                	jne    1bf <printf+0x2b>
      if(c == '%'){
 1dd:	83 f8 25             	cmp    $0x25,%eax
 1e0:	75 d1                	jne    1b3 <printf+0x1f>
        state = '%';
 1e2:	89 c6                	mov    %eax,%esi
 1e4:	eb de                	jmp    1c4 <printf+0x30>
      if(c == 'd'){
 1e6:	83 f8 64             	cmp    $0x64,%eax
 1e9:	74 43                	je     22e <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 1eb:	83 f8 78             	cmp    $0x78,%eax
 1ee:	74 68                	je     258 <printf+0xc4>
 1f0:	83 f8 70             	cmp    $0x70,%eax
 1f3:	74 63                	je     258 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 1f5:	83 f8 73             	cmp    $0x73,%eax
 1f8:	0f 84 84 00 00 00    	je     282 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 1fe:	83 f8 63             	cmp    $0x63,%eax
 201:	0f 84 ad 00 00 00    	je     2b4 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 207:	83 f8 25             	cmp    $0x25,%eax
 20a:	0f 84 c2 00 00 00    	je     2d2 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 210:	ba 25 00 00 00       	mov    $0x25,%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	e8 e8 fe ff ff       	call   105 <putc>
        putc(fd, c);
 21d:	89 fa                	mov    %edi,%edx
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	e8 de fe ff ff       	call   105 <putc>
      }
      state = 0;
 227:	be 00 00 00 00       	mov    $0x0,%esi
 22c:	eb 96                	jmp    1c4 <printf+0x30>
        printint(fd, *ap, 10, 1);
 22e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 231:	8b 17                	mov    (%edi),%edx
 233:	83 ec 0c             	sub    $0xc,%esp
 236:	6a 01                	push   $0x1
 238:	b9 0a 00 00 00       	mov    $0xa,%ecx
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	e8 da fe ff ff       	call   11f <printint>
        ap++;
 245:	83 c7 04             	add    $0x4,%edi
 248:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 24b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 24e:	be 00 00 00 00       	mov    $0x0,%esi
 253:	e9 6c ff ff ff       	jmp    1c4 <printf+0x30>
        printint(fd, *ap, 16, 0);
 258:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 25b:	8b 17                	mov    (%edi),%edx
 25d:	83 ec 0c             	sub    $0xc,%esp
 260:	6a 00                	push   $0x0
 262:	b9 10 00 00 00       	mov    $0x10,%ecx
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	e8 b0 fe ff ff       	call   11f <printint>
        ap++;
 26f:	83 c7 04             	add    $0x4,%edi
 272:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 275:	83 c4 10             	add    $0x10,%esp
      state = 0;
 278:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 27d:	e9 42 ff ff ff       	jmp    1c4 <printf+0x30>
        s = (char*)*ap;
 282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 285:	8b 30                	mov    (%eax),%esi
        ap++;
 287:	83 c0 04             	add    $0x4,%eax
 28a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 28d:	85 f6                	test   %esi,%esi
 28f:	75 13                	jne    2a4 <printf+0x110>
          s = "(null)";
 291:	be f9 02 00 00       	mov    $0x2f9,%esi
 296:	eb 0c                	jmp    2a4 <printf+0x110>
          putc(fd, *s);
 298:	0f be d2             	movsbl %dl,%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	e8 62 fe ff ff       	call   105 <putc>
          s++;
 2a3:	46                   	inc    %esi
        while(*s != 0){
 2a4:	8a 16                	mov    (%esi),%dl
 2a6:	84 d2                	test   %dl,%dl
 2a8:	75 ee                	jne    298 <printf+0x104>
      state = 0;
 2aa:	be 00 00 00 00       	mov    $0x0,%esi
 2af:	e9 10 ff ff ff       	jmp    1c4 <printf+0x30>
        putc(fd, *ap);
 2b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2b7:	0f be 17             	movsbl (%edi),%edx
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	e8 43 fe ff ff       	call   105 <putc>
        ap++;
 2c2:	83 c7 04             	add    $0x4,%edi
 2c5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2c8:	be 00 00 00 00       	mov    $0x0,%esi
 2cd:	e9 f2 fe ff ff       	jmp    1c4 <printf+0x30>
        putc(fd, c);
 2d2:	89 fa                	mov    %edi,%edx
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	e8 29 fe ff ff       	call   105 <putc>
      state = 0;
 2dc:	be 00 00 00 00       	mov    $0x0,%esi
 2e1:	e9 de fe ff ff       	jmp    1c4 <printf+0x30>
    }
  }
}
 2e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e9:	5b                   	pop    %ebx
 2ea:	5e                   	pop    %esi
 2eb:	5f                   	pop    %edi
 2ec:	5d                   	pop    %ebp
 2ed:	c3                   	ret    
