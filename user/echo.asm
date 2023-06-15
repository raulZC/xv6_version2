
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
  24:	ba e8 02 00 00       	mov    $0x2e8,%edx
  29:	52                   	push   %edx
  2a:	ff 34 87             	pushl  (%edi,%eax,4)
  2d:	68 ec 02 00 00       	push   $0x2ec
  32:	6a 01                	push   $0x1
  34:	e8 53 01 00 00       	call   18c <printf>
  39:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  3c:	89 d8                	mov    %ebx,%eax
  3e:	39 f0                	cmp    %esi,%eax
  40:	7d 0e                	jge    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  42:	8d 58 01             	lea    0x1(%eax),%ebx
  45:	39 f3                	cmp    %esi,%ebx
  47:	7d db                	jge    24 <main+0x24>
  49:	ba ea 02 00 00       	mov    $0x2ea,%edx
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

000000fd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 1c             	sub    $0x1c,%esp
 103:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 106:	6a 01                	push   $0x1
 108:	8d 55 f4             	lea    -0xc(%ebp),%edx
 10b:	52                   	push   %edx
 10c:	50                   	push   %eax
 10d:	e8 6b ff ff ff       	call   7d <write>
}
 112:	83 c4 10             	add    $0x10,%esp
 115:	c9                   	leave  
 116:	c3                   	ret    

00000117 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	57                   	push   %edi
 11b:	56                   	push   %esi
 11c:	53                   	push   %ebx
 11d:	83 ec 2c             	sub    $0x2c,%esp
 120:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 123:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 129:	74 04                	je     12f <printint+0x18>
 12b:	85 d2                	test   %edx,%edx
 12d:	78 3a                	js     169 <printint+0x52>
  neg = 0;
 12f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 136:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 13b:	89 f0                	mov    %esi,%eax
 13d:	ba 00 00 00 00       	mov    $0x0,%edx
 142:	f7 f1                	div    %ecx
 144:	89 df                	mov    %ebx,%edi
 146:	43                   	inc    %ebx
 147:	8a 92 f8 02 00 00    	mov    0x2f8(%edx),%dl
 14d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 151:	89 f2                	mov    %esi,%edx
 153:	89 c6                	mov    %eax,%esi
 155:	39 d1                	cmp    %edx,%ecx
 157:	76 e2                	jbe    13b <printint+0x24>
  if(neg)
 159:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 15d:	74 22                	je     181 <printint+0x6a>
    buf[i++] = '-';
 15f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 164:	8d 5f 02             	lea    0x2(%edi),%ebx
 167:	eb 18                	jmp    181 <printint+0x6a>
    x = -xx;
 169:	f7 de                	neg    %esi
    neg = 1;
 16b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 172:	eb c2                	jmp    136 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 174:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 179:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 17c:	e8 7c ff ff ff       	call   fd <putc>
  while(--i >= 0)
 181:	4b                   	dec    %ebx
 182:	79 f0                	jns    174 <printint+0x5d>
}
 184:	83 c4 2c             	add    $0x2c,%esp
 187:	5b                   	pop    %ebx
 188:	5e                   	pop    %esi
 189:	5f                   	pop    %edi
 18a:	5d                   	pop    %ebp
 18b:	c3                   	ret    

0000018c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 18c:	f3 0f 1e fb          	endbr32 
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
 195:	53                   	push   %ebx
 196:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 199:	8d 45 10             	lea    0x10(%ebp),%eax
 19c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 19f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1a4:	bb 00 00 00 00       	mov    $0x0,%ebx
 1a9:	eb 12                	jmp    1bd <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1ab:	89 fa                	mov    %edi,%edx
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	e8 48 ff ff ff       	call   fd <putc>
 1b5:	eb 05                	jmp    1bc <printf+0x30>
      }
    } else if(state == '%'){
 1b7:	83 fe 25             	cmp    $0x25,%esi
 1ba:	74 22                	je     1de <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1bc:	43                   	inc    %ebx
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1c3:	84 c0                	test   %al,%al
 1c5:	0f 84 13 01 00 00    	je     2de <printf+0x152>
    c = fmt[i] & 0xff;
 1cb:	0f be f8             	movsbl %al,%edi
 1ce:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1d1:	85 f6                	test   %esi,%esi
 1d3:	75 e2                	jne    1b7 <printf+0x2b>
      if(c == '%'){
 1d5:	83 f8 25             	cmp    $0x25,%eax
 1d8:	75 d1                	jne    1ab <printf+0x1f>
        state = '%';
 1da:	89 c6                	mov    %eax,%esi
 1dc:	eb de                	jmp    1bc <printf+0x30>
      if(c == 'd'){
 1de:	83 f8 64             	cmp    $0x64,%eax
 1e1:	74 43                	je     226 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 1e3:	83 f8 78             	cmp    $0x78,%eax
 1e6:	74 68                	je     250 <printf+0xc4>
 1e8:	83 f8 70             	cmp    $0x70,%eax
 1eb:	74 63                	je     250 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 1ed:	83 f8 73             	cmp    $0x73,%eax
 1f0:	0f 84 84 00 00 00    	je     27a <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 1f6:	83 f8 63             	cmp    $0x63,%eax
 1f9:	0f 84 ad 00 00 00    	je     2ac <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 1ff:	83 f8 25             	cmp    $0x25,%eax
 202:	0f 84 c2 00 00 00    	je     2ca <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 208:	ba 25 00 00 00       	mov    $0x25,%edx
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	e8 e8 fe ff ff       	call   fd <putc>
        putc(fd, c);
 215:	89 fa                	mov    %edi,%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	e8 de fe ff ff       	call   fd <putc>
      }
      state = 0;
 21f:	be 00 00 00 00       	mov    $0x0,%esi
 224:	eb 96                	jmp    1bc <printf+0x30>
        printint(fd, *ap, 10, 1);
 226:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 229:	8b 17                	mov    (%edi),%edx
 22b:	83 ec 0c             	sub    $0xc,%esp
 22e:	6a 01                	push   $0x1
 230:	b9 0a 00 00 00       	mov    $0xa,%ecx
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	e8 da fe ff ff       	call   117 <printint>
        ap++;
 23d:	83 c7 04             	add    $0x4,%edi
 240:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 243:	83 c4 10             	add    $0x10,%esp
      state = 0;
 246:	be 00 00 00 00       	mov    $0x0,%esi
 24b:	e9 6c ff ff ff       	jmp    1bc <printf+0x30>
        printint(fd, *ap, 16, 0);
 250:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 253:	8b 17                	mov    (%edi),%edx
 255:	83 ec 0c             	sub    $0xc,%esp
 258:	6a 00                	push   $0x0
 25a:	b9 10 00 00 00       	mov    $0x10,%ecx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	e8 b0 fe ff ff       	call   117 <printint>
        ap++;
 267:	83 c7 04             	add    $0x4,%edi
 26a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 26d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 270:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 275:	e9 42 ff ff ff       	jmp    1bc <printf+0x30>
        s = (char*)*ap;
 27a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 27d:	8b 30                	mov    (%eax),%esi
        ap++;
 27f:	83 c0 04             	add    $0x4,%eax
 282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 285:	85 f6                	test   %esi,%esi
 287:	75 13                	jne    29c <printf+0x110>
          s = "(null)";
 289:	be f1 02 00 00       	mov    $0x2f1,%esi
 28e:	eb 0c                	jmp    29c <printf+0x110>
          putc(fd, *s);
 290:	0f be d2             	movsbl %dl,%edx
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	e8 62 fe ff ff       	call   fd <putc>
          s++;
 29b:	46                   	inc    %esi
        while(*s != 0){
 29c:	8a 16                	mov    (%esi),%dl
 29e:	84 d2                	test   %dl,%dl
 2a0:	75 ee                	jne    290 <printf+0x104>
      state = 0;
 2a2:	be 00 00 00 00       	mov    $0x0,%esi
 2a7:	e9 10 ff ff ff       	jmp    1bc <printf+0x30>
        putc(fd, *ap);
 2ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2af:	0f be 17             	movsbl (%edi),%edx
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	e8 43 fe ff ff       	call   fd <putc>
        ap++;
 2ba:	83 c7 04             	add    $0x4,%edi
 2bd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2c0:	be 00 00 00 00       	mov    $0x0,%esi
 2c5:	e9 f2 fe ff ff       	jmp    1bc <printf+0x30>
        putc(fd, c);
 2ca:	89 fa                	mov    %edi,%edx
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	e8 29 fe ff ff       	call   fd <putc>
      state = 0;
 2d4:	be 00 00 00 00       	mov    $0x0,%esi
 2d9:	e9 de fe ff ff       	jmp    1bc <printf+0x30>
    }
  }
}
 2de:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e1:	5b                   	pop    %ebx
 2e2:	5e                   	pop    %esi
 2e3:	5f                   	pop    %edi
 2e4:	5d                   	pop    %ebp
 2e5:	c3                   	ret    
