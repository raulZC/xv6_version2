
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
  24:	ba fc 02 00 00       	mov    $0x2fc,%edx
  29:	52                   	push   %edx
  2a:	ff 34 87             	pushl  (%edi,%eax,4)
  2d:	68 00 03 00 00       	push   $0x300
  32:	6a 01                	push   $0x1
  34:	e8 68 01 00 00       	call   1a1 <printf>
  39:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  3c:	89 d8                	mov    %ebx,%eax
  3e:	39 f0                	cmp    %esi,%eax
  40:	7d 0e                	jge    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  42:	8d 58 01             	lea    0x1(%eax),%ebx
  45:	39 f3                	cmp    %esi,%ebx
  47:	7d db                	jge    24 <main+0x24>
  49:	ba fe 02 00 00       	mov    $0x2fe,%edx
  4e:	eb d9                	jmp    29 <main+0x29>
  exit(0);
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	6a 00                	push   $0x0
  55:	e8 08 00 00 00       	call   62 <exit>

0000005a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  5a:	b8 01 00 00 00       	mov    $0x1,%eax
  5f:	cd 40                	int    $0x40
  61:	c3                   	ret    

00000062 <exit>:
SYSCALL(exit)
  62:	b8 02 00 00 00       	mov    $0x2,%eax
  67:	cd 40                	int    $0x40
  69:	c3                   	ret    

0000006a <wait>:
SYSCALL(wait)
  6a:	b8 03 00 00 00       	mov    $0x3,%eax
  6f:	cd 40                	int    $0x40
  71:	c3                   	ret    

00000072 <pipe>:
SYSCALL(pipe)
  72:	b8 04 00 00 00       	mov    $0x4,%eax
  77:	cd 40                	int    $0x40
  79:	c3                   	ret    

0000007a <read>:
SYSCALL(read)
  7a:	b8 05 00 00 00       	mov    $0x5,%eax
  7f:	cd 40                	int    $0x40
  81:	c3                   	ret    

00000082 <write>:
SYSCALL(write)
  82:	b8 10 00 00 00       	mov    $0x10,%eax
  87:	cd 40                	int    $0x40
  89:	c3                   	ret    

0000008a <close>:
SYSCALL(close)
  8a:	b8 15 00 00 00       	mov    $0x15,%eax
  8f:	cd 40                	int    $0x40
  91:	c3                   	ret    

00000092 <kill>:
SYSCALL(kill)
  92:	b8 06 00 00 00       	mov    $0x6,%eax
  97:	cd 40                	int    $0x40
  99:	c3                   	ret    

0000009a <exec>:
SYSCALL(exec)
  9a:	b8 07 00 00 00       	mov    $0x7,%eax
  9f:	cd 40                	int    $0x40
  a1:	c3                   	ret    

000000a2 <open>:
SYSCALL(open)
  a2:	b8 0f 00 00 00       	mov    $0xf,%eax
  a7:	cd 40                	int    $0x40
  a9:	c3                   	ret    

000000aa <mknod>:
SYSCALL(mknod)
  aa:	b8 11 00 00 00       	mov    $0x11,%eax
  af:	cd 40                	int    $0x40
  b1:	c3                   	ret    

000000b2 <unlink>:
SYSCALL(unlink)
  b2:	b8 12 00 00 00       	mov    $0x12,%eax
  b7:	cd 40                	int    $0x40
  b9:	c3                   	ret    

000000ba <fstat>:
SYSCALL(fstat)
  ba:	b8 08 00 00 00       	mov    $0x8,%eax
  bf:	cd 40                	int    $0x40
  c1:	c3                   	ret    

000000c2 <link>:
SYSCALL(link)
  c2:	b8 13 00 00 00       	mov    $0x13,%eax
  c7:	cd 40                	int    $0x40
  c9:	c3                   	ret    

000000ca <mkdir>:
SYSCALL(mkdir)
  ca:	b8 14 00 00 00       	mov    $0x14,%eax
  cf:	cd 40                	int    $0x40
  d1:	c3                   	ret    

000000d2 <chdir>:
SYSCALL(chdir)
  d2:	b8 09 00 00 00       	mov    $0x9,%eax
  d7:	cd 40                	int    $0x40
  d9:	c3                   	ret    

000000da <dup>:
SYSCALL(dup)
  da:	b8 0a 00 00 00       	mov    $0xa,%eax
  df:	cd 40                	int    $0x40
  e1:	c3                   	ret    

000000e2 <getpid>:
SYSCALL(getpid)
  e2:	b8 0b 00 00 00       	mov    $0xb,%eax
  e7:	cd 40                	int    $0x40
  e9:	c3                   	ret    

000000ea <sbrk>:
SYSCALL(sbrk)
  ea:	b8 0c 00 00 00       	mov    $0xc,%eax
  ef:	cd 40                	int    $0x40
  f1:	c3                   	ret    

000000f2 <sleep>:
SYSCALL(sleep)
  f2:	b8 0d 00 00 00       	mov    $0xd,%eax
  f7:	cd 40                	int    $0x40
  f9:	c3                   	ret    

000000fa <uptime>:
SYSCALL(uptime)
  fa:	b8 0e 00 00 00       	mov    $0xe,%eax
  ff:	cd 40                	int    $0x40
 101:	c3                   	ret    

00000102 <date>:
SYSCALL(date)
 102:	b8 16 00 00 00       	mov    $0x16,%eax
 107:	cd 40                	int    $0x40
 109:	c3                   	ret    

0000010a <dup2>:
 10a:	b8 17 00 00 00       	mov    $0x17,%eax
 10f:	cd 40                	int    $0x40
 111:	c3                   	ret    

00000112 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
 115:	83 ec 1c             	sub    $0x1c,%esp
 118:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 11b:	6a 01                	push   $0x1
 11d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 120:	52                   	push   %edx
 121:	50                   	push   %eax
 122:	e8 5b ff ff ff       	call   82 <write>
}
 127:	83 c4 10             	add    $0x10,%esp
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	57                   	push   %edi
 130:	56                   	push   %esi
 131:	53                   	push   %ebx
 132:	83 ec 2c             	sub    $0x2c,%esp
 135:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 138:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 13a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 13e:	74 04                	je     144 <printint+0x18>
 140:	85 d2                	test   %edx,%edx
 142:	78 3a                	js     17e <printint+0x52>
  neg = 0;
 144:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 14b:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 150:	89 f0                	mov    %esi,%eax
 152:	ba 00 00 00 00       	mov    $0x0,%edx
 157:	f7 f1                	div    %ecx
 159:	89 df                	mov    %ebx,%edi
 15b:	43                   	inc    %ebx
 15c:	8a 92 0c 03 00 00    	mov    0x30c(%edx),%dl
 162:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 166:	89 f2                	mov    %esi,%edx
 168:	89 c6                	mov    %eax,%esi
 16a:	39 d1                	cmp    %edx,%ecx
 16c:	76 e2                	jbe    150 <printint+0x24>
  if(neg)
 16e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 172:	74 22                	je     196 <printint+0x6a>
    buf[i++] = '-';
 174:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 179:	8d 5f 02             	lea    0x2(%edi),%ebx
 17c:	eb 18                	jmp    196 <printint+0x6a>
    x = -xx;
 17e:	f7 de                	neg    %esi
    neg = 1;
 180:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 187:	eb c2                	jmp    14b <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 189:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 18e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 191:	e8 7c ff ff ff       	call   112 <putc>
  while(--i >= 0)
 196:	4b                   	dec    %ebx
 197:	79 f0                	jns    189 <printint+0x5d>
}
 199:	83 c4 2c             	add    $0x2c,%esp
 19c:	5b                   	pop    %ebx
 19d:	5e                   	pop    %esi
 19e:	5f                   	pop    %edi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    

000001a1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1a1:	f3 0f 1e fb          	endbr32 
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	57                   	push   %edi
 1a9:	56                   	push   %esi
 1aa:	53                   	push   %ebx
 1ab:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1ae:	8d 45 10             	lea    0x10(%ebp),%eax
 1b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1b4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1b9:	bb 00 00 00 00       	mov    $0x0,%ebx
 1be:	eb 12                	jmp    1d2 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1c0:	89 fa                	mov    %edi,%edx
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	e8 48 ff ff ff       	call   112 <putc>
 1ca:	eb 05                	jmp    1d1 <printf+0x30>
      }
    } else if(state == '%'){
 1cc:	83 fe 25             	cmp    $0x25,%esi
 1cf:	74 22                	je     1f3 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1d1:	43                   	inc    %ebx
 1d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d5:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1d8:	84 c0                	test   %al,%al
 1da:	0f 84 13 01 00 00    	je     2f3 <printf+0x152>
    c = fmt[i] & 0xff;
 1e0:	0f be f8             	movsbl %al,%edi
 1e3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1e6:	85 f6                	test   %esi,%esi
 1e8:	75 e2                	jne    1cc <printf+0x2b>
      if(c == '%'){
 1ea:	83 f8 25             	cmp    $0x25,%eax
 1ed:	75 d1                	jne    1c0 <printf+0x1f>
        state = '%';
 1ef:	89 c6                	mov    %eax,%esi
 1f1:	eb de                	jmp    1d1 <printf+0x30>
      if(c == 'd'){
 1f3:	83 f8 64             	cmp    $0x64,%eax
 1f6:	74 43                	je     23b <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 1f8:	83 f8 78             	cmp    $0x78,%eax
 1fb:	74 68                	je     265 <printf+0xc4>
 1fd:	83 f8 70             	cmp    $0x70,%eax
 200:	74 63                	je     265 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 202:	83 f8 73             	cmp    $0x73,%eax
 205:	0f 84 84 00 00 00    	je     28f <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 20b:	83 f8 63             	cmp    $0x63,%eax
 20e:	0f 84 ad 00 00 00    	je     2c1 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 214:	83 f8 25             	cmp    $0x25,%eax
 217:	0f 84 c2 00 00 00    	je     2df <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 21d:	ba 25 00 00 00       	mov    $0x25,%edx
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	e8 e8 fe ff ff       	call   112 <putc>
        putc(fd, c);
 22a:	89 fa                	mov    %edi,%edx
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	e8 de fe ff ff       	call   112 <putc>
      }
      state = 0;
 234:	be 00 00 00 00       	mov    $0x0,%esi
 239:	eb 96                	jmp    1d1 <printf+0x30>
        printint(fd, *ap, 10, 1);
 23b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 23e:	8b 17                	mov    (%edi),%edx
 240:	83 ec 0c             	sub    $0xc,%esp
 243:	6a 01                	push   $0x1
 245:	b9 0a 00 00 00       	mov    $0xa,%ecx
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	e8 da fe ff ff       	call   12c <printint>
        ap++;
 252:	83 c7 04             	add    $0x4,%edi
 255:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 258:	83 c4 10             	add    $0x10,%esp
      state = 0;
 25b:	be 00 00 00 00       	mov    $0x0,%esi
 260:	e9 6c ff ff ff       	jmp    1d1 <printf+0x30>
        printint(fd, *ap, 16, 0);
 265:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 268:	8b 17                	mov    (%edi),%edx
 26a:	83 ec 0c             	sub    $0xc,%esp
 26d:	6a 00                	push   $0x0
 26f:	b9 10 00 00 00       	mov    $0x10,%ecx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	e8 b0 fe ff ff       	call   12c <printint>
        ap++;
 27c:	83 c7 04             	add    $0x4,%edi
 27f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 282:	83 c4 10             	add    $0x10,%esp
      state = 0;
 285:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 28a:	e9 42 ff ff ff       	jmp    1d1 <printf+0x30>
        s = (char*)*ap;
 28f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 292:	8b 30                	mov    (%eax),%esi
        ap++;
 294:	83 c0 04             	add    $0x4,%eax
 297:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 29a:	85 f6                	test   %esi,%esi
 29c:	75 13                	jne    2b1 <printf+0x110>
          s = "(null)";
 29e:	be 05 03 00 00       	mov    $0x305,%esi
 2a3:	eb 0c                	jmp    2b1 <printf+0x110>
          putc(fd, *s);
 2a5:	0f be d2             	movsbl %dl,%edx
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	e8 62 fe ff ff       	call   112 <putc>
          s++;
 2b0:	46                   	inc    %esi
        while(*s != 0){
 2b1:	8a 16                	mov    (%esi),%dl
 2b3:	84 d2                	test   %dl,%dl
 2b5:	75 ee                	jne    2a5 <printf+0x104>
      state = 0;
 2b7:	be 00 00 00 00       	mov    $0x0,%esi
 2bc:	e9 10 ff ff ff       	jmp    1d1 <printf+0x30>
        putc(fd, *ap);
 2c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2c4:	0f be 17             	movsbl (%edi),%edx
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	e8 43 fe ff ff       	call   112 <putc>
        ap++;
 2cf:	83 c7 04             	add    $0x4,%edi
 2d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2d5:	be 00 00 00 00       	mov    $0x0,%esi
 2da:	e9 f2 fe ff ff       	jmp    1d1 <printf+0x30>
        putc(fd, c);
 2df:	89 fa                	mov    %edi,%edx
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	e8 29 fe ff ff       	call   112 <putc>
      state = 0;
 2e9:	be 00 00 00 00       	mov    $0x0,%esi
 2ee:	e9 de fe ff ff       	jmp    1d1 <printf+0x30>
    }
  }
}
 2f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5f                   	pop    %edi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    
